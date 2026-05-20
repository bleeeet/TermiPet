import TermiPetCore
import SwiftUI

struct ModelTabView: View {
    @StateObject private var vm = OllamaModelStoreVM()
    @State private var pendingDeleteModel: OllamaModelDefinition?
    @Environment(\.appSkin) private var skin
    let localizer: AppLocalizer

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            ScrollView {
                VStack(alignment: .leading, spacing: 18) {
                    header
                    providerPicker

                    if vm.config.provider == .local {
                        localModelsSection
                    } else {
                        onlineModelSection
                    }
                }
                .padding(24)
                .frame(maxWidth: .infinity, alignment: .topLeading)
            }

            saveFooter
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
        .task { await vm.refresh() }
        .confirmationDialog(
            pendingDeleteModel.map { String(format: localizer[.modelDeleteConfirmTitle], $0.displayName) } ?? "",
            isPresented: Binding(
                get: { pendingDeleteModel != nil },
                set: { if !$0 { pendingDeleteModel = nil } }
            ),
            titleVisibility: .visible,
            presenting: pendingDeleteModel
        ) { model in
            Button(localizer[.modelButtonDelete], role: .destructive) {
                vm.deleteModel(id: model.id)
                pendingDeleteModel = nil
            }
            Button(localizer[.addCommandCancel], role: .cancel) {
                pendingDeleteModel = nil
            }
        } message: { model in
            Text(String(format: localizer[.modelDeleteConfirmMessage], model.displayName))
        }
    }

    private var header: some View {
        HStack(spacing: 8) {
            Circle()
                .fill(vm.config.provider == .local ? (vm.ollamaRunning ? Color.green : Color.red) : Color.blue)
                .frame(width: 8, height: 8)

            Text(localizer[.modelPetChatTitle])
                .font(.system(size: 18, weight: .bold))

            Spacer()

            Button {
                Task { await vm.refresh() }
            } label: {
                Image(systemName: "arrow.clockwise")
                    .font(.system(size: 13, weight: .medium))
            }
            .buttonStyle(.plain)
            .help(localizer[.modelRefresh])
        }
    }

    private var providerPicker: some View {
        Picker(localizer[.modelProviderSource], selection: $vm.config.provider) {
            ForEach(PetChatModelProvider.allCases, id: \.self) { provider in
                Text(provider.localizedDisplayName(localizer)).tag(provider)
            }
        }
        .pickerStyle(.segmented)
        .onChangeCompat(of: vm.config.provider) { provider in
            vm.saveConfig()
            if provider == .local {
                Task { await vm.refresh() }
            }
        }
    }

    private var localModelsSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            localSetupCard

            VStack(spacing: 8) {
                ForEach(OllamaModelDefinition.catalog) { model in
                    modelCard(model)
                }
            }
        }
    }

    private var localSetupCard: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(alignment: .top, spacing: 10) {
                Image(systemName: setupIconName)
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundStyle(setupAccentColor)
                    .frame(width: 24, height: 24)

                VStack(alignment: .leading, spacing: 4) {
                    Text(setupTitle)
                        .font(.system(size: 14, weight: .bold))
                    Text(setupMessage)
                        .font(.system(size: 12, weight: .medium))
                        .foregroundStyle(skin.settingsSecondaryTextColor)
                        .fixedSize(horizontal: false, vertical: true)
                }

                Spacer(minLength: 8)

                setupBadge
            }

            if case .downloading(let progress) = vm.downloadStatuses[vm.recommendedModel.id] {
                VStack(alignment: .leading, spacing: 5) {
                    ProgressView(value: progress)
                    Text("\(localizer[.modelDownloadingProgressPrefix])\(vm.recommendedModel.displayName) · \(Int(progress * 100))%")
                        .font(.system(size: 11, weight: .medium, design: .monospaced))
                        .foregroundStyle(skin.settingsSecondaryTextColor)
                }
            }

            HStack(spacing: 8) {
                setupPrimaryButton

                Button {
                    Task { await vm.refresh() }
                } label: {
                    Label(localizer[.modelRedetect], systemImage: "arrow.clockwise")
                }
                .font(.system(size: 12, weight: .semibold))

                if vm.setupState != .ready {
                    Button {
                        vm.config.provider = .online
                        vm.saveConfig()
                    } label: {
                        Label(localizer[.modelSwitchToOnline], systemImage: "network")
                    }
                    .font(.system(size: 12, weight: .semibold))
                }
            }
        }
        .padding(14)
        .background(setupAccentColor.opacity(0.08), in: RoundedRectangle(cornerRadius: 8))
        .overlay(
            RoundedRectangle(cornerRadius: 8)
                .stroke(setupAccentColor.opacity(0.18), lineWidth: 1)
        )
    }

    private func modelCard(_ model: OllamaModelDefinition) -> some View {
        let status = vm.downloadStatuses[model.id] ?? .notDownloaded
        let isReady = status == .ready
        let isSelected = vm.config.provider == .local && vm.config.localModelId == model.id

        return HStack(spacing: 12) {
            Button {
                vm.selectModel(id: model.id)
            } label: {
                Image(systemName: isSelected ? "checkmark.circle.fill" : "circle")
                    .font(.system(size: 18, weight: .medium))
                    .foregroundStyle(isSelected ? Color.blue : (isReady ? skin.settingsSecondaryTextColor : skin.settingsTertiaryTextColor))
            }
            .buttonStyle(.plain)
            .disabled(!isReady)

            VStack(alignment: .leading, spacing: 4) {
                HStack(spacing: 6) {
                    Text(model.displayName)
                        .font(.system(size: 14, weight: .semibold))
                        .lineLimit(1)
                    tag(localizer[.modelTagLocal], color: .blue)
                    if isReady {
                        tag(localizer[.modelTagDownloaded], color: .green)
                    }
                }

                Text(model.localizedDescription(localizer))
                    .font(.system(size: 12, weight: .medium))
                    .foregroundStyle(skin.settingsSecondaryTextColor)
                    .lineLimit(2)
            }
            .frame(maxWidth: .infinity, alignment: .leading)

            Spacer()

            Text(model.sizeLabel)
                .font(.system(size: 12, weight: .medium, design: .monospaced))
                .foregroundStyle(skin.settingsSecondaryTextColor)

            statusArea(for: model, status: status)
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 10)
        .background(
            isSelected ? Color.blue.opacity(0.08) : Color.clear,
            in: RoundedRectangle(cornerRadius: 8)
        )
        .background(.regularMaterial, in: RoundedRectangle(cornerRadius: 8))
    }

    @ViewBuilder
    private func statusArea(for model: OllamaModelDefinition, status: OllamaModelStatus) -> some View {
        switch status {
        case .notDownloaded:
            Button(localizer[.modelButtonDownload]) {
                vm.downloadModel(id: model.id)
            }
            .font(.system(size: 12, weight: .semibold))
            .disabled(!vm.ollamaRunning)

        case .downloading(let progress):
            VStack(alignment: .trailing, spacing: 3) {
                ProgressView(value: progress)
                    .frame(width: 76)
                Text("\(Int(progress * 100))%")
                    .font(.system(size: 10, weight: .medium, design: .monospaced))
                    .foregroundStyle(skin.settingsSecondaryTextColor)
            }
            .frame(width: 76)

        case .ready:
            HStack(spacing: 8) {
                Image(systemName: "checkmark.circle.fill")
                    .font(.system(size: 16, weight: .medium))
                    .foregroundStyle(.green)

                Button {
                    pendingDeleteModel = model
                } label: {
                    if vm.deletingModelIds.contains(model.id) {
                        ProgressView()
                            .controlSize(.small)
                            .frame(width: 18, height: 18)
                    } else {
                        Image(systemName: "trash")
                            .font(.system(size: 12, weight: .semibold))
                            .frame(width: 22, height: 22)
                    }
                }
                .buttonStyle(.plain)
                .foregroundStyle(.red)
                .background(Color.red.opacity(0.10), in: Circle())
                .overlay(Circle().strokeBorder(Color.red.opacity(0.24), lineWidth: 0.8))
                .disabled(vm.deletingModelIds.contains(model.id))
                .help(localizer[.modelButtonDelete])
            }

        case .error(let msg):
            Button(localizer[.modelButtonRetry]) {
                vm.downloadModel(id: model.id)
            }
            .font(.system(size: 12, weight: .semibold))
            .foregroundStyle(.red)
            .help(msg)
        }
    }

    @ViewBuilder
    private var setupPrimaryButton: some View {
        switch vm.setupState {
        case .notInstalledOrNotRunning:
            Button {
                vm.startOllama()
            } label: {
                Label(localizer[.modelStartOllama], systemImage: "play.fill")
            }
            .font(.system(size: 12, weight: .semibold))

            Button {
                vm.openOllamaDownloadPage()
            } label: {
                Label(localizer[.modelInstallOllama], systemImage: "arrow.down.app")
            }
            .font(.system(size: 12, weight: .semibold))

        case .starting:
            Button {
                Task { await vm.refresh() }
            } label: {
                HStack(spacing: 6) {
                    ProgressView()
                        .controlSize(.small)
                    Text(localizer[.modelStarting])
                }
            }
            .font(.system(size: 12, weight: .semibold))
            .disabled(true)

        case .runningNoModel:
            Button {
                vm.downloadRecommendedModel()
            } label: {
                Label(localizer[.modelDownloadRecommended], systemImage: "square.and.arrow.down")
            }
            .font(.system(size: 12, weight: .semibold))

        case .downloadingModel:
            Button {
            } label: {
                HStack(spacing: 6) {
                    ProgressView()
                        .controlSize(.small)
                    Text(localizer[.modelDownloadingShort])
                }
            }
            .font(.system(size: 12, weight: .semibold))
            .disabled(true)

        case .ready:
            Button {
                vm.selectModel(id: vm.recommendedModel.id)
            } label: {
                Label(localizer[.modelUseLocal], systemImage: "checkmark.circle.fill")
            }
            .font(.system(size: 12, weight: .semibold))
            .disabled(vm.config.localModelId == vm.recommendedModel.id)

        case .error:
            Button {
                vm.downloadRecommendedModel()
            } label: {
                Label(localizer[.modelRetryDownload], systemImage: "arrow.clockwise")
            }
            .font(.system(size: 12, weight: .semibold))

            Button {
                vm.openOllamaDownloadPage()
            } label: {
                Label(localizer[.modelOpenInstallPage], systemImage: "safari")
            }
            .font(.system(size: 12, weight: .semibold))
        }
    }

    private var setupTitle: String {
        switch vm.setupState {
        case .notInstalledOrNotRunning: return localizer[.modelSetupTitleNotInstalled]
        case .starting:                  return localizer[.modelSetupTitleStarting]
        case .runningNoModel:            return localizer[.modelSetupTitleRunningNoModel]
        case .downloadingModel:          return localizer[.modelSetupTitleDownloadingModel]
        case .ready:                     return localizer[.modelSetupTitleReady]
        case .error:                     return localizer[.modelSetupTitleError]
        }
    }

    private var setupMessage: String {
        switch vm.setupState {
        case .notInstalledOrNotRunning:
            return localizer[.modelSetupMsgNotInstalled]
        case .starting:
            return localizer[.modelSetupMsgStarting]
        case .runningNoModel:
            return "\(localizer[.modelSetupMsgRunningNoModelPrefix])\(vm.recommendedModel.displayName)\(localizer[.modelSetupMsgRunningNoModelSuffix])"
        case .downloadingModel:
            return localizer[.modelSetupMsgDownloadingModel]
        case .ready:
            return localizer[.modelSetupMsgReady]
        case .error:
            let status = vm.downloadStatuses[vm.recommendedModel.id]
            if case .error(let message) = status {
                return message
            }
            return localizer[.modelSetupMsgErrorFallback]
        }
    }

    private var setupIconName: String {
        switch vm.setupState {
        case .notInstalledOrNotRunning:
            return "powerplug"
        case .starting:
            return "play.circle"
        case .runningNoModel:
            return "square.and.arrow.down"
        case .downloadingModel:
            return "arrow.down.circle"
        case .ready:
            return "checkmark.seal.fill"
        case .error:
            return "exclamationmark.triangle.fill"
        }
    }

    private var setupAccentColor: Color {
        switch vm.setupState {
        case .notInstalledOrNotRunning:
            return .orange
        case .starting, .downloadingModel:
            return .blue
        case .runningNoModel:
            return .teal
        case .ready:
            return .green
        case .error:
            return .red
        }
    }

    @ViewBuilder
    private var setupBadge: some View {
        switch vm.setupState {
        case .notInstalledOrNotRunning:
            tag(localizer[.modelBadgeNotDetected], color: .orange)
        case .starting:
            tag(localizer[.modelBadgeStarting], color: .blue)
        case .runningNoModel:
            tag(localizer[.modelBadgePending], color: .teal)
        case .downloadingModel:
            tag(localizer[.modelBadgeDownloading], color: .blue)
        case .ready:
            tag(localizer[.modelBadgeReady], color: .green)
        case .error:
            tag(localizer[.modelBadgeError], color: .red)
        }
    }

    private var onlineModelSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Picker(localizer[.modelOnlineApiProvider], selection: $vm.config.onlineProvider) {
                ForEach(PetOnlineProvider.allCases, id: \.self) { provider in
                    Text(provider.localizedDisplayName(localizer)).tag(provider)
                }
            }
            .pickerStyle(.segmented)
            .onChangeCompat(of: vm.config.onlineProvider) { _ in
                vm.saveOnlineSettings()
            }

            onlineFields(for: vm.config.onlineProvider)

            HStack(alignment: .top, spacing: 10) {
                Button {
                    vm.fetchOnlineModels()
                } label: {
                    HStack(spacing: 6) {
                        if vm.modelListState == .loading {
                            ProgressView()
                                .controlSize(.small)
                        }
                        Text(vm.modelListState == .loading ? localizer[.modelReadingShort] : localizer[.modelReadModels])
                    }
                }
                .disabled(vm.modelListState == .loading)

                Button {
                    vm.testConnection()
                } label: {
                    HStack(spacing: 6) {
                        if vm.testState == .testing {
                            ProgressView()
                                .controlSize(.small)
                        }
                        Text(vm.testState == .testing ? localizer[.modelTestingShort] : localizer[.modelTestConnection])
                    }
                }
                .disabled(vm.testState == .testing)

                onlineStateLabel
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
        }
        .padding(14)
        .background(.regularMaterial, in: RoundedRectangle(cornerRadius: 8))
    }

    private var saveFooter: some View {
        HStack(spacing: 10) {
            Spacer()
            if case .saved(let message) = vm.saveState {
                stateText(message, color: .green)
            }
            if case .failed(let message) = vm.saveState {
                stateText(message, color: .red)
            }
            Button {
                if vm.config.provider == .online {
                    vm.saveOnlineSettings()
                } else {
                    vm.saveConfig()
                    vm.saveState = .saved(localizer[.saved])
                }
            } label: {
                Label(localizer[.modelSaveButton], systemImage: "checkmark.circle")
            }
            .keyboardShortcut(.defaultAction)
        }
        .padding(.horizontal, 24)
        .padding(.bottom, 18)
    }

    @ViewBuilder
    private func onlineFields(for provider: PetOnlineProvider) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            labeledSecureField("API Key", text: bindingAPIKey(for: provider))

            switch provider {
            case .openAI:
                labeledTextField("Base URL", text: $vm.config.openAIBaseURL)
                modelSelectionField(provider: provider, text: $vm.config.openAIModel)
            case .google:
                labeledTextField("Base URL", text: $vm.config.googleBaseURL)
                modelSelectionField(provider: provider, text: $vm.config.googleModel)
            case .custom:
                labeledTextField("Base URL", text: $vm.config.customBaseURL)
                modelSelectionField(provider: provider, text: $vm.config.customModel)
            }
        }
    }

    private func labeledTextField(_ title: String, text: Binding<String>) -> some View {
        VStack(alignment: .leading, spacing: 5) {
            Text(title)
                .font(.system(size: 12, weight: .semibold))
                .foregroundStyle(skin.settingsSecondaryTextColor)
            TextField(title, text: text)
                .textFieldStyle(.roundedBorder)
        }
    }

    private func labeledSecureField(_ title: String, text: Binding<String>) -> some View {
        VStack(alignment: .leading, spacing: 5) {
            Text(title)
                .font(.system(size: 12, weight: .semibold))
                .foregroundStyle(skin.settingsSecondaryTextColor)
            SecureField(title, text: text)
                .textFieldStyle(.roundedBorder)
        }
    }

    private func modelSelectionField(provider: PetOnlineProvider, text: Binding<String>) -> some View {
        VStack(alignment: .leading, spacing: 5) {
            Text(localizer[.modelLabel])
                .font(.system(size: 12, weight: .semibold))
                .foregroundStyle(skin.settingsSecondaryTextColor)

            if let models = vm.onlineModels[provider], !models.isEmpty {
                Picker(localizer[.modelLabel], selection: Binding(
                    get: { text.wrappedValue },
                    set: { newValue in
                        text.wrappedValue = newValue
                        vm.selectOnlineModel(newValue)
                    }
                )) {
                    ForEach(models) { model in
                        Text(model.displayName).tag(model.id)
                    }
                }
                .pickerStyle(.menu)
            } else {
                TextField(localizer[.modelSelectAfterRead], text: text)
                    .textFieldStyle(.roundedBorder)
            }
        }
    }

    private func bindingAPIKey(for provider: PetOnlineProvider) -> Binding<String> {
        Binding(
            get: { vm.apiKeys[provider] ?? "" },
            set: { vm.apiKeys[provider] = $0 }
        )
    }

    @ViewBuilder
    private var onlineStateLabel: some View {
        VStack(alignment: .leading, spacing: 3) {
            modelListStateLabel
            testStateLabel
        }
    }

    @ViewBuilder
    private var modelListStateLabel: some View {
        switch vm.modelListState {
        case .idle:
            EmptyView()
        case .loading:
            stateText(localizer[.modelStateReadingList], color: .secondary)
        case .loaded(let message):
            stateText("\(localizer[.modelStateReadDonePrefix])\(message)", color: .green)
        case .failed(let message):
            stateText(message, color: .red)
        }
    }

    @ViewBuilder
    private var testStateLabel: some View {
        switch vm.testState {
        case .idle:
            EmptyView()
        case .testing:
            stateText(localizer[.modelStateSendingTest], color: .secondary)
        case .success(let message):
            stateText(message, color: .green)
        case .failure(let message):
            stateText(message, color: .red)
        }
    }

    private func stateText(_ text: String, color: Color) -> some View {
        Text(text)
            .font(.system(size: 12, weight: .medium))
            .foregroundStyle(color)
            .lineLimit(2)
    }

    private func tag(_ text: String, color: Color) -> some View {
        Text(text)
            .font(.system(size: 10, weight: .bold))
            .foregroundStyle(color)
            .padding(.horizontal, 6)
            .padding(.vertical, 2)
            .background(color.opacity(0.12), in: Capsule())
            .fixedSize()
    }
}
