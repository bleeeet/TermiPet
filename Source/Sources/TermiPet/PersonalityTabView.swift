import TermiPetCore
import SwiftUI

struct PersonalityTabView: View {
    @State private var config: PetPersonalityConfig
    @State private var newConstraint = ""
    @State private var saveMessage = ""
    @Environment(\.appSkin) private var skin
    let localizer: AppLocalizer

    private let store = PetPersonalityStore()

    init(localizer: AppLocalizer = AppLocalizer()) {
        self.localizer = localizer
        _config = State(initialValue: PetPersonalityStore().load())
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    nameSection
                    presetSection
                    customPromptSection
                    constraintsSection
                }
                .padding(24)
                .frame(maxWidth: .infinity, alignment: .topLeading)
            }

            HStack(spacing: 10) {
                Spacer()
                if !saveMessage.isEmpty {
                    Text(saveMessage)
                        .font(.system(size: 12, weight: .medium))
                        .foregroundStyle(.green)
                }
                Button {
                    saveConfig()
                } label: {
                    Label(localizer[.personalitySaveButton], systemImage: "checkmark.circle")
                }
                .keyboardShortcut(.defaultAction)
            }
            .padding(.horizontal, 24)
            .padding(.bottom, 18)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
        .onChangeCompat(of: config) { newValue in
            try? store.save(newValue)
            saveMessage = ""
        }
    }

    private var nameSection: some View {
        HStack(spacing: 14) {
            VStack(alignment: .leading, spacing: 8) {
                Text(localizer[.personalityPetName])
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundStyle(skin.settingsSecondaryTextColor)

                TextField(localizer[.personalityPetNamePlaceholder], text: $config.petName)
                    .textFieldStyle(.roundedBorder)
            }

            VStack(alignment: .leading, spacing: 8) {
                Text(localizer[.personalityOwnerName])
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundStyle(skin.settingsSecondaryTextColor)

                TextField(localizer[.personalityOwnerNamePlaceholder], text: $config.ownerName)
                    .textFieldStyle(.roundedBorder)
            }
        }
    }

    private var presetSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(localizer[.personalityPresetSection])
                .font(.system(size: 13, weight: .semibold))
                .foregroundStyle(skin.settingsSecondaryTextColor)

            VStack(alignment: .leading, spacing: 4) {
                ForEach(PersonalityPreset.allCases, id: \.self) { preset in
                    Button {
                        config.applyPreset(preset)
                    } label: {
                        HStack {
                            Image(systemName: config.selectedPreset == preset ? "checkmark.circle.fill" : "circle")
                                .font(.system(size: 16, weight: .medium))
                                .foregroundStyle(config.selectedPreset == preset ? .blue : .secondary)

                            Text(preset.displayName)
                                .font(.system(size: 14, weight: .medium))

                            Spacer()
                        }
                        .contentShape(Rectangle())
                    }
                    .buttonStyle(.plain)
                    .padding(.vertical, 6)
                    .padding(.horizontal, 10)
                    .background(
                        config.selectedPreset == preset
                            ? Color.blue.opacity(0.1)
                            : Color.clear,
                        in: RoundedRectangle(cornerRadius: 6)
                    )
                }
            }
        }
    }

    private var customPromptSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(config.selectedPreset == .custom ? localizer[.personalityCustomPrompt] : localizer[.personalityPromptEditable])
                .font(.system(size: 13, weight: .semibold))
                .foregroundStyle(skin.settingsSecondaryTextColor)

            TextEditor(text: $config.customPrompt)
                .font(.system(size: 13))
                .frame(height: 96)
                .overlay(
                    RoundedRectangle(cornerRadius: 6)
                        .strokeBorder(skin.settingsSubtleStrokeColor, lineWidth: 0.8)
                )
                .scrollContentBackground(.hidden)
                .background(.regularMaterial, in: RoundedRectangle(cornerRadius: 6))
        }
    }

    private var constraintsSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text(localizer[.personalityConstraints])
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundStyle(skin.settingsSecondaryTextColor)

                Spacer()
            }

            HStack(spacing: 8) {
                TextField(localizer[.personalityConstraintPlaceholder], text: $newConstraint)
                    .textFieldStyle(.roundedBorder)
                    .onSubmit { addConstraint() }

                Button {
                    addConstraint()
                } label: {
                    Image(systemName: "plus.circle.fill")
                        .font(.system(size: 18, weight: .medium))
                        .foregroundStyle(newConstraint.trimmingCharacters(in: .whitespaces).isEmpty ? AnyShapeStyle(.tertiary) : AnyShapeStyle(Color.blue))
                }
                .buttonStyle(.plain)
                .disabled(newConstraint.trimmingCharacters(in: .whitespaces).isEmpty)
            }

            if !config.constraints.isEmpty {
                VStack(spacing: 4) {
                    ForEach(config.constraints, id: \.self) { constraint in
                        HStack {
                            Text(constraint)
                                .font(.system(size: 13, weight: .medium))

                            Spacer()

                            Button {
                                config.constraints.removeAll { $0 == constraint }
                            } label: {
                                Image(systemName: "trash")
                                    .font(.system(size: 12, weight: .medium))
                                    .foregroundStyle(.red)
                            }
                            .buttonStyle(.plain)
                        }
                        .padding(.horizontal, 10)
                        .padding(.vertical, 6)
                        .background(.regularMaterial, in: RoundedRectangle(cornerRadius: 6))
                    }
                }
            }
        }
    }

    private func addConstraint() {
        let trimmed = newConstraint.trimmingCharacters(in: .whitespaces)
        guard !trimmed.isEmpty else { return }
        config.constraints.append(trimmed)
        newConstraint = ""
    }

    private func saveConfig() {
        do {
            try store.save(config)
            saveMessage = localizer[.personalitySaved]
        } catch {
            saveMessage = localizer[.personalitySaveFailed]
        }
    }
}
