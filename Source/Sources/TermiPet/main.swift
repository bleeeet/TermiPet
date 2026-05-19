import AppKit
import TermiPetCore
import SwiftUI

@MainActor
final class AppDelegate: NSObject, NSApplicationDelegate, NSWindowDelegate {
    private var panel: FloatingPanel?
    private var settingsWindow: NSWindow?
    private var statusItem: NSStatusItem?
    private var previewTimer: Timer?
    private var workspaceObservers: [NSObjectProtocol] = []
    private var isUserInteracting = false
    private let targetTracker = TargetApplicationTracker()
    private let previewStore = PreviewStore()
    private let contextStore = CodingContextStore()
    private let skinStore = AppSkinObservableStore()
    private let hoverState = HoverState()
    private lazy var inputController = GlobalInputController(targetTracker: targetTracker, previewStore: previewStore)
    private lazy var terminalInspector = TerminalInspector(targetTracker: targetTracker)
    private lazy var hookServer = ClaudeHookServer(store: contextStore) { [weak self] in
        self?.currentClaudeEventTarget()
    }
    private lazy var jsonlWatcher = ClaudeJSONLWatcher(store: contextStore)
    private let petSelection = PetPackageSelection()
    private let pomodoroTimer = PomodoroTimer()
    private let commandPanelController = CommandPanelController()
    private let chatStore = ChatStore()
    private let language = AppLanguageStore().load()
    private let configurationRefresh = CommandConfigurationRefresh()

    private var hookEnableMenuItem: NSMenuItem?
    private var hookUninstallMenuItem: NSMenuItem?

    private var localizer: AppLocalizer {
        AppLocalizer(language: language)
    }

    func applicationDidFinishLaunching(_ notification: Notification) {
        NSApp.setActivationPolicy(.accessory)

        inputController.setAccessibilityMissingHandler { [weak self] in
            self?.showAccessibilityGuideAlert()
        }

        let content = makeRootView()

        let panel = FloatingPanel(
            contentRect: NSRect(origin: NSPoint(x: 120, y: 520), size: FloatingPanel.collapsedSize),
            backing: .buffered,
            defer: false
        )
        let hostingView = NSHostingView(rootView: content)
        hostingView.wantsLayer = true
        panel.contentView = hostingView
        panel.acceptsMouseMovedEvents = true
        self.panel = panel
        setupMainMenu()
        setupStatusItem()
        startWorkspaceObservers()
        startPreviewTimer()
        startAgentSubsystems()
        refreshPanelVisibility()
    }

    func applicationWillTerminate(_ notification: Notification) {
        for observer in workspaceObservers {
            NSWorkspace.shared.notificationCenter.removeObserver(observer)
        }
        hookServer.stop()
        jsonlWatcher.stop()
    }

    private func makeRootView() -> FloatingCommandRootView {
        FloatingCommandRootView(
            configuration: CommandConfigurationStore().configuration(),
            petSelection: petSelection,
            previewStore: previewStore,
            contextStore: contextStore,
            skinStore: skinStore,
            hoverState: hoverState,
            pomodoro: pomodoroTimer,
            commandPanelController: commandPanelController,
            chatStore: chatStore,
            petWindow: { [weak self] in self?.panel },
            inputText: { [weak inputController] text in
                inputController?.insert(text)
            },
            handleApproval: { [weak self] prompt, action in
                self?.handleApproval(prompt: prompt, action: action) ?? false
            },
            activateTargetApplication: { [weak inputController] in
                inputController?.activateLastTargetApplication()
            },
            activatePreviewTarget: { [weak inputController] item in
                inputController?.activatePreviewTarget(item) ?? false
            },
            chooseFolder: { [weak inputController] in
                inputController?.chooseFolderAndInsertCd()
            },
            quit: {
                NSApp.terminate(nil)
            },
            openSettings: { [weak self] in
                self?.showSettingsWindow()
            },
            activeChanged: { [weak self] active in
                self?.isUserInteracting = active
                self?.refreshPanelVisibility()
            },
            setChatWindowFocus: { [weak self] open in
                self?.panel?.chatIsOpen = open
                if open { self?.panel?.makeKey() }
            },
            configurationRefresh: configurationRefresh
        )
    }

    private func setupStatusItem() {
        let item = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
        if let imageURL = TermiPetResources.pngURL(named: "bar"),
           let image = NSImage(contentsOf: imageURL) {
            let size: CGFloat = 18
            let resized = NSImage(size: NSSize(width: size, height: size))
            resized.lockFocus()
            image.draw(in: NSRect(x: 0, y: 0, width: size, height: size),
                       from: .zero, operation: .copy, fraction: 1.0)
            resized.unlockFocus()
            resized.isTemplate = true
            item.button?.image = resized
        } else {
            item.button?.image = NSImage(systemSymbolName: "terminal", accessibilityDescription: "TermiPet")
        }
        item.button?.imagePosition = .imageOnly
        item.menu = makeStatusMenu()
        statusItem = item
    }

    private func setupMainMenu() {
        let mainMenu = NSMenu()

        let appMenuItem = NSMenuItem()
        let appMenu = NSMenu(title: "TermiPet")
        appMenu.addItem(NSMenuItem(title: localizer[.menuClose], action: AppMainMenuPolicy.closeWindowAction, keyEquivalent: AppMainMenuPolicy.closeWindowKeyEquivalent))
        appMenu.addItem(.separator())
        appMenu.addItem(NSMenuItem(title: localizer[.menuQuit] + " TermiPet", action: #selector(quitFromMenu), keyEquivalent: "q"))
        appMenuItem.submenu = appMenu
        mainMenu.addItem(appMenuItem)

        let editMenuItem = NSMenuItem()
        let editMenu = NSMenu(title: localizer[.menuEdit])
        editMenu.addItem(NSMenuItem(title: localizer[.menuUndo], action: Selector(("undo:")), keyEquivalent: "z"))
        editMenu.addItem(NSMenuItem(title: localizer[.menuRedo], action: Selector(("redo:")), keyEquivalent: "Z"))
        editMenu.addItem(.separator())
        editMenu.addItem(NSMenuItem(title: localizer[.menuCut], action: #selector(NSText.cut(_:)), keyEquivalent: "x"))
        editMenu.addItem(NSMenuItem(title: localizer[.menuCopy], action: #selector(NSText.copy(_:)), keyEquivalent: "c"))
        editMenu.addItem(NSMenuItem(title: localizer[.menuPaste], action: #selector(NSText.paste(_:)), keyEquivalent: "v"))
        editMenu.addItem(NSMenuItem(title: localizer[.menuSelectAll], action: #selector(NSText.selectAll(_:)), keyEquivalent: "a"))
        editMenuItem.submenu = editMenu
        mainMenu.addItem(editMenuItem)

        NSApp.mainMenu = mainMenu
    }

    private func makeStatusMenu() -> NSMenu {
        let menu = NSMenu()
        menu.addItem(NSMenuItem(title: localizer[.menuShowPet], action: #selector(showPetFromMenu), keyEquivalent: ""))
        menu.addItem(NSMenuItem(title: localizer[.menuSettings], action: #selector(openSettingsFromMenu), keyEquivalent: ","))
        menu.addItem(NSMenuItem(title: localizer[.menuRequestAccessibility], action: #selector(requestAccessibilityFromMenu), keyEquivalent: ""))
        menu.addItem(NSMenuItem(title: localizer[.menuOpenAccessibility], action: #selector(openAccessibilitySettingsFromMenu), keyEquivalent: ""))
        menu.addItem(.separator())

        let install = NSMenuItem(title: localizer[.menuInstallHook], action: #selector(installHookFromMenu), keyEquivalent: "")
        let uninstall = NSMenuItem(title: localizer[.menuUninstallHook], action: #selector(uninstallHookFromMenu), keyEquivalent: "")
        menu.addItem(install)
        menu.addItem(uninstall)
        hookEnableMenuItem = install
        hookUninstallMenuItem = uninstall

        menu.addItem(.separator())
        menu.addItem(NSMenuItem(title: localizer[.menuResetAccessibility], action: #selector(resetAccessibilityFromMenu), keyEquivalent: ""))
        menu.addItem(NSMenuItem(title: localizer[.menuQuit], action: #selector(quitFromMenu), keyEquivalent: "q"))
        for item in menu.items {
            item.target = self
        }
        refreshHookMenuState()
        return menu
    }

    @objc private func showPetFromMenu() {
        panel?.orderFrontRegardless()
    }

    @objc private func openSettingsFromMenu() {
        showSettingsWindow()
    }

    @objc private func requestAccessibilityFromMenu() {
        inputController.requestAccessibilityIfNeeded()
    }

    @objc private func openAccessibilitySettingsFromMenu() {
        if let url = URL(string: "x-apple.systempreferences:com.apple.preference.security?Privacy_Accessibility") {
            NSWorkspace.shared.open(url)
        }
    }

    @objc private func installHookFromMenu() {
        do {
            ClaudeHookInstaller.updatePort(hookServer.boundPort)
            try ClaudeHookInstaller.install()
            showAlert(title: localizer[.hookInstalledTitle], message: localizer[.hookInstalledMessage])
        } catch {
            showAlert(title: localizer[.hookInstallFailedTitle], message: error.localizedDescription, style: .warning)
        }
        refreshHookMenuState()
    }

    @objc private func uninstallHookFromMenu() {
        do {
            try ClaudeHookInstaller.uninstall()
            showAlert(title: localizer[.hookUninstalledTitle], message: localizer[.hookUninstalledMessage])
        } catch {
            showAlert(title: localizer[.hookUninstallFailedTitle], message: error.localizedDescription, style: .warning)
        }
        refreshHookMenuState()
    }

    @objc private func resetAccessibilityFromMenu() {
        let bundleId = Bundle.main.bundleIdentifier ?? "local.termipet"
        let task = Process()
        task.launchPath = "/usr/bin/tccutil"
        task.arguments = ["reset", "Accessibility", bundleId]
        let pipe = Pipe()
        task.standardError = pipe
        task.standardOutput = pipe
        do {
            try task.run()
            task.waitUntilExit()
            if task.terminationStatus == 0 {
                showAlert(title: localizer[.accessibilityResetTitle], message: localizer[.accessibilityResetMessage])
            } else {
                let output = String(data: pipe.fileHandleForReading.readDataToEndOfFile(), encoding: .utf8) ?? ""
                showAlert(title: localizer[.accessibilityResetFailedTitle], message: output.isEmpty ? "tccutil exited with status \(task.terminationStatus)" : output, style: .warning)
            }
        } catch {
            showAlert(title: localizer[.accessibilityResetFailedTitle], message: error.localizedDescription, style: .warning)
        }
    }

    private func showAccessibilityGuideAlert() {
        showAlert(title: localizer[.accessibilityNeedsAuthTitle], message: localizer[.accessibilityNeedsAuthMessage], style: .warning)
    }

    @objc private func quitFromMenu() {
        NSApp.terminate(nil)
    }

    @objc func closeWindowFromMenu() {
        if let keyWindow = NSApp.keyWindow, keyWindow.styleMask.contains(.closable) {
            keyWindow.performClose(nil)
            return
        }

        settingsWindow?.performClose(nil)
    }

    private func refreshHookMenuState() {
        let installed = ClaudeHookInstaller.isInstalled
        hookEnableMenuItem?.isEnabled = !installed
        hookEnableMenuItem?.state = installed ? .on : .off
        hookUninstallMenuItem?.isEnabled = installed
    }

    private func showAlert(title: String, message: String, style: NSAlert.Style = .informational) {
        let alert = NSAlert()
        alert.messageText = title
        alert.informativeText = message
        alert.alertStyle = style
        alert.addButton(withTitle: localizer[.alertOK])
        alert.runModal()
    }

    private func showSettingsWindow() {
        if let settingsWindow {
            bringSettingsWindowToFront(settingsWindow)
            return
        }

        let configStore = CommandConfigurationStore()
        let configuration = configStore.configuration()
        let rootView = PetSettingsView(
            selection: petSelection,
            commandConfiguration: configuration,
            choosePetFolder: { [weak self] in
                self?.choosePetFolder()
            },
            onSaveCommandConfiguration: { [weak self] configuration in
                self?.saveCommandConfigurationFromSettings(configuration)
            },
            skinStore: skinStore,
            language: language
        )
        let window = NSWindow(
            contentRect: NSRect(origin: .zero, size: PetSettingsWindowLayout.size),
            styleMask: [.titled, .closable, .miniaturizable],
            backing: .buffered,
            defer: false
        )
        window.title = localizer[.settingsWindowTitle]
        window.titleVisibility = .hidden
        window.titlebarAppearsTransparent = true
        window.styleMask.insert(.fullSizeContentView)
        window.center()
        let hostingView = NSHostingView(rootView: rootView)
        hostingView.wantsLayer = true
        window.contentView = hostingView
        window.backgroundColor = .clear
        window.isOpaque = false
        window.isReleasedWhenClosed = false
        window.level = .floating
        window.delegate = self
        settingsWindow = window
        bringSettingsWindowToFront(window)
    }

    private func bringSettingsWindowToFront(_ window: NSWindow) {
        NSApp.activate(ignoringOtherApps: true)
        window.orderFrontRegardless()
        window.makeKeyAndOrderFront(nil)
    }

    func windowWillClose(_ notification: Notification) {
        guard let closedWindow = notification.object as? NSWindow,
              closedWindow === settingsWindow else { return }
        settingsWindow = nil
    }

    private func saveCommandConfigurationFromSettings(_ configuration: CommandConfiguration) {
        try? CommandConfigurationStore().save(configuration)
        configurationRefresh.refresh()
    }

    private func choosePetFolder() {
        let panel = NSOpenPanel()
        panel.canChooseFiles = false
        panel.canChooseDirectories = true
        panel.allowsMultipleSelection = false
        panel.canCreateDirectories = false
        panel.prompt = localizer[.petFolderPanelPrompt]
        panel.message = localizer[.petFolderPanelMessage]

        guard panel.runModal() == .OK, let url = panel.url else { return }
        petSelection.importAndSelect(folderURL: url)
        refreshPanelVisibility()
    }

    private func startWorkspaceObservers() {
        let center = NSWorkspace.shared.notificationCenter
        workspaceObservers.append(
            center.addObserver(
                forName: NSWorkspace.didActivateApplicationNotification,
                object: nil,
                queue: .main
            ) { [weak self] _ in
                Task { @MainActor in
                    self?.refreshContext()
                    self?.refreshPanelVisibility()
                }
            }
        )
    }

    private func startPreviewTimer() {
        previewTimer?.invalidate()
        previewTimer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            Task { @MainActor in
                guard let self else { return }
                self.contextStore.decayIfStale()
                self.refreshContext()
                self.refreshPanelVisibility()
            }
        }
    }

    private func startAgentSubsystems() {
        hookServer.start()
        ClaudeHookInstaller.updatePort(hookServer.boundPort)
        try? ClaudeHookInstaller.refreshInstalledScriptIfNeeded()
        jsonlWatcher.start()
    }

    private func currentClaudeEventTarget() -> ClaudeEventTarget? {
        let targetApp = targetTracker.lastTargetApplication() ?? targetTracker.currentTargetApplication()
        let ctx = terminalInspector.inspectCodingContext()
        return ClaudeEventTarget(
            appName: targetApp?.localizedName ?? ctx.app?.displayName,
            bundleIdentifier: targetApp?.bundleIdentifier ?? ctx.app?.bundleIdentifier,
            processIdentifier: targetApp?.processIdentifier,
            windowTitle: ctx.windowTitle
        )
    }

    private func refreshContext() {
        targetTracker.refreshFromFrontmostApplication()
        let ctx = terminalInspector.inspectCodingContext()
        contextStore.updateFrontmost(app: ctx.app, title: ctx.windowTitle, file: ctx.fileHint, project: ctx.projectHint)
        previewStore.pruneExpired(maxAge: 120)
        let targetApp = targetTracker.lastTargetApplication()
        let targetAppName = targetApp?.localizedName ?? ctx.app?.displayName
        let targetBundleIdentifier = targetApp?.bundleIdentifier ?? ctx.app?.bundleIdentifier
        let targetProcessIdentifier = targetApp?.processIdentifier
        let targetWindowTitle = ctx.windowTitle

        let card: TerminalPreview
        switch ctx.app?.kind {
        case .terminal:
            // 只要有辅助功能权限，就持续抓终端文本；不再依赖菜单开关
            if AXIsProcessTrusted() {
                let inspected = terminalInspector.inspectForegroundTerminal()
                if inspected.status != .unavailable {
                    card = inspected
                } else {
                    card = TerminalPreview(
                        status: .idle,
                        title: ctx.app?.displayName ?? "Terminal",
                        summary: "已聚焦终端 · 准备好接收快捷指令",
                        detail: ctx.windowTitle
                    )
                }
            } else {
                card = TerminalPreview(
                    status: .warning,
                    title: ctx.app?.displayName ?? "Terminal",
                    summary: "已聚焦终端 · 授予辅助功能权限以读取输出",
                    detail: "菜单 → 打开辅助功能设置"
                )
            }
        case .editor:
            let title = [ctx.app?.displayName, ctx.projectHint].compactMap { $0 }.joined(separator: " · ")
            let summary = contextStore.agentSummary
                ?? ctx.fileHint.map { "正在编辑：\($0)" }
                ?? "已聚焦 \(ctx.app?.displayName ?? "编辑器")"
            card = TerminalPreview(
                status: contextStore.agentState.previewStatus,
                title: title.isEmpty ? (ctx.app?.displayName ?? "Editor") : title,
                summary: summary,
                detail: detailLine(ctx: ctx)
            )
        case .aiChat:
            let summary = contextStore.agentSummary ?? "\(ctx.app?.displayName ?? "AI") 对话中"
            card = TerminalPreview(
                status: contextStore.agentState.previewStatus,
                title: ctx.app?.displayName ?? "AI",
                summary: summary,
                detail: ctx.windowTitle
            )
        case .unknown, .none:
            if contextStore.agentState != .idle {
                card = TerminalPreview(
                    status: contextStore.agentState.previewStatus,
                    title: "Claude Code",
                    summary: contextStore.agentSummary ?? "Claude 运行中",
                    detail: nil
                )
            } else {
                card = .unavailable(appName: ctx.app?.displayName)
            }
        }
        previewStore.setRegular(card)
        previewStore.setSourceItems(terminalInspector.inspectTerminalWindows(), source: .terminal)
        contextStore.attachCurrentTargetToAgentItems(
            appName: targetAppName,
            bundleIdentifier: targetBundleIdentifier,
            processIdentifier: targetProcessIdentifier,
            windowTitle: targetWindowTitle
        )
        previewStore.setSourceItems(contextStore.agentPreviewItems, source: .claude)
        if ctx.app?.kind == .terminal {
            contextStore.updateTerminalApprovalPrompt(terminalInspector.inspectForegroundApprovalPrompt())
        } else {
            contextStore.updateTerminalApprovalPrompt(nil)
        }
    }

    private func handleApproval(prompt: ApprovalPrompt, action: ApprovalAction) -> Bool {
        switch action {
        case .claudeAllow:
            hookServer.resolvePermissionRequest(id: prompt.id, decision: .allow)
            return true
        case .claudeDeny:
            hookServer.resolvePermissionRequest(id: prompt.id, decision: .deny)
            return true
        case .pressEnter, .typeYesEnter, .selectHighlightedAllow:
            let performed = inputController.performApprovalAction(action, prompt: prompt)
            if performed {
                contextStore.clearApprovalPrompt(id: prompt.id)
            }
            return performed
        }
    }

    private func detailLine(ctx: CodingContext) -> String? {
        if let file = ctx.fileHint, let project = ctx.projectHint, !file.contains(project) {
            return "\(project) · \(file)"
        }
        return ctx.fileHint ?? ctx.windowTitle
    }

    private func refreshPanelVisibility() {
        guard let panel else { return }
        panel.orderFrontRegardless()
    }
}

final class FloatingPanel: NSPanel {
    static let collapsedSize = NSSize(width: 398, height: 760)
    static let expandedSize = NSSize(width: 398, height: 760)

    init(contentRect: NSRect, backing: NSWindow.BackingStoreType, defer flag: Bool) {
        super.init(
            contentRect: contentRect,
            styleMask: [.borderless, .nonactivatingPanel],
            backing: backing,
            defer: flag
        )
        isFloatingPanel = true
        level = .statusBar
        collectionBehavior = [.canJoinAllSpaces, .fullScreenAuxiliary]
        backgroundColor = .clear
        isOpaque = false
        hasShadow = false
        hidesOnDeactivate = false
        isMovable = true
        isMovableByWindowBackground = false
    }

    var chatIsOpen = false
    override var canBecomeKey: Bool { chatIsOpen }
    override var canBecomeMain: Bool { false }
}

enum AppMainMenuPolicy {
    static let closeWindowKeyEquivalent = "w"
    static let closeWindowAction = #selector(AppDelegate.closeWindowFromMenu)
}

let app = NSApplication.shared
let delegate = AppDelegate()
app.delegate = delegate
app.run()
