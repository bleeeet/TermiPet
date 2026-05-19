import SwiftUI
import TermiPetCore

struct AboutTabView: View {
    @Environment(\.appSkin) private var skin
    let language: AppLanguage

    private var localizer: AppLocalizer {
        AppLocalizer(language: language)
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                HStack(spacing: 14) {
                    Group {
                        if let appIcon = NSApp.applicationIconImage {
                            Image(nsImage: appIcon)
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 56, height: 56)
                        } else {
                            Image(systemName: "terminal.fill")
                                .font(.system(size: 48, weight: .semibold))
                                .foregroundStyle(.blue)
                        }
                    }

                    VStack(alignment: .leading, spacing: 4) {
                        Text("TermiPet")
                            .font(.system(size: 20, weight: .bold))

                        Text("\(localizer[.aboutVersion]) 1.0.0")
                            .font(.system(size: 13, weight: .medium))
                            .foregroundStyle(skin.settingsSecondaryTextColor)
                    }
                }

                separator

                VStack(alignment: .leading, spacing: 8) {
                    Text(localizer[.aboutTitle])
                        .font(.system(size: 14, weight: .medium))

                    Text(localizer[.aboutDescription])
                        .font(.system(size: 13, weight: .regular))
                        .foregroundStyle(skin.settingsSecondaryTextColor)
                        .fixedSize(horizontal: false, vertical: true)
                }

                separator

                VStack(alignment: .leading, spacing: 8) {
                    Text(localizer[.aboutDeveloper])
                        .font(.system(size: 13, weight: .semibold))
                        .foregroundStyle(skin.settingsSecondaryTextColor)

                    Text(localizer[.aboutDeveloperName])
                        .font(.system(size: 13, weight: .medium))
                }

                separator

                VStack(alignment: .leading, spacing: 10) {
                    Text(localizer[.aboutSocialMedia])
                        .font(.system(size: 13, weight: .semibold))
                        .foregroundStyle(skin.settingsSecondaryTextColor)

                    VStack(spacing: 8) {
                        socialLinkRow(
                            icon: "github",
                            platform: "GitHub",
                            username: "@bleeeet",
                            url: "https://github.com/bleeeet"
                        )

                        socialLinkRow(
                            icon: "twitter",
                            platform: "X (Twitter)",
                            username: "@bleetchen",
                            url: "https://x.com/bleetchen"
                        )

                        socialLinkRow(
                            icon: "instagram",
                            platform: "Instagram",
                            username: "@b1eeeet",
                            url: "https://www.instagram.com/b1eeeet"
                        )
                    }
                }
            }
            .padding(24)
            .frame(maxWidth: .infinity, alignment: .topLeading)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }

    private func socialLinkRow(icon: String, platform: String, username: String, url: String) -> some View {
        Button {
            if let nsURL = URL(string: url) {
                NSWorkspace.shared.open(nsURL)
            }
        } label: {
            HStack(spacing: 12) {
                ZStack {
                    RoundedRectangle(cornerRadius: 9)
                        .fill(brandColor(for: icon))
                        .frame(width: 38, height: 38)

                    socialIcon(for: icon)
                }

                VStack(alignment: .leading, spacing: 2) {
                    Text(platform)
                        .font(.system(size: 13, weight: .semibold))
                        .foregroundStyle(.primary)

                    Text(username)
                        .font(.system(size: 11, weight: .regular))
                        .foregroundStyle(skin.settingsSecondaryTextColor)
                }

                Spacer()

                Image(systemName: "arrow.up.right")
                    .font(.system(size: 11, weight: .semibold))
                    .foregroundStyle(skin.settingsTertiaryTextColor)
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 10)
            .background(
                RoundedRectangle(cornerRadius: 10)
                            .fill(.regularMaterial)
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .strokeBorder(skin.settingsSubtleStrokeColor, lineWidth: 0.5)
                            )
                    )
            .contentShape(Rectangle())
        }
        .buttonStyle(SocialLinkButtonStyle())
    }

    private var separator: some View {
        Rectangle()
            .fill(skin.settingsSeparatorColor)
            .frame(height: 1)
    }

    @ViewBuilder
    private func socialIcon(for icon: String) -> some View {
        if let nsImage = loadImage(named: icon) {
            Image(nsImage: nsImage)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 20, height: 20)
        } else {
            Image(systemName: fallbackIconName(for: icon))
                .font(.system(size: 16, weight: .semibold))
                .foregroundStyle(.white)
        }
    }

    private func loadImage(named name: String) -> NSImage? {
        guard let imageURL = TermiPetResources.pngURL(named: name),
              let image = NSImage(contentsOf: imageURL) else { return nil }
        return image
    }

    private func brandColor(for icon: String) -> Color {
        switch icon {
        case "github":
            return Color(red: 0.13, green: 0.13, blue: 0.13)
        case "twitter":
            return Color(red: 0.0, green: 0.0, blue: 0.0)
        case "instagram":
            return Color(red: 0.0, green: 0.0, blue: 0.0)
        default:
            return .blue
        }
    }

    private func fallbackIconName(for icon: String) -> String {
        switch icon {
        case "github": return "chevron.left.forwardslash.chevron.right"
        case "twitter": return "xmark"
        case "instagram": return "camera.fill"
        default: return "link"
        }
    }
}

private struct SocialLinkButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.97 : 1.0)
            .opacity(configuration.isPressed ? 0.82 : 1.0)
            .animation(.easeInOut(duration: 0.1), value: configuration.isPressed)
    }
}
