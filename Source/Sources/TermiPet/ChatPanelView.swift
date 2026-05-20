import TermiPetCore
import SwiftUI

struct PetChatView: View {
    @ObservedObject var chatStore: ChatStore
    @Binding var inputText: String
    let personality: PetPersonalityConfig
    let modelConfig: PetChatModelConfig
    let onClose: @MainActor () -> Void
    var localizer: AppLocalizer = AppLocalizer()

    @FocusState private var inputFocused: Bool

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            if !chatStore.messages.isEmpty || (chatStore.isStreaming && !chatStore.streamingContent.isEmpty) {
                messagesArea
                    .transition(.opacity.combined(with: .scale(scale: 0.96, anchor: .bottom)))
            }
            inputRow
        }
        .frame(width: 264)
        .onAppear { inputFocused = true }
    }

    private var messagesArea: some View {
        ScrollViewReader { proxy in
            ScrollView(.vertical, showsIndicators: false) {
                VStack(alignment: .leading, spacing: 5) {
                    ForEach(chatStore.messages) { msg in
                        BubbleRow(message: msg)
                            .id(msg.id)
                    }
                    if chatStore.isStreaming && !chatStore.streamingContent.isEmpty {
                        BubbleRow(
                            message: ChatMessage(role: .assistant, content: chatStore.streamingContent)
                        )
                        .id("streaming")
                    }
                    Color.clear.frame(height: 1).id("bottom")
                }
                .padding(.horizontal, 2)
                .padding(.vertical, 4)
            }
            .frame(maxHeight: 210)
            .onChangeCompat(of: chatStore.messages.count) { _ in scrollDown(proxy) }
            .onChangeCompat(of: chatStore.streamingContent.count) { _ in scrollDown(proxy) }
        }
    }

    private var inputRow: some View {
        HStack(spacing: 6) {
            TextField(localizer[.chatInputPlaceholder], text: $inputText)
                .font(.system(size: 13, weight: .medium))
                .textFieldStyle(.plain)
                .focused($inputFocused)
                .padding(.horizontal, 12)
                .padding(.vertical, 9)
                .frame(maxWidth: .infinity)
                .background(.regularMaterial, in: Capsule())
                .overlay(
                    Capsule().strokeBorder(Color.white.opacity(0.22), lineWidth: 0.8)
                )
                .onSubmit { commit() }

            Button {
                if chatStore.isStreaming {
                    chatStore.cancelStreaming()
                } else {
                    commit()
                }
            } label: {
                Image(systemName: chatStore.isStreaming ? "stop.circle.fill" : "arrow.up.circle.fill")
                    .font(.system(size: 28))
                    .foregroundStyle(
                        (chatStore.isStreaming || !inputText.trimmingCharacters(in: .whitespaces).isEmpty)
                            ? Color.blue : Color.secondary
                    )
                    .symbolRenderingMode(.hierarchical)
            }
            .buttonStyle(.plain)
        }
    }

    private func commit() {
        let trimmed = inputText.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return }
        inputText = ""
        chatStore.send(text: trimmed, personality: personality, modelConfig: modelConfig)
    }

    private func scrollDown(_ proxy: ScrollViewProxy) {
        withAnimation(.easeOut(duration: 0.12)) {
            proxy.scrollTo("bottom", anchor: .bottom)
        }
    }
}

private struct BubbleRow: View {
    let message: ChatMessage

    var body: some View {
        HStack(alignment: .bottom, spacing: 0) {
            if message.role == .user {
                Spacer(minLength: 36)
                bubble
            } else {
                bubble
                Spacer(minLength: 36)
            }
        }
    }

    private var bubble: some View {
        Text(message.content)
            .font(.system(size: 13, weight: .medium))
            .foregroundStyle(message.role == .user ? Color.white : Color.primary)
            .padding(.horizontal, 11)
            .padding(.vertical, 8)
            .background(
                Group {
                    if message.role == .user {
                        RoundedRectangle(cornerRadius: 14, style: .continuous)
                            .fill(Color.blue.opacity(0.88))
                    } else {
                        RoundedRectangle(cornerRadius: 14, style: .continuous)
                            .fill(.regularMaterial)
                            .overlay(
                                RoundedRectangle(cornerRadius: 14, style: .continuous)
                                    .strokeBorder(Color.white.opacity(0.22), lineWidth: 0.8)
                            )
                    }
                }
            )
            .textSelection(.enabled)
            .fixedSize(horizontal: false, vertical: true)
    }
}
