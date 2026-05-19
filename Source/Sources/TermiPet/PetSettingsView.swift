import TermiPetCore
import SwiftUI

struct PetSettingsView: View {
    @ObservedObject var selection: PetPackageSelection
    let choosePetFolder: @MainActor () -> Void
    let onSaveCommandConfiguration: @MainActor (CommandConfiguration) -> Void
    @ObservedObject var skinStore: AppSkinObservableStore
    let language: AppLanguage

    @State private var selectedTab: SettingsTab = .about
    @State private var selectedLanguage: AppLanguage
    @State private var commandConfiguration: CommandConfiguration

    private var localizer: AppLocalizer {
        AppLocalizer(language: selectedLanguage)
    }

    init(
        selection: PetPackageSelection,
        commandConfiguration: CommandConfiguration,
        choosePetFolder: @escaping @MainActor () -> Void,
        onSaveCommandConfiguration: @escaping @MainActor (CommandConfiguration) -> Void,
        skinStore: AppSkinObservableStore,
        language: AppLanguage = AppLanguageStore().load()
    ) {
        self.selection = selection
        self.choosePetFolder = choosePetFolder
        self.onSaveCommandConfiguration = onSaveCommandConfiguration
        self.skinStore = skinStore
        self.language = language
        _selectedLanguage = State(initialValue: language)
        _commandConfiguration = State(initialValue: commandConfiguration)
    }

    enum SettingsTab: CaseIterable {
        case about
        case appearance
        case language
        case commands
        case pet
        case personality
        case model

        var icon: String {
            switch self {
            case .about: return "info"
            case .appearance: return "paintpalette"
            case .language: return "globe"
            case .commands: return "terminal"
            case .pet: return "sparkles"
            case .personality: return "heart.text.square"
            case .model: return "cpu"
            }
        }
    }

    enum Layout {
        static let windowWidth: CGFloat = 860
        static let windowHeight: CGFloat = 580
        static let sidebarWidth: CGFloat = 188
    }

    private var primaryTextColor: Color {
        skinStore.skin.settingsPrimaryTextColor
    }

    private var secondaryTextColor: Color {
        skinStore.skin.settingsSecondaryTextColor
    }

    private var separatorColor: Color {
        skinStore.skin.settingsSeparatorColor
    }

    private var subtleStrokeColor: Color {
        skinStore.skin.settingsSubtleStrokeColor
    }

    private var subtleFillColor: Color {
        skinStore.skin.settingsSubtleFillColor
    }

    var body: some View {
        ZStack(alignment: .topLeading) {
            settingsBackgroundView

            HStack(spacing: 0) {
                sidebar
                    .frame(width: Layout.sidebarWidth)
                    .background(sidebarBackground)

                VStack(spacing: 0) {
                    settingsHeader
                    Rectangle()
                        .fill(separatorColor)
                        .frame(height: 1)
                    selectedTabContent
                        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
                }
            }

            Rectangle()
                .fill(separatorColor)
                .frame(width: PetSettingsWindowLayout.dividerWidth, height: PetSettingsWindowLayout.dividerHeight)
                .offset(x: Layout.sidebarWidth)
        }
        .frame(width: Layout.windowWidth, height: Layout.windowHeight, alignment: .topLeading)
        .foregroundStyle(primaryTextColor)
        .tint(skinStore.skin == .glass ? Color.white : Color.accentColor)
        .appSkin(skinStore.skin)
    }

    private var sidebar: some View {
        VStack(alignment: .leading, spacing: 4) {
            ForEach(SettingsTab.allCases, id: \.self) { tab in
                Button {
                    withAnimation(.spring(response: 0.28, dampingFraction: 0.82)) {
                        selectedTab = tab
                    }
                } label: {
                    HStack(spacing: 10) {
                        tabIcon(tab)

                        Text(title(for: tab))
                            .font(.system(size: 13, weight: .medium))
                            .lineLimit(1)

                        Spacer()
                    }
                    .padding(.horizontal, 12)
                    .padding(.vertical, 9)
                    .background(
                        selectedTab == tab
                            ? Color.accentColor.opacity(0.14)
                            : Color.clear,
                        in: RoundedRectangle(cornerRadius: skinStore.skin == .pixel ? 0 : 7)
                    )
                    .foregroundStyle(selectedTab == tab ? primaryTextColor : secondaryTextColor)
                    .contentShape(Rectangle())
                }
                .buttonStyle(.plain)
                .focusable(false)
            }

            Spacer()
        }
            .padding(.horizontal, 14)
            .padding(.top, 18)
            .padding(.bottom, 14)
        }

    @ViewBuilder
    private func tabIcon(_ tab: SettingsTab) -> some View {
        if tab == .pet,
           let imageURL = TermiPetResources.pngURL(named: "bar"),
           let nsImage = NSImage(contentsOf: imageURL) {
            Image(nsImage: nsImage)
                .renderingMode(.template)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 20, height: 20)
        } else {
            Image(systemName: tab.icon)
                .font(.system(size: 14, weight: .medium))
                .frame(width: 20)
        }
    }

    private var settingsHeader: some View {
        HStack(spacing: 12) {
            Image(systemName: selectedTab.icon)
                .font(.system(size: 17, weight: .semibold))
                .frame(width: 28, height: 28)
                .background(subtleFillColor, in: RoundedRectangle(cornerRadius: skinStore.skin == .pixel ? 0 : 7))

            Text(title(for: selectedTab))
                .font(.system(size: 17, weight: .bold))

            Spacer()
        }
        .padding(.horizontal, 24)
        .frame(height: 58)
        .background(headerBackground)
    }

    private var selectedTabContent: some View {
        Group {
            switch selectedTab {
            case .about:
                AboutTabView(language: selectedLanguage)
            case .appearance:
                appearanceTabContent
            case .language:
                LanguageTabView(selectedLanguage: $selectedLanguage, localizer: localizer)
                    .onChange(of: selectedLanguage) { _, newValue in
                        AppLanguageStore().save(newValue)
                    }
            case .commands:
                CommandsTabView(
                    configuration: $commandConfiguration,
                    onSaveConfiguration: saveCommandConfiguration,
                    localizer: localizer
                )
            case .pet:
                petTabContent
            case .personality:
                PersonalityTabView(localizer: localizer)
            case .model:
                ModelTabView(localizer: localizer)
            }
        }
    }

    private func title(for tab: SettingsTab) -> String {
        switch tab {
        case .about: return localizer[.settingsAbout]
        case .appearance: return localizer[.settingsAppearance]
        case .language: return localizer[.settingsLanguage]
        case .commands: return localizer[.settingsCommands]
        case .pet: return localizer[.settingsPet]
        case .personality: return localizer[.settingsPersonality]
        case .model: return localizer[.settingsModel]
        }
    }

    private var sidebarBackground: some ShapeStyle {
        switch skinStore.skin {
        case .glass: AnyShapeStyle(.regularMaterial.opacity(0.78))
        case .dark: AnyShapeStyle(Color(red: 0.035, green: 0.04, blue: 0.048))
        case .pixel: AnyShapeStyle(Color(red: 0.04, green: 0.07, blue: 0.13))
        }
    }

    private var headerBackground: some ShapeStyle {
        switch skinStore.skin {
        case .glass: AnyShapeStyle(.thinMaterial.opacity(0.78))
        case .dark: AnyShapeStyle(Color(red: 0.032, green: 0.036, blue: 0.043))
        case .pixel: AnyShapeStyle(Color(red: 0.06, green: 0.09, blue: 0.16))
        }
    }

    @ViewBuilder
    private var settingsBackgroundView: some View {
        if skinStore.skin.usesBlurredSettingsWindowBackground {
            ZStack {
                Rectangle()
                    .fill(.regularMaterial)
                LinearGradient(
                    colors: [
                        Color(red: 0.07, green: 0.10, blue: 0.13).opacity(0.50),
                        Color(red: 0.02, green: 0.03, blue: 0.05).opacity(0.68),
                    ],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                Color.white.opacity(0.06)
                    .blendMode(.screen)
            }
        } else {
            switch skinStore.skin {
            case .glass:
                EmptyView()
            case .dark:
                Color(red: 0.025, green: 0.028, blue: 0.034)
            case .pixel:
                Color(red: 0.07, green: 0.10, blue: 0.18)
            }
        }
    }

    private func saveCommandConfiguration(_ configuration: CommandConfiguration) {
        commandConfiguration = configuration
        onSaveCommandConfiguration(configuration)
    }

    private var appearanceTabContent: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 18) {
                Text(localizer[.skinPickerTitle])
                    .font(.system(size: 16, weight: .semibold))

                HStack(spacing: 12) {
                    ForEach(AppSkin.allCases, id: \.self) { skin in
                        Button {
                            skinStore.skin = skin
                        } label: {
                            VStack(alignment: .leading, spacing: 10) {
                                Image(systemName: skinIcon(for: skin))
                                    .font(.system(size: 20, weight: .semibold))
                                Text(skin.displayName)
                                    .font(.system(size: 13, weight: .bold))
                                Text(skinDescription(for: skin))
                                    .font(.system(size: 11, weight: .medium))
                                    .foregroundStyle(secondaryTextColor)
                                    .lineLimit(2)
                            }
                            .frame(maxWidth: .infinity, minHeight: 112, alignment: .topLeading)
                            .padding(14)
                            .background(
                                skinStore.skin == skin ? Color.accentColor.opacity(0.13) : subtleFillColor,
                                in: RoundedRectangle(cornerRadius: skinStore.skin == .pixel ? 0 : 10)
                            )
                            .overlay(
                                RoundedRectangle(cornerRadius: skinStore.skin == .pixel ? 0 : 10)
                                    .strokeBorder(skinStore.skin == skin ? pixelAccentColor : subtleStrokeColor, lineWidth: skinStore.skin == .pixel ? 2 : 1)
                            )
                        }
                        .buttonStyle(PressableScaleButtonStyle())
                        .focusable(false)
                    }
                }

                Spacer(minLength: 0)
            }
            .padding(24)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
    }

    private var petTabContent: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 18) {
                HStack(alignment: .center, spacing: 18) {
                    PetSpriteView(package: selection.package, action: 0)
                        .frame(width: 112, height: 112)
                        .padding(14)
                        .background(.regularMaterial, in: RoundedRectangle(cornerRadius: 8))

                    VStack(alignment: .leading, spacing: 8) {
                        Text(selection.package?.localizedDisplayName(localizer) ?? localizer[.petUnselected])
                            .font(.system(size: 22, weight: .bold))

                        Text(selection.package?.localizedDescription(localizer) ?? localizer[.petSelectPrompt])
                            .font(.system(size: 13, weight: .medium))
                            .foregroundStyle(secondaryTextColor)
                            .lineLimit(4)
                            .fixedSize(horizontal: false, vertical: true)
                    }
                }

                VStack(alignment: .leading, spacing: 7) {
                    Text(localizer[.petCurrentFolder])
                        .font(.system(size: 12, weight: .semibold))
                        .foregroundStyle(secondaryTextColor)

                    Text(selection.package?.folderURL.path ?? localizer[.petNoFolder])
                        .font(.system(size: 12, weight: .medium, design: .monospaced))
                        .textSelection(.enabled)
                        .lineLimit(2)
                }

                if let errorMessage = selection.errorMessage {
                    Text(errorMessage)
                        .font(.system(size: 13, weight: .semibold))
                        .foregroundStyle(.red)
                }

                HStack {
                    Button(localizer[.petImportFolder]) {
                        choosePetFolder()
                    }
                    .keyboardShortcut(.defaultAction)

                    Spacer()
                }

                if !selection.importedPackages.isEmpty {
                    Text(localizer[.petImportedSection])
                        .font(.system(size: 13, weight: .semibold))
                        .foregroundStyle(secondaryTextColor)

                    LazyVGrid(columns: [GridItem(.adaptive(minimum: 170), spacing: 10)], spacing: 10) {
                        ForEach(selection.importedPackages, id: \.folderURL) { package in
                            importedPetCard(package)
                        }
                    }
                }

                Spacer(minLength: 0)
            }
            .padding(24)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
    }

    private func importedPetCard(_ package: PetPackage) -> some View {
        ZStack(alignment: .bottomTrailing) {
            VStack(alignment: .leading, spacing: 8) {
                HStack(spacing: 8) {
                    StaticPetSpriteView(package: package, action: 0, frame: 0)
                        .frame(width: 48, height: 48)
                        .padding(6)
                        .background(subtleFillColor, in: RoundedRectangle(cornerRadius: 6))

                    VStack(alignment: .leading, spacing: 3) {
                        Text(package.localizedDisplayName(localizer))
                            .font(.system(size: 12, weight: .bold))
                            .lineLimit(1)
                        Text(package.localizedDescription(localizer))
                            .font(.system(size: 10, weight: .medium))
                            .foregroundStyle(secondaryTextColor)
                            .lineLimit(3)
                    }
                }

                HStack {
                    Button(selection.package?.folderURL == package.folderURL ? localizer[.petButtonChosen] : localizer[.petButtonChoose]) {
                        selection.select(package: package)
                    }
                    .disabled(selection.package?.folderURL == package.folderURL)

                    Spacer()
                }
            }
            .padding(10)

            if !package.isBuiltIn {
                Button {
                    if canDeleteImportedPets {
                        selection.deleteImportedPackage(package)
                    }
                } label: {
                    Image(systemName: "trash")
                        .font(.system(size: 11, weight: .semibold))
                        .frame(width: 24, height: 24)
                        .foregroundStyle(canDeleteImportedPets ? Color.red : secondaryTextColor.opacity(0.75))
                        .background(subtleFillColor, in: Circle())
                }
                .buttonStyle(.plain)
                .disabled(!canDeleteImportedPets)
                .help(canDeleteImportedPets ? localizer[.petTooltipDelete] : localizer[.petTooltipKeepOne])
                .padding(8)
            }
        }
        .background(subtleFillColor, in: RoundedRectangle(cornerRadius: skinStore.skin == .pixel ? 0 : 9))
        .overlay(
            RoundedRectangle(cornerRadius: skinStore.skin == .pixel ? 0 : 9)
                .strokeBorder(skinStore.skin == .pixel ? pixelAccentColor.opacity(0.75) : subtleStrokeColor, lineWidth: skinStore.skin == .pixel ? 2 : 1)
        )
    }

    private var canDeleteImportedPets: Bool {
        selection.importedPackages.count > 1
    }

    private var pixelAccentColor: Color {
        Color(red: 0.99, green: 0.78, blue: 0.28)
    }

    private func skinIcon(for skin: AppSkin) -> String {
        switch skin {
        case .glass: return "sparkles"
        case .dark: return "moon.fill"
        case .pixel: return "square.grid.3x3.fill"
        }
    }

    private func skinDescription(for skin: AppSkin) -> String {
        switch skin {
        case .glass: return localizer[.skinGlassDesc]
        case .dark: return localizer[.skinDarkDesc]
        case .pixel: return localizer[.skinPixelDesc]
        }
    }
}

enum PetSettingsWindowLayout {
    static let size = CGSize(width: 860, height: 580)
    static let dividerWidth: CGFloat = 1
    static let dividerHeight: CGFloat = size.height
}
