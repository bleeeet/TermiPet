import AppKit
import TermiPetCore
import SwiftUI

struct FloatingCommandRootView: View {
    let configuration: CommandConfiguration
    @ObservedObject var petSelection: PetPackageSelection
    @ObservedObject var previewStore: PreviewStore
    @ObservedObject var contextStore: CodingContextStore
    @ObservedObject var skinStore: AppSkinObservableStore
    @ObservedObject var hoverState: HoverState
    @ObservedObject var pomodoro: PomodoroTimer
    let commandPanelController: CommandPanelController
    @ObservedObject var chatStore: ChatStore
    let petWindow: @MainActor () -> NSWindow?
    let inputText: @MainActor (String) -> Void
    let handleApproval: @MainActor (ApprovalPrompt, ApprovalAction) -> Bool
    let activateTargetApplication: @MainActor () -> Void
    let activatePreviewTarget: @MainActor (WorkspacePreviewItem) -> Bool
    let chooseFolder: @MainActor () -> Void
    let quit: @MainActor () -> Void
    let openSettings: @MainActor () -> Void
    let activeChanged: @MainActor (Bool) -> Void
    let setChatWindowFocus: @MainActor (Bool) -> Void
    @ObservedObject var configurationRefresh: CommandConfigurationRefresh

    @State private var active = false
    @State private var commandsExpanded = false
    @State private var commandPanelPinned = false
    @State private var chatExpanded = false
    @State private var chatInput = ""
    @State private var hoverVisibility = HoverVisibilityController()
    @State private var collapseTask: Task<Void, Never>?
    @State private var petActionPreview = PetActionPreviewController()
    @State private var petActionTask: Task<Void, Never>?
    @State private var userCommands: [FloatingCommand]
    @State private var commandOrder: [FloatingCommand.ID]
    @State private var pinnedCommandIDs: [FloatingCommand.ID]
    @State private var showingAddCommand = false
    @State private var newCommandDraft = NewCommandDraft()
    @State private var isAgentStickyVisible = false
    @State private var hoveredPreviewItemID: WorkspacePreviewItem.ID?
    @State private var language = AppLanguageStore().load()
    @StateObject private var quotaStore = UsageQuotaStore()
    @StateObject private var dragAnimation = PetDragAnimationController()

    private var localizer: AppLocalizer {
        AppLocalizer(language: language)
    }

    init(
        configuration: CommandConfiguration,
        petSelection: PetPackageSelection,
        previewStore: PreviewStore,
        contextStore: CodingContextStore,
        skinStore: AppSkinObservableStore,
        hoverState: HoverState,
        pomodoro: PomodoroTimer,
        commandPanelController: CommandPanelController,
        chatStore: ChatStore,
        petWindow: @escaping @MainActor () -> NSWindow?,
        inputText: @escaping @MainActor (String) -> Void,
        handleApproval: @escaping @MainActor (ApprovalPrompt, ApprovalAction) -> Bool,
        activateTargetApplication: @escaping @MainActor () -> Void,
        activatePreviewTarget: @escaping @MainActor (WorkspacePreviewItem) -> Bool,
        chooseFolder: @escaping @MainActor () -> Void,
        quit: @escaping @MainActor () -> Void,
        openSettings: @escaping @MainActor () -> Void,
        activeChanged: @escaping @MainActor (Bool) -> Void,
        setChatWindowFocus: @escaping @MainActor (Bool) -> Void,
        configurationRefresh: CommandConfigurationRefresh = CommandConfigurationRefresh()
    ) {
        self.configuration = configuration
        self.petSelection = petSelection
        self.previewStore = previewStore
        self.contextStore = contextStore
        self.skinStore = skinStore
        self.hoverState = hoverState
        self.pomodoro = pomodoro
        self.commandPanelController = commandPanelController
        self.chatStore = chatStore
        self.petWindow = petWindow
        self.inputText = inputText
        self.handleApproval = handleApproval
        self.activateTargetApplication = activateTargetApplication
        self.activatePreviewTarget = activatePreviewTarget
        self.chooseFolder = chooseFolder
        self.quit = quit
        self.openSettings = openSettings
        self.activeChanged = activeChanged
        self.setChatWindowFocus = setChatWindowFocus
        self.configurationRefresh = configurationRefresh
        _userCommands = State(initialValue: configuration.userCommands)
        _commandOrder = State(initialValue: configuration.commandOrder)
        _pinnedCommandIDs = State(initialValue: configuration.pinnedCommandIDs)
    }

    private static let popSpring: Animation = .spring(response: 0.32, dampingFraction: 0.7)

    var body: some View {
        ZStack(alignment: .bottomLeading) {
            rootContent
                .padding(24)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomLeading)
        .animation(Self.popSpring, value: active)
        .animation(Self.popSpring, value: commandsExpanded)
        .animation(Self.popSpring, value: contextStore.approvalPrompt)
        .onChangeCompat(of: active) { newValue in
            activeChanged(newValue || commandsExpanded || commandPanelPinned || chatExpanded)
        }
        .onChangeCompat(of: commandsExpanded) { newValue in
            activeChanged(newValue || active || commandPanelPinned || chatExpanded)
            syncCommandPanelVisibility()
        }
        .onChangeCompat(of: commandPanelPinned) { newValue in
            activeChanged(active || commandsExpanded || newValue || chatExpanded)
            syncCommandPanelVisibility()
        }
        .onChangeCompat(of: chatExpanded) { newValue in
            activeChanged(active || commandsExpanded || commandPanelPinned || newValue)
            setChatWindowFocus(newValue)
            if newValue {
                commandsExpanded = false
                syncCommandPanelVisibility()
            }
        }
        .onChangeCompat(of: chatStore.isStreaming) { streaming in
            if streaming {
                petActionTask?.cancel()
                _ = petActionPreview.trigger(action: 7)
            } else if petActionPreview.currentAction == 7 {
                petActionPreview.clear()
                triggerPetAction(3)
            }
        }
        .onAppear {
            configureCommandPanel()
            syncCommandPanelVisibility()
        }
        .onChangeCompat(of: hoverState.isHovering) { newValue in
            handleHover(newValue)
        }
        .sheet(isPresented: $showingAddCommand) {
            AddCommandSheet(
                draft: $newCommandDraft,
                onCancel: {
                    dismissAddCommandSheet()
                },
                onConfirm: {
                    addCommand(newCommandDraft)
                    dismissAddCommandSheet()
                }
            )
        }
        .onChangeCompat(of: showingAddCommand) { newValue in
            handleModalPresentationChanged(newValue)
        }
        .onChangeCompat(of: pomodoro.celebratePulse) { _ in
            triggerPetAction(8)
        }
        .onChangeCompat(of: contextStore.agentState) { new in
            handleAgentStateChange(new)
        }
        .onChangeCompat(of: contextStore.currentApp) { newApp in
            handleCurrentAppChange(newApp)
        }
        .onChangeCompat(of: configurationRefresh.token) { _ in
            reloadCommandConfiguration()
        }
        .appSkin(skinStore.skin)
    }

    private var rootContent: some View {
        ZStack(alignment: .bottomLeading) {
            VStack(alignment: .leading, spacing: 8) {
                if showStickyPreview {
                    stickyPreviewStack
                        .padding(.leading, 10)
                        .transition(panelTransition)
                        .zIndex(10)
                }

                if chatExpanded {
                    chatOverlay
                        .padding(.leading, 10)
                        .hoverTrackingArea(handleHover)
                        .transition(panelTransition)
                } else if active && !commandsExpanded {
                    quotaStack
                        .padding(.leading, 10)
                        .hoverTrackingArea(handleHover)
                        .transition(panelTransition)
                }

                if active {
                    toolStack
                        .padding(.leading, 10)
                        .hoverTrackingArea(handleHover)
                        .transition(toolStackTransition)
                }

                petBubble
                    .frame(width: 112, height: 112)
                    .hoverTrackingArea(handleHover)
                    .overlay(
                        WindowDragHandle(
                            onDragStart: { dragAnimation.beginDragging() },
                            onDragEnd: { dragAnimation.endDragging() },
                            onDoubleClick: { triggerPetAction(8) }
                        )
                    )
                    .contextMenu {
                        Button(localizer[.contextMenuRandomPet]) {
                            petSelection.selectRandomImportedPackage()
                            triggerPetAction(8)
                        }
                        .disabled(petSelection.importedPackages.isEmpty)
                        Button(localizer[.contextMenuSettings]) {
                            openSettings()
                        }
                        Divider()
                        Button(localizer[.contextMenuQuit]) {
                            quit()
                        }
                    }
            }
        }
        .frame(width: AppSkin.floatingRootWidth, height: 760, alignment: .bottomLeading)
    }

    private var chatOverlay: some View {
        VStack(alignment: .leading, spacing: 0) {
            PetChatView(
                chatStore: chatStore,
                inputText: $chatInput,
                personality: PetPersonalityStore().load(),
                modelConfig: PetChatModelConfigStore().load(),
                onClose: { chatExpanded = false },
                localizer: localizer
            )
            .padding(12)
        }
        .glassPanel(cornerRadius: 18, shadowRadius: 18, shadowY: 6)
    }

    private var panelTransition: AnyTransition {
        .asymmetric(
            insertion: .scale(scale: 0.6, anchor: .bottomLeading)
                .combined(with: .opacity)
                .combined(with: .offset(y: 16)),
            removal: .scale(scale: 0.88, anchor: .bottomLeading)
                .combined(with: .opacity)
        )
    }

    private var toolStackTransition: AnyTransition {
        .asymmetric(
            insertion: .offset(y: 18).combined(with: .opacity),
            removal: .opacity
        )
    }

    private var petBubble: some View {
        petImage
            .frame(width: 112, height: 112)
            .shadow(color: .black.opacity(0.18), radius: 8, y: 4)
            .overlay(alignment: .top) {
                if pomodoro.isActive {
                    countdownBadge
                        .offset(y: -36)
                        .transition(.scale.combined(with: .opacity))
                }
            }
            .animation(Self.popSpring, value: pomodoro.isActive)
            .contentShape(Rectangle())
    }

    private var countdownBadge: some View {
        HStack(spacing: 4) {
            if pomodoro.isPaused {
                Image(systemName: "pause.fill")
                    .font(.system(size: 10, weight: .bold))
            }
            Text(pomodoro.displayText)
                .font(.system(size: 13, weight: .bold, design: .monospaced))
        }
        .foregroundStyle(.primary)
        .padding(.horizontal, 10)
        .padding(.vertical, 4)
        .background(.ultraThinMaterial, in: Capsule())
        .overlay(
            Capsule()
                .strokeBorder(pomodoroAccent, lineWidth: 1)
        )
        .shadow(color: .black.opacity(0.18), radius: 6, y: 2)
        .fixedSize()
    }

    private var pomodoroAccent: Color {
        if pomodoro.isPaused { return .gray }
        switch pomodoro.phase {
        case .work: return .red.opacity(0.7)
        case .breakTime: return .green.opacity(0.7)
        case .idle: return .clear
        }
    }

    private var petImage: some View {
        PetSpriteView(package: petSelection.package, action: petAction)
    }

    private var controlRow: some View {
        HStack(spacing: 8) {
            Button {
                toggleCommandPanel()
            } label: {
                launcherIcon("terminal.fill", isActive: commandsExpanded)
            }
            .buttonStyle(PressableScaleButtonStyle())
            .help(primaryActionHelp)

            Button {
                chooseFolder()
            } label: {
                launcherIcon("folder.fill")
            }
            .buttonStyle(PressableScaleButtonStyle())
            .help(localizer[.tooltipChooseFolderAndCd])

            Button {
                toggleChatPanel()
            } label: {
                launcherIcon("bubble.left.and.bubble.right.fill", isActive: chatExpanded)
            }
            .buttonStyle(PressableScaleButtonStyle())
            .help(localizer[.tooltipChatWithPet])

            Button {
                cycleSkin()
            } label: {
                launcherIcon("paintpalette.fill", isActive: skinStore.skin != .glass)
            }
            .buttonStyle(PressableScaleButtonStyle())
            .help(localizer[.tooltipSwitchSkin])

            Button {
                pomodoro.toggle()
            } label: {
                launcherIcon(pomodoroIcon, isActive: pomodoro.isActive)
                    .foregroundStyle(pomodoroIconTint)
            }
            .buttonStyle(PressableScaleButtonStyle())
            .help(pomodoroHelp)
            .simultaneousGesture(
                TapGesture(count: 2).onEnded {
                    pomodoro.startBreak()
                }
            )

            if pomodoro.isActive {
                Button {
                    pomodoro.stop()
                } label: {
                    launcherIcon("stop.fill")
                }
                .buttonStyle(PressableScaleButtonStyle())
                .help(localizer[.tooltipStopPomodoro])
                .transition(.scale.combined(with: .opacity))

                Button {
                    pomodoro.startBreak()
                } label: {
                    launcherIcon("cup.and.saucer.fill")
                }
                .buttonStyle(PressableScaleButtonStyle())
                .help(localizer[.tooltipStartBreak5])
                .transition(.scale.combined(with: .opacity))
            }
        }
        .padding(6)
        .glassCapsule()
        .animation(Self.popSpring, value: pomodoro.isActive)
    }

    private var toolStack: some View {
        VStack(alignment: .leading, spacing: 7) {
            controlRow
            petActionBar
                .padding(.horizontal, AppSkin.petActionBarHorizontalPadding / 2)
                .padding(.vertical, 5)
                .glassCapsule()
        }
    }

    private var showPreviewCard: Bool {
        previewStore.preview.status != .unavailable
    }

    private var showStickyPreview: Bool {
        PreviewPanelPolicy.shouldShowStickyPreview(
            preview: previewStore.preview,
            agentState: contextStore.agentState
        )
    }

    @ViewBuilder
    private var stickyPreviewStack: some View {
        stickyPreviewContent
            .frame(maxHeight: StickyPreviewLayoutPolicy.maxHeight, alignment: .bottom)
    }

    private var stickyPreviewContent: some View {
        VStack(alignment: .leading, spacing: 8) {
            let visibleItems = StickyPreviewLayoutPolicy.visibleItems(from: previewStore.items)
            if visibleItems.isEmpty, showPreviewCard {
                previewCard(for: WorkspacePreviewItem(id: "regular", source: .terminal, preview: previewStore.preview))
            } else {
                ForEach(visibleItems) { item in
                    previewCard(for: item)
                }
            }
        }
    }

    private var quotaStack: some View {
        VStack(alignment: .leading, spacing: 8) {
            UsageQuotaCardView(store: quotaStore, localizer: localizer)
        }
    }

    private func previewCard(for item: WorkspacePreviewItem) -> some View {
        ZStack(alignment: .topTrailing) {
            VStack(alignment: .leading, spacing: 7) {
                HStack(spacing: 8) {
                    statusIndicator(for: item.status)

                    Text(item.title)
                        .font(.system(size: 13, weight: .bold))
                        .lineLimit(1)
                        .padding(.trailing, 20)
                }

                Text(item.summary)
                    .font(.system(size: 13, weight: .semibold))
                    .lineLimit(3)

                if let detail = item.detail {
                    Text(detail)
                        .font(.system(size: 11, weight: .medium))
                        .foregroundStyle(.secondary)
                        .lineLimit(2)
                }

                if let prompt = approvalPrompt(for: item) {
                    approvalActionRow(prompt)
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .contentShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
            .onTapGesture {
                handlePreviewCardTap(item)
            }

            if hoveredPreviewItemID == item.id {
                Button {
                    dismissPreviewCard(item)
                } label: {
                    Image(systemName: "xmark")
                        .font(.system(size: 10, weight: .bold))
                        .frame(width: 20, height: 20)
                        .background(.regularMaterial, in: Circle())
                        .overlay(Circle().strokeBorder(Color.white.opacity(0.22), lineWidth: 0.8))
                }
                .buttonStyle(.plain)
                .foregroundStyle(.secondary)
                .help(localizer[.tooltipCloseStatus])
                .padding(.top, -3)
                .padding(.trailing, -3)
                .transition(.scale(scale: 0.85).combined(with: .opacity))
            }
        }
        .padding(13)
        .frame(width: 260, alignment: .leading)
        .onHover { hovering in
            hoveredPreviewItemID = hovering ? item.id : (hoveredPreviewItemID == item.id ? nil : hoveredPreviewItemID)
        }
        .animation(Self.popSpring, value: hoveredPreviewItemID)
        .glassPanel(cornerRadius: 16, shadowRadius: 16, shadowY: 7)
    }

    @ViewBuilder
    private func statusIndicator(for status: TerminalPreview.Status) -> some View {
        Group {
            if status == .running {
                ProgressView()
                    .controlSize(.small)
                    .scaleEffect(0.52)
            } else {
                Circle()
                    .fill(statusColor(for: status))
            }
        }
        .frame(width: 10, height: 10)
    }

    private var petActionBar: some View {
        HStack(spacing: AppSkin.petActionButtonSpacing) {
            ForEach(petActions) { action in
                Button {
                    triggerPetAction(action.index)
                } label: {
                    Text(action.icon)
                        .font(.system(size: 14))
                        .glassIconButton(isActive: petActionPreview.currentAction == action.index)
                }
                .buttonStyle(PressableScaleButtonStyle())
                .help(action.title)
            }
        }
        .fixedSize()
        .animation(Self.popSpring, value: petActionPreview.currentAction)
    }

    private var pomodoroIcon: String {
        if pomodoro.isPaused { return "pause.fill" }
        switch pomodoro.phase {
        case .idle, .work: return "timer"
        case .breakTime: return "cup.and.saucer.fill"
        }
    }

    private var pomodoroIconTint: Color {
        if pomodoro.isPaused { return .gray }
        switch pomodoro.phase {
        case .work: return .red
        case .breakTime: return .green
        case .idle: return .primary
        }
    }

    private var pomodoroHelp: String {
        switch pomodoro.phase {
        case .idle:
            return localizer[.pomodoroStart25]
        case .work:
            let template = pomodoro.isPaused
                ? localizer[.pomodoroPausedRemain]
                : localizer[.pomodoroWorkingRemain]
            return String(format: template, pomodoro.displayText)
        case .breakTime:
            let template = pomodoro.isPaused
                ? localizer[.pomodoroBreakPausedRemain]
                : localizer[.pomodoroBreakingRemain]
            return String(format: template, pomodoro.displayText)
        }
    }

    private var primaryActionHelp: String {
        switch configuration.primaryAction {
        case .toggleCommands:
            localizer[.statusCommandsTab]
        case .insertText(let command):
            command.title
        }
    }

    private var statusColor: Color {
        statusColor(for: previewStore.preview.status)
    }

    private func statusColor(for status: TerminalPreview.Status) -> Color {
        switch status {
        case .error:
            .red
        case .warning:
            .orange
        case .running:
            .blue
        case .idle:
            .green
        case .unavailable:
            .secondary
        }
    }

    private func approvalPrompt(for item: WorkspacePreviewItem) -> ApprovalPrompt? {
        guard let prompt = contextStore.approvalPrompt else { return nil }
        switch (prompt.source, item.source) {
        case (.claude, .claude):
            return prompt
        case (.terminal, .terminal):
            return prompt
        default:
            return item.id == "regular" ? prompt : nil
        }
    }

    private func approvalActionRow(_ prompt: ApprovalPrompt) -> some View {
        HStack(spacing: 8) {
            Button {
                _ = handleApproval(prompt, prompt.action)
            } label: {
                HStack(spacing: 5) {
                    Image(systemName: "checkmark.circle.fill")
                        .imageScale(.small)
                    Text("Allow")
                        .font(.system(size: 12, weight: .bold))
                }
                .padding(.horizontal, 10)
                .padding(.vertical, 6)
                .background(Color.green.opacity(0.18), in: Capsule())
                .overlay(Capsule().strokeBorder(Color.green.opacity(0.38), lineWidth: 0.8))
            }
            .buttonStyle(.plain)
            .help(String(format: localizer[.statusAllowHint], prompt.executionHint))

            if let deny = prompt.denyAction {
                Button {
                    _ = handleApproval(prompt, deny)
                } label: {
                    HStack(spacing: 5) {
                        Image(systemName: "xmark.circle.fill")
                            .imageScale(.small)
                        Text("Deny")
                            .font(.system(size: 12, weight: .bold))
                    }
                    .padding(.horizontal, 10)
                    .padding(.vertical, 6)
                    .background(Color.red.opacity(0.14), in: Capsule())
                    .overlay(Capsule().strokeBorder(Color.red.opacity(0.28), lineWidth: 0.8))
                }
                .buttonStyle(.plain)
                .help(localizer[.statusDenyAuth])
            }

            Text(prompt.executionHint)
                .font(.system(size: 11, weight: .semibold))
                .foregroundStyle(.secondary)
                .lineLimit(1)
        }
        .padding(.top, 2)
    }

    private func skinIcon(for skin: AppSkin) -> String {
        switch skin {
        case .glass: return "sparkles"
        case .dark: return "moon.fill"
        case .pixel: return "square.grid.3x3.fill"
        }
    }

    private var petAction: Int {
        PetActionResolver.resolve(
            isDragging: dragAnimation.isDragging,
            previewAction: petActionPreview.currentAction,
            commandsExpanded: commandsExpanded,
            suggestedAction: contextStore.suggestedPetAction(currentTerminalStatus: previewStore.preview.status)
        )
    }

    private var petActions: [PetActionButton] {
        let icons = PetActionIcons.defaults
        return [
            .init(title: localizer[.actionIdle], icon: icons[0], index: 0),
            .init(title: localizer[.actionRun], icon: icons[1], index: 1),
            .init(title: localizer[.actionMove], icon: icons[2], index: 2),
            .init(title: localizer[.actionHappy], icon: icons[3], index: 3),
            .init(title: localizer[.actionAlert], icon: icons[4], index: 4),
            .init(title: localizer[.actionError], icon: icons[5], index: 5),
            .init(title: localizer[.actionSleep], icon: icons[6], index: 6),
            .init(title: localizer[.actionThink], icon: icons[7], index: 7),
            .init(title: localizer[.actionCelebrate], icon: icons[8], index: 8),
        ]
    }

    private func launcherIcon(_ systemName: String, isActive: Bool = false) -> some View {
        Image(systemName: systemName)
            .font(.system(size: 15, weight: .semibold))
            .symbolVariant(.none)
            .imageScale(.medium)
            .frame(width: 18, height: 18)
            .glassIconButton(isActive: isActive)
    }

    private func cycleSkin() {
        let skins = AppSkin.allCases
        guard let currentIndex = skins.firstIndex(of: skinStore.skin) else {
            skinStore.skin = .glass
            return
        }
        let nextIndex = skins.index(after: currentIndex)
        skinStore.skin = nextIndex == skins.endIndex ? skins[0] : skins[nextIndex]
    }

    private func handleHover(_ hovering: Bool) {
        let token = hoverVisibility.handle(hovering ? .petEntered : .petExited)

        if hovering {
            active = true
            Task { await quotaStore.refreshIfStale() }
        }

        syncCommandPanelVisibility()
        scheduleHideIfNeeded(token)
    }

    private func handlePanelHover(_ hovering: Bool) {
        let token = hoverVisibility.handle(hovering ? .panelEntered : .panelExited)
        syncCommandPanelVisibility()
        scheduleHideIfNeeded(token)
    }

    private func handleModalPresentationChanged(_ isPresented: Bool) {
        let token = hoverVisibility.handle(.modalPresentationChanged(isPresented))
        syncCommandPanelVisibility()
        scheduleHideIfNeeded(token)
    }

    private func toggleCommandPanel() {
        commandsExpanded.toggle()
        active = true

        if commandsExpanded {
            _ = hoverVisibility.handle(.petEntered)
        } else if !commandPanelPinned {
            _ = hoverVisibility.handle(.pinChanged(false))
        }

        syncCommandPanelVisibility()
    }

    private func toggleCommandPanelPinned() {
        commandPanelPinned.toggle()
        commandsExpanded = true
        active = true
        let token = hoverVisibility.handle(.pinChanged(commandPanelPinned))
        syncCommandPanelVisibility()
        scheduleHideIfNeeded(token)
    }

    private func scheduleHideIfNeeded(_ token: UUID?) {
        collapseTask?.cancel()
        guard let token else { return }

        collapseTask = Task { @MainActor in
            try? await Task.sleep(for: .milliseconds(420))
            guard !Task.isCancelled, !dragAnimation.isDragging else { return }
            _ = hoverVisibility.handle(.hideDelayElapsed(token))

            if !hoverVisibility.state.isVisible && !isAgentStickyVisible && !chatExpanded {
                active = false
                commandsExpanded = commandPanelPinned
            }

            syncCommandPanelVisibility()
        }
    }

    private func configureCommandPanel() {
        commandPanelController.configure(
            commands: currentCommandConfiguration.commands,
            isPinned: commandPanelPinned,
            onTogglePinned: {
                toggleCommandPanelPinned()
            },
            onAddCommandRequested: {
                showAddCommandSheet()
            },
            onDeleteCommand: { command in
                deleteCommand(command)
            },
            onMoveCommand: { id, direction in
                moveCommand(id: id, direction: direction)
            },
            onCommandSelected: { command in
                inputText(command.text)
            },
            onHoverChanged: { hovering in
                handlePanelHover(hovering)
            },
            localizer: localizer,
            skin: skinStore.skin
        )
    }

    private func syncCommandPanelVisibility() {
        configureCommandPanel()

        if commandsExpanded || commandPanelPinned {
            commandPanelController.show(relativeTo: petWindow())
        } else {
            commandPanelController.hide()
        }
    }

    private func addCommand(_ draft: NewCommandDraft) {
        guard draft.isValid else { return }
        let command = FloatingCommand.custom(
            title: draft.trimmedTitle,
            text: draft.trimmedText,
            summary: draft.trimmedSummary
        )
        userCommands.append(command)
        commandOrder.append(command.id)
        saveUserCommands()
        configureCommandPanel()
    }

    private func showAddCommandSheet() {
        newCommandDraft = NewCommandDraft()
        showingAddCommand = true
    }

    private func dismissAddCommandSheet() {
        showingAddCommand = false
        newCommandDraft = NewCommandDraft()
    }

    private func deleteCommand(_ command: FloatingCommand) {
        guard command.isCustom else { return }
        userCommands.removeAll { $0.id == command.id }
        commandOrder.removeAll { $0 == command.id }
        pinnedCommandIDs.removeAll { $0 == command.id }
        saveUserCommands()
        configureCommandPanel()
    }

    private func moveCommand(id: FloatingCommand.ID, direction: MoveDirection) {
        var orderedIDs = currentCommandConfiguration.commands.map(\.id)
        guard let index = orderedIDs.firstIndex(of: id) else { return }
        let target: Int
        switch direction {
        case .up:
            target = index - 1
        case .down:
            target = index + 1
        }
        guard orderedIDs.indices.contains(target) else { return }
        orderedIDs.swapAt(index, target)
        commandOrder = orderedIDs
        pinnedCommandIDs = pinnedCommandIDs.sorted { first, second in
            let firstIndex = orderedIDs.firstIndex(of: first) ?? Int.max
            let secondIndex = orderedIDs.firstIndex(of: second) ?? Int.max
            return firstIndex < secondIndex
        }
        saveUserCommands()
        configureCommandPanel()
    }

    private func saveUserCommands() {
        do {
            try CommandConfigurationStore().save(currentCommandConfiguration)
        } catch {
            print("Failed to save custom commands: \(error.localizedDescription)")
        }
    }

    private func reloadCommandConfiguration() {
        let latest = CommandConfigurationStore().configuration()
        userCommands = latest.userCommands
        commandOrder = latest.commandOrder
        pinnedCommandIDs = latest.pinnedCommandIDs
        configureCommandPanel()
    }

    private var currentCommandConfiguration: CommandConfiguration {
        CommandConfiguration(
            primaryAction: configuration.primaryAction,
            userCommands: userCommands,
            pinnedCommandIDs: pinnedCommandIDs,
            commandOrder: commandOrder
        )
    }

    private func triggerPetAction(_ action: Int) {
        petActionTask?.cancel()
        let token = petActionPreview.trigger(action: action)
        petActionTask = Task { @MainActor in
            try? await Task.sleep(for: .milliseconds(1800))
            guard !Task.isCancelled else { return }
            _ = petActionPreview.expire(token: token)
        }
    }

    private func toggleChatPanel() {
        chatExpanded.toggle()
        active = true
        if chatExpanded {
            _ = hoverVisibility.handle(.petEntered)
        }
    }

    private func handleAgentStateChange(_ new: AgentState) {
        switch new {
        case .working, .waiting, .compacting, .stopped, .error:
            let kind = contextStore.currentApp?.kind
            guard kind != .terminal && kind != .aiChat else { return }
            activateAgentSticky()
        case .idle:
            clearAgentSticky()
        }
    }

    private func handleCurrentAppChange(_ newApp: CodingAppInfo?) {
        guard isAgentStickyVisible else { return }
        let kind = newApp?.kind
        if kind == .terminal || kind == .aiChat {
            clearAgentSticky()
        }
    }

    private func activateAgentSticky() {
        guard !isAgentStickyVisible else { return }
        isAgentStickyVisible = true
        active = true
        collapseTask?.cancel()
    }

    private func clearAgentSticky() {
        isAgentStickyVisible = false
        guard !hoverVisibility.state.shouldRemainVisible else { return }
        guard !chatExpanded else { return }
        active = false
        commandsExpanded = commandPanelPinned
        syncCommandPanelVisibility()
    }

    private func handlePreviewCardTap(_ item: WorkspacePreviewItem) {
        let action = PreviewCardTapPolicy.action(for: item)
        if action.shouldActivateTarget {
            let activated = activatePreviewTarget(item)
            if activated {
                clearAgentSticky()
            }
        }
        if action.shouldDismissPreview {
            previewStore.dismiss(id: item.id)
            if item.source == .claude {
                contextStore.dismissAgentItem(id: item.id)
                clearAgentSticky()
            }
        } else if item.source == .claude {
            clearAgentSticky()
        }
    }

    private func dismissPreviewCard(_ item: WorkspacePreviewItem) {
        hoveredPreviewItemID = nil
        previewStore.dismiss(id: item.id)
        if item.source == .claude {
            contextStore.dismissAgentItem(id: item.id)
            clearAgentSticky()
        }
    }
}

private struct PetActionButton: Identifiable {
    var id: Int { index }
    var title: String
    var icon: String
    var index: Int
}
