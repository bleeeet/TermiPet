import Combine
import Foundation
import TermiPetCore

@MainActor
final class UsageQuotaStore: ObservableObject {
    typealias Fetch = @Sendable () async -> ServiceQuota

    @Published private(set) var quotas: [AIService: ServiceQuota] = [:]
    @Published private(set) var isRefreshing = false

    private let cacheTTL: TimeInterval
    private let now: @Sendable () -> Date
    private let fetchClaude: Fetch
    private let fetchCodex: Fetch
    private let fetchCopilot: Fetch

    init(
        cacheTTL: TimeInterval = 300,
        now: @escaping @Sendable () -> Date = { Date() },
        fetchClaude: @escaping Fetch = { await ClaudeCodeQuotaFetcher().fetch() },
        fetchCodex: @escaping Fetch = { await CodexQuotaFetcher().fetch() },
        fetchCopilot: @escaping Fetch = { await CopilotQuotaFetcher().fetch() }
    ) {
        self.cacheTTL = cacheTTL
        self.now = now
        self.fetchClaude = fetchClaude
        self.fetchCodex = fetchCodex
        self.fetchCopilot = fetchCopilot
    }

    func refreshIfStale(force: Bool = false) async {
        let services = AIService.allCases.filter { force || isStale(service: $0) }
        guard !services.isEmpty else { return }

        isRefreshing = true
        defer { isRefreshing = false }

        async let claude = services.contains(.claudeCode) ? fetchClaude() : quotas[.claudeCode]
        async let codex = services.contains(.codex) ? fetchCodex() : quotas[.codex]
        async let copilot = services.contains(.copilot) ? fetchCopilot() : quotas[.copilot]

        for quota in await [claude, codex, copilot].compactMap({ $0 }) {
            quotas[quota.service] = quota
        }
    }

    private func isStale(service: AIService) -> Bool {
        guard let quota = quotas[service] else { return true }
        return now().timeIntervalSince(quota.fetchedAt) > cacheTTL
    }
}
