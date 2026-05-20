import AppKit
import ApplicationServices
import TermiPetCore

@MainActor
final class GlobalInputController {
    private let targetTracker: TargetApplicationTracker
    private let previewStore: PreviewStore
    private var onAccessibilityMissing: (@MainActor () -> Void)?
    private var lastMissingGuideShownAt: Date?

    init(targetTracker: TargetApplicationTracker, previewStore: PreviewStore) {
        self.targetTracker = targetTracker
        self.previewStore = previewStore
    }

    func setAccessibilityMissingHandler(_ handler: @escaping @MainActor () -> Void) {
        onAccessibilityMissing = handler
    }

    func requestAccessibilityIfNeeded() {
        let options = ["AXTrustedCheckOptionPrompt": true] as CFDictionary
        AXIsProcessTrustedWithOptions(options)
    }

    func insert(_ text: String) {
        targetTracker.refreshFromFrontmostApplication()
        deliver(text)
    }

    func chooseFolderAndInsertCd() {
        targetTracker.refreshFromFrontmostApplication()

        let panel = NSOpenPanel()
        panel.canChooseFiles = false
        panel.canChooseDirectories = true
        panel.allowsMultipleSelection = false
        panel.canCreateDirectories = true
        panel.prompt = "选择"

        NSApp.activate(ignoringOtherApps: true)
        guard panel.runModal() == .OK, let url = panel.url else { return }

        targetTracker.refreshFromFrontmostApplication()
        deliver(ShellCommandFormatter.cdCommand(forPath: url.path))
    }

    func activateLastTargetApplication() {
        guard let targetApplication = targetTracker.currentTargetApplication() else { return }
        activate(application: targetApplication)
    }

    func activatePreviewTarget(_ item: WorkspacePreviewItem) -> Bool {
        guard let application = applicationMatching(
            bundleIdentifier: item.targetBundleIdentifier,
            localizedName: item.targetAppName,
            processIdentifier: item.targetProcessIdentifier
        ) ?? targetTracker.currentTargetApplication() else {
            return false
        }

        activate(application: application, windowTitle: item.targetWindowTitle)
        return true
    }

    func performApprovalAction(_ action: ApprovalAction, prompt: ApprovalPrompt? = nil) -> Bool {
        targetTracker.refreshFromFrontmostApplication()
        guard let targetApplication = applicationMatching(
            bundleIdentifier: prompt?.targetBundleIdentifier,
            localizedName: prompt?.targetAppName,
            processIdentifier: nil
        ) ?? targetTracker.lastTargetApplication() else {
            previewStore.showClipboardFallback(appName: nil)
            return false
        }

        switch action {
        case .pressEnter, .selectHighlightedAllow:
            return sendKey(.returnKey, to: targetApplication, windowTitle: prompt?.detail)
        case .typeYesEnter:
            guard typeUnicodeText("y", into: targetApplication, windowTitle: prompt?.detail) else { return false }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.08) { [weak self, weak targetApplication] in
                guard let targetApplication else { return }
                _ = self?.sendKey(.returnKey, to: targetApplication, windowTitle: prompt?.detail)
            }
            return true
        case .claudeAllow, .claudeDeny:
            return false
        }
    }

    // MARK: - delivery pipeline

    private func deliver(_ text: String) {
        guard let targetApplication = targetTracker.lastTargetApplication() else {
            setClipboard(text)
            previewStore.showClipboardFallback(appName: nil)
            return
        }

        // 优先：终端原生 AppleScript（Terminal/iTerm2，走 scripting 不需要辅助功能）
        if typeWithTerminalScripting(text, targetApplication: targetApplication) {
            previewStore.showInjectionSuccess(appName: targetApplication.localizedName, command: text)
            return
        }

        // 有辅助功能权限：直接 CGEvent 键入 Unicode（适用于 ghostty / Warp / 任何聚焦窗口）
        if AXIsProcessTrusted() {
            if typeUnicodeText(text, into: targetApplication) {
                previewStore.showInjectionSuccess(appName: targetApplication.localizedName, command: text)
                return
            }
            // 罕见：有权限但 CGEvent 失败，回退到剪贴板 + AppleScript paste
            setClipboard(text)
            if pasteWithAppleScript(into: targetApplication) {
                previewStore.showInjectionSuccess(appName: targetApplication.localizedName, command: text)
                return
            }
            previewStore.showClipboardFallback(appName: targetApplication.localizedName)
            return
        }

        // 无辅助功能权限：直接剪贴板 fallback，并节流地弹一次诊断引导（避免反复弹系统对话框）
        setClipboard(text)
        previewStore.showClipboardFallback(appName: targetApplication.localizedName)
        showAccessibilityGuideIfNeeded()
    }

    private func showAccessibilityGuideIfNeeded() {
        let now = Date()
        if let last = lastMissingGuideShownAt, now.timeIntervalSince(last) < 30 {
            return
        }
        lastMissingGuideShownAt = now
        onAccessibilityMissing?()
    }

    private func setClipboard(_ text: String) {
        NSPasteboard.general.clearContents()
        NSPasteboard.general.setString(text, forType: .string)
    }

    // MARK: - direct unicode typing (CGEvent)

    /// 用 CGEvent 直接键入每个字符（无需剪贴板）。对 ghostty / Warp / Alacritty 等没有 AppleScript 接入的终端是最佳路径。
    private func typeUnicodeText(_ text: String, into application: NSRunningApplication, windowTitle: String? = nil) -> Bool {
        guard AXIsProcessTrusted() else { return false }

        activate(application: application, windowTitle: windowTitle)

        // 给目标 app 一点激活时间，再开始键入。整个键入循环放在异步队列以避免阻塞 main。
        let chunks = Array(text.unicodeScalars)
        DispatchQueue.global(qos: .userInitiated).asyncAfter(deadline: .now() + 0.22) {
            guard let source = CGEventSource(stateID: .hidSystemState) else { return }
            for scalar in chunks {
                let str = String(scalar)
                let utf16: [UniChar] = Array(str.utf16)
                utf16.withUnsafeBufferPointer { buffer in
                    if let down = CGEvent(keyboardEventSource: source, virtualKey: 0, keyDown: true) {
                        down.keyboardSetUnicodeString(stringLength: utf16.count, unicodeString: buffer.baseAddress)
                        down.post(tap: .cghidEventTap)
                    }
                    if let up = CGEvent(keyboardEventSource: source, virtualKey: 0, keyDown: false) {
                        up.keyboardSetUnicodeString(stringLength: utf16.count, unicodeString: buffer.baseAddress)
                        up.post(tap: .cghidEventTap)
                    }
                }
                // 小间隔，避免过快丢字符；总耗时对 60 字符以内的快捷指令几乎不可察觉
                usleep(1500)
            }
        }
        return true
    }

    // MARK: - AppleScript fallbacks

    private func pasteWithAppleScript(into application: NSRunningApplication) -> Bool {
        guard let bundleIdentifier = application.bundleIdentifier else {
            return false
        }

        let script = """
        tell application id "\(bundleIdentifier)" to activate
        delay 0.18
        tell application "System Events" to keystroke "v" using command down
        """
        return runAppleScript(script)
    }

    private func activate(application: NSRunningApplication, windowTitle: String? = nil) {
        if let windowTitle {
            activateWindow(titled: windowTitle, in: application)
        }
        if !application.activate(options: [.activateAllWindows]) {
            _ = application.activate(options: [.activateIgnoringOtherApps])
        }
    }

    private enum Key {
        case returnKey

        var code: CGKeyCode {
            switch self {
            case .returnKey: return 36
            }
        }
    }

    private func sendKey(_ key: Key, to application: NSRunningApplication, windowTitle: String? = nil) -> Bool {
        guard AXIsProcessTrusted() else {
            requestAccessibilityIfNeeded()
            return false
        }

        activate(application: application, windowTitle: windowTitle)
        DispatchQueue.global(qos: .userInitiated).asyncAfter(deadline: .now() + 0.18) {
            guard let source = CGEventSource(stateID: .hidSystemState) else { return }
            CGEvent(keyboardEventSource: source, virtualKey: key.code, keyDown: true)?.post(tap: .cghidEventTap)
            CGEvent(keyboardEventSource: source, virtualKey: key.code, keyDown: false)?.post(tap: .cghidEventTap)
        }
        return true
    }

    private func applicationMatching(
        bundleIdentifier: String?,
        localizedName: String?,
        processIdentifier: Int32?
    ) -> NSRunningApplication? {
        let trimmedBundle = bundleIdentifier?.trimmingCharacters(in: .whitespacesAndNewlines)
        let trimmedName = localizedName?.trimmingCharacters(in: .whitespacesAndNewlines)

        return NSWorkspace.shared.runningApplications.first { app in
            guard !app.isTerminated else { return false }
            if let processIdentifier, app.processIdentifier == processIdentifier {
                return true
            }
            if let trimmedBundle, !trimmedBundle.isEmpty, app.bundleIdentifier == trimmedBundle {
                return true
            }
            if let trimmedName, !trimmedName.isEmpty, app.localizedName == trimmedName {
                return true
            }
            return false
        }
    }

    private func activateWindow(titled title: String, in application: NSRunningApplication) {
        guard let bundleIdentifier = application.bundleIdentifier else { return }
        let escapedTitle = appleScriptEscaped(title)

        if bundleIdentifier.lowercased() == "com.apple.terminal" {
            _ = runAppleScript("""
            tell application id "\(bundleIdentifier)"
                activate
                repeat with w in windows
                    if name of w is "\(escapedTitle)" then
                        set index of w to 1
                        exit repeat
                    end if
                end repeat
            end tell
            """)
            return
        }

        if bundleIdentifier.lowercased() == "com.googlecode.iterm2" {
            _ = runAppleScript("""
            tell application id "\(bundleIdentifier)"
                activate
                repeat with w in windows
                    if name of w is "\(escapedTitle)" then
                        select w
                        exit repeat
                    end if
                end repeat
            end tell
            """)
        }
    }

    private func typeWithTerminalScripting(_ text: String, targetApplication: NSRunningApplication) -> Bool {
        guard let bundleIdentifier = targetApplication.bundleIdentifier?.lowercased() else {
            return false
        }

        if bundleIdentifier == "com.apple.terminal" {
            return runAppleScript("""
            tell application id "com.apple.Terminal"
                activate
                do script "\(appleScriptEscaped(text))" in front window
            end tell
            """)
        }

        if bundleIdentifier == "com.googlecode.iterm2" {
            return runAppleScript("""
            tell application id "com.googlecode.iterm2"
                activate
                tell current session of current window to write text "\(appleScriptEscaped(text))"
            end tell
            """)
        }

        return false
    }

    private func runAppleScript(_ script: String) -> Bool {
        var error: NSDictionary?
        guard let appleScript = NSAppleScript(source: script) else {
            return false
        }

        appleScript.executeAndReturnError(&error)
        return error == nil
    }

    private func appleScriptEscaped(_ text: String) -> String {
        text
            .replacingOccurrences(of: "\\", with: "\\\\")
            .replacingOccurrences(of: "\"", with: "\\\"")
    }
}
