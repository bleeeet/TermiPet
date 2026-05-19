# TermiPet

<p align="center">
  <img src="Source/Sources/TermiPet/Resources/AppLogo.png" width="96" alt="TermiPet App Icon">
</p>

<p align="center">
  <b>A desktop pet assistant for macOS terminals and Claude Code workflows</b>
</p>

<p align="center">
  <a href="README.md">简体中文</a>
  ·
  <a href="README.zh-TW.md">繁體中文</a>
  ·
  <a href="README.en.md">English</a>
  ·
  <a href="README.ja.md">日本語</a>
  ·
  <a href="README.ko.md">한국어</a>
</p>

<p align="center">
  <img alt="macOS" src="https://img.shields.io/badge/macOS-14.0%2B-black?logo=apple">
  <img alt="Swift" src="https://img.shields.io/badge/Swift-6.0-orange?logo=swift">
  <img alt="License" src="https://img.shields.io/badge/License-Apache%202.0-blue">
</p>

<p align="center">
  <a href="#-download-and-install">Download and Install</a>
  ·
  <a href="#-highlights">Highlights</a>
  ·
  <a href="#quick-start">Quick Start</a>
  ·
  <a href="#-privacy-and-data">Privacy and Data</a>
  ·
  <a href="#-star-history">Star History</a>
  ·
  <a href="#-usage">Usage</a>
  ·
  <a href="#-development">Development</a>
  ·
  <a href="#license">License</a>
</p>

TermiPet is a lightweight macOS menu bar app that keeps a pixel pet beside your terminal. It helps you **view terminal and AI agent status**, **send frequent commands**, **check Claude Code / Codex / GitHub Copilot usage**, and **chat with your pet** through local or online models.

<p align="center">
  <img src="docs/images/termipet-hero.png" width="100%" alt="TermiPet hero">
</p>

It is not just decoration. TermiPet is a small workflow surface: quiet by default, but ready to open command shortcuts, status cards, usage panels, timers, and chat when you need them.

<p align="center">
  <img src="docs/images/termipet-workspace-overview.png" width="100%" alt="TermiPet workspace overview">
</p>

## ✨ Highlights

| Feature | Description |
| --- | --- |
| Floating desktop pet | Runs as a menu bar app and can stay near your terminal without taking Dock space. |
| Terminal awareness | Supports Terminal, iTerm2, Ghostty, Warp, WezTerm, Alacritty, Kitty, and more. |
| Terminal preview | Shows window title, output summary, current state, and reminders when available. |
| Command panel | Includes common Claude Code commands and supports custom commands, pinning, and sorting. |
| Folder shortcut | Select a project folder and insert the matching `cd` command into the target terminal. |
| Claude Code Hook | Syncs thinking, tool use, permission requests, context compaction, and completion states. |
| Pet chat | Supports local Ollama, OpenAI, Google Gemini, and OpenAI-compatible custom APIs. |
| Personality settings | Configure pet name, owner name, presets, custom prompts, and extra constraints. |
| Pomodoro timer | Supports 25-minute focus sessions and 5-minute breaks with pet animations. |
| AI usage card | Tries to read lightweight Claude Code, Codex, and GitHub Copilot usage information. |
| Built-in and custom pets | Terminal Cat is the mascot; you can also import custom pet packages. |
| Languages and skins | Supports Simplified Chinese, Traditional Chinese, English, Japanese, Korean, and multiple skins. |

## 🖼️ Interface Preview

### Status Cards and Permission Prompts

TermiPet turns Claude Code and terminal activity into floating status cards. Cards can show the project, action, working directory, Hook source, and Allow / Deny prompts for commands that need your approval.

<p align="center">
  <img src="docs/images/termipet-claude-hook.png" width="430" alt="TermiPet Claude hook status">
</p>

### Command Panel

The command panel keeps frequent Claude Code commands close at hand, including `/compact`, `/review`, `/status`, and `/diff`. You can insert commands into the current terminal, add your own entries, reorder them, and pin favorites.

Automatic input requires macOS Accessibility permission. Click the TermiPet icon in the menu bar and choose "Request Accessibility Permission" or "Open Accessibility Settings" first. Without that permission, command panel actions still work, but they copy the command to the clipboard so you can paste it manually.

<p align="center">
  <img src="docs/images/termipet-command-panel.png" width="360" alt="TermiPet command panel">
</p>

### Switchable Pets

TermiPet includes multiple pets. `Terminal Cat` is the default mascot, and each pet can react with idle, thinking, running, reminder, error, sleep, and celebration animations.

You can also find more Petdex / Codex-compatible pet packs from the [Petdex community](https://petdex.crafter.run/zh).

<p align="center">
  <img src="docs/images/termipet-pet-library.png" width="860" alt="TermiPet pet selection">
</p>

### Pet Chat

Open chat from the floating toolbar and talk to the current pet directly. The pet can explain status, keep you company while coding, or respond with different personality presets. Chat can use local Ollama or online API providers.

<p align="center">
  <img src="docs/images/termipet-pet-chat.png" width="430" alt="TermiPet pet chat">
</p>

### Floating Toolbar and Usage Card

Hover near the pet to open shortcuts for commands, folders, chat, skins, and Pomodoro. The usage card can show lightweight quota status for Claude Code, Codex, and GitHub Copilot.

<p align="center">
  <img src="docs/images/termipet-floating-panel.png" width="520" alt="TermiPet floating panel">
</p>

## 🔐 Privacy and Data

TermiPet runs locally on your Mac and **does not provide its own cloud relay server**. Configuration, keys, and local status stay on your machine unless you explicitly configure an external model or service endpoint.

| Data | How it is stored or used |
| --- | --- |
| Online model API keys | **Stored in macOS Keychain** and never uploaded to a TermiPet server. |
| Model Base URL and model name | Stored locally in Application Support to decide which endpoint to request. |
| Local Ollama chat | Sent to the local Ollama service on your Mac. |
| OpenAI / Gemini / custom API chat | Sent only to the provider endpoint you configured. TermiPet does not proxy requests. |
| Claude Code / Codex usage reading | Uses local credentials or local config to request official endpoints directly from your Mac. |
| Claude Code Hook status | Sent only to TermiPet's local `127.0.0.1` service for updating pet state. |
| Terminal preview and quick input | Uses macOS Accessibility permission locally to identify windows and input commands. |

In short: TermiPet is a **local plugin and desktop assistant**. API requests go to the address you configure; keys and workflow state are not uploaded to a TermiPet-owned server.

## 💻 Requirements

| Item | Requirement |
| --- | --- |
| OS | macOS 14.0 or later |
| Build toolchain | Swift 6 only when building from source |
| Local chat | Optional; [Ollama](https://ollama.com) is only required when using local model chat |
| Online models | Optional, requires OpenAI, Google Gemini, or compatible API credentials |
| Permissions | Terminal preview and quick input require macOS Accessibility permission |

## 📦 Download and Install

### 🚀 Direct Download App

This is the recommended path for most users: no Swift, Homebrew, or other developer tools are required. Just download the packaged macOS app.

1. Open [TermiPet Releases](https://github.com/bleeeet/TermiPet/releases).
2. Download `TermiPet-v0.1.1-macOS.zip` from the latest release.
3. Unzip it to get `TermiPet.app`.
4. Move `TermiPet.app` to the Applications folder, or double-click it directly.
5. If macOS says the app is from an unidentified developer on first launch, open System Settings -> Privacy & Security and allow it to run.

After launch, TermiPet appears in the macOS menu bar. By default, it does not appear in the Dock.

Terminal preview, automatic quick command input, and automatic folder `cd` input require macOS Accessibility permission. Use "Request Accessibility Permission" or "Open Accessibility Settings" from the menu bar item to grant it. Without permission, quick commands are copied to the clipboard and need to be pasted manually.

### 🧪 One-line Script Install

If you prefer the terminal, run this command to download the latest `TermiPet.app` from GitHub Releases and install it into Applications:

```zsh
curl -fsSL https://raw.githubusercontent.com/bleeeet/TermiPet/main/install.sh | zsh
```

You can also read [`install.sh`](install.sh) before running it.

### 🍺 Homebrew Install

If you use Homebrew, install the latest version from the TermiPet tap:

```zsh
brew tap bleeeet/termipet https://github.com/bleeeet/TermiPet
brew install --cask termipet
```

You can also use the fully qualified cask name to avoid conflicts with same-name casks from other taps:

```zsh
brew install --cask bleeeet/termipet/termipet
```

> Maintenance note: Homebrew reads [`Casks/termipet.rb`](Casks/termipet.rb) directly from this repository. After every new Release, update its `version` and `sha256`.

### 🧰 Build from Source

Run this from the project root:

```zsh
zsh Scripts/build-plugin.sh
```

The script automatically:

1. Runs all tests.
2. Builds the Swift Package.
3. Generates and refreshes `App/TermiPet.app`.
4. Copies the binary, resources, and default pet packages.
5. Clears extended attributes.
6. Signs with a local self-signed certificate; if unavailable, it falls back to ad-hoc signing.
7. Quits any old TermiPet process and launches the new app.

For more end-user instructions, see [USAGE.md](USAGE.md).

## 🏁Quick Start

### 1. Show the Pet

Click the TermiPet icon in the menu bar and choose "Show Pet".

### 2. Grant Accessibility Permission

If you want terminal preview, quick command input, and folder `cd` input, grant macOS Accessibility permission.

Steps:

1. Click the TermiPet menu bar icon.
2. Choose "Request Accessibility Permission" or "Open Accessibility Settings".
3. Find TermiPet in the Accessibility page in System Settings.
4. Enable permission for TermiPet.
5. If it does not take effect immediately, restart TermiPet.

Without Accessibility permission, the pet can still display and chat, but terminal reading, automatic input, and some status recognition will be limited.

### 3. Use the Floating Toolbar

Move the pointer over the pet to reveal a row of tool buttons:

| Button | Purpose |
| --- | --- |
| 🖥️ Terminal | Open or collapse the quick command panel |
| 📁 Folder | Choose a folder and send `cd` to the terminal |
| 💬 Chat | Open the pet chat window |
| 🎨 Palette | Cycle through skins |
| 🍅 Timer | Start, pause, or resume a 25-minute Pomodoro |
| ⏹️ Stop | Stop the Pomodoro while it is running |
| ☕ Cup | Start a 5-minute break |

Below the pet, action buttons can manually trigger idle, run, move, happy, alert, error, sleep, thinking, and celebration animations.

## 🎮 Usage

### Send Claude Code Commands Quickly

1. Open and focus a terminal window.
2. Move the pointer over the pet.
3. Click the terminal button.
4. Choose a command from the quick command panel.

To let TermiPet type the command into the terminal automatically, first click the TermiPet icon in the macOS menu bar, choose "Request Accessibility Permission" or "Open Accessibility Settings", and allow TermiPet in System Settings. Without Accessibility permission, commands are copied to the clipboard and need to be pasted manually.

Built-in commands include:

```text
claude
claude --enable-auto-mode
claude --dangerously-skip-permissions
/compact
/init
/clear
/memory
/model
/help
/review
/status
/diff
/cost
/login
/config
/mcp
/doctor
/terminal-setup
```

You can also add your own commands in Settings -> Commands, and adjust pinning and order.

<p align="center">
  <img src="docs/images/termipet-command-settings.png" width="860" alt="TermiPet command settings">
</p>

### 📁 Switch Project Directories Quickly

Click the folder button and choose a project folder. TermiPet sends the corresponding `cd` command to the most recently used target terminal.

### 👀 View Claude Code Status

TermiPet can receive development agent status through Claude Code Hook. After installation, pet cards can show whether Claude Code is thinking, using tools, waiting for permission, compacting context, or finished.

The menu bar provides:

- Install Claude Code Hook
- Uninstall Claude Code Hook

Installation modifies:

```text
~/.claude/settings.json
~/.claude/hooks/
```

On first install, the original settings are backed up to:

```text
~/.claude/settings.json.floating-pet.bak
```

After installation, restart any running `claude` process for the Hook to take effect. The Hook sends local Claude Code events to TermiPet's local service on `127.0.0.1` to update pet state; no external server is involved.

### 💬 Chat with the Pet

Click the chat button to open the chat window. Chat models can come from two sources:

| Model Source | Description |
| --- | --- |
| Local Ollama | Good for users who want local execution and fewer external API dependencies. |
| Online API | Supports OpenAI, Google Gemini, and custom services compatible with OpenAI Chat Completions. |

API keys are stored in macOS Keychain. Regular configuration is stored in Application Support.

## ⚙️ Settings

Click "Settings..." from the menu bar, or right-click the pet and choose "Settings...", to open the settings window.

| Page | Purpose |
| --- | --- |
| ℹ️ About | View version, developer, and project information. |
| 🎨 Skins | Switch between glass, dark, pixel, and other appearances. |
| 🌍 Language | Switch Simplified Chinese, Traditional Chinese, English, Japanese, and Korean; restart for full effect. |
| ⚡ Commands | Manage built-in and custom commands, including add, delete, pin, and drag sorting. |
| 🐾 Pets | Import and select pet packages. |
| 🎭 Personality | Configure pet name, owner name, personality presets, custom Prompt, and extra constraints. |
| 🧠 Models | Configure local Ollama or online API chat models. |

<p align="center">
  <img src="docs/images/termipet-personality-settings.png" width="860" alt="TermiPet personality settings">
</p>

## 🧠 Pet Chat Models

### Local Models

Settings path: `Settings -> Models -> Local Models`.

TermiPet checks whether Ollama is running. The built-in model catalog includes:

<p align="center">
  <img src="docs/images/termipet-local-models.png" width="860" alt="TermiPet local model settings">
</p>

| Model | Description | Size |
| --- | --- | --- |
| Qwen2.5 0.5B | Extremely lightweight, good for low-spec Macs, strong Chinese support | ~400MB |
| Qwen2.5 1.5B | Recommended, good Chinese quality, fast | ~1.1GB |
| Phi-3.5 mini | Small and high quality | ~2.2GB |
| Gemma 3 1B | Balanced and lightweight | ~815MB |

Models that are not downloaded cannot be selected directly. From the settings page, you can start Ollama, open the install page, download recommended models, or refresh detection manually.

### Online APIs

Settings path: `Settings -> Models -> Online API`.

Supported providers:

<p align="center">
  <img src="docs/images/termipet-online-api.png" width="860" alt="TermiPet online API settings">
</p>

- OpenAI, default Base URL: `https://api.openai.com/v1`.
- Google Gemini, default Base URL: `https://generativelanguage.googleapis.com/v1beta`.
- Custom API, for services compatible with OpenAI Chat Completions.

API keys are stored in macOS Keychain. Base URL, model name, and other non-sensitive settings are stored in Application Support. After filling them in, it is recommended to click "Load Models" and "Test Connection" first.

## 🎨 Custom Pets

TermiPet includes multiple built-in pets. The default protagonist is `Terminal Cat`, a small cat that sits beside your terminal and serves as the app mascot. Built-in pets also include pixel-style cats, Wizard Claude, Mochi, and other characters. You can import your own pet packages compatible with Codex pet files.

### Petdex Compatibility

TermiPet can import **Petdex / Codex-compatible pet packages**: in Settings -> Pets, choose a pet folder containing `pet.json` and `spritesheet.webp`. TermiPet copies it into the local `ImportedPets` directory and uses it as a desktop pet.

A pet package is a folder that must contain at least:

```text
pet.json
spritesheet.webp
```

Example `pet.json`:

```json
{
  "id": "example-pet",
  "displayName": "Example Pet",
  "description": "A custom pixel pet.",
  "spritesheetPath": "spritesheet.webp"
}
```

The spritesheet is parsed as 9 action rows by default:

| Index | Action |
| --- | --- |
| 0 | Idle |
| 1 | Run |
| 2 | Move |
| 3 | Happy |
| 4 | Alert |
| 5 | Error |
| 6 | Sleep |
| 7 | Thinking |
| 8 | Celebrate |

Imported pets are copied to:

```text
~/Library/Application Support/TermiPet/ImportedPets/
```

The current selection is stored in:

```text
~/Library/Application Support/TermiPet/selected-pet.json
```

## 🧭 Design Philosophy

TermiPet is designed in three layers:

### Floating Companion Layer

The pet is the visible entry point. It stays lightweight by default and does not demand attention; when hovered, it expands the toolbar, status cards, usage cards, and chat window.

### Workflow Assistance Layer

TermiPet recognizes the current terminal, editor, and AI chat app, then turns that context into easier-to-read status hints.

It focuses on three actions:

- See: view terminal, editor, agent, and AI usage status.
- Click: send frequent commands, switch directories, and start timers.
- Chat: talk with the pet through local or online models.

### Configuration and Extension Layer

Commands, pets, skins, language, chat models, and personality Prompts are all configurable. Future versions can keep expanding pet packages, command templates, model services, and more development workflows.

## 🗂️ Project Structure

```text
.
├── README.md
├── USAGE.md
├── LICENSE
├── Scripts/
│   ├── build-plugin.sh          # Tests, builds, signs, and launches the app
│   └── open-plugin.sh           # Opens an existing app build
├── Source/
│   ├── Package.swift            # Swift Package configuration
│   ├── AppBundle/               # Info.plist and app icon
│   ├── Sources/
│   │   ├── TermiPet/            # macOS app, SwiftUI UI, and system integration
│   │   └── TermiPetCore/        # Core models, config, policies, and pure logic
│   └── Tests/TermiPetTests/     # Unit tests
├── Pets/                        # Default pet packages
├── icon/                        # Original icon and social preview assets
└── App/TermiPet.app             # Build artifact generated by the script
```

## 🧑‍💻 Development

Full build, test, signing, and launch:

```zsh
zsh Scripts/build-plugin.sh
```

Create a release zip:

```zsh
zsh Scripts/package-release.sh 0.1.1
```

Run tests only:

```zsh
cd Source
swift test
```

Build debug only:

```zsh
cd Source
swift build -c debug
```

Source builds generate `App/TermiPet.app` locally, suitable for developer testing or packaging.

## 📝 Configuration Files

TermiPet user configuration is mainly stored in:

```text
~/Library/Application Support/TermiPet/
```

Common files:

| File | Description |
| --- | --- |
| `config.json` | Quick command configuration |
| `personality.json` | Pet personality configuration |
| `ollama-config.json` | Model source, Base URL, and model name |
| `selected-pet.json` | Path of the selected pet folder |
| `ImportedPets/` | Imported pet packages |

Online model API keys are stored in macOS Keychain and are not written to regular JSON configuration files.

## 🛡️ Permissions and Privacy

TermiPet may need Accessibility permission to:

- Identify the current foreground terminal, editor, or AI app.
- Read terminal window titles and partial text to generate terminal previews.
- Type quick commands or `cd` commands into the terminal.

Without permission, the app still runs, but terminal preview and automatic input are limited. Use "Open Accessibility Settings" from the menu bar to authorize it. See "Privacy and Data" above for the full data explanation.

## 🗺️ Roadmap

- Provide a more stable packaged release flow.
- Add more default pet assets.
- Improve status recognition for more AI coding tools.
- Improve onboarding and first-time permission guidance.

## 🤝 Contributing

- Add or update tests for behavior changes.
- After changing code or resources, run `zsh Scripts/build-plugin.sh` and verify the app.

## 🙏 Acknowledgements

TermiPet's use cases are inspired by and compatible with these AI coding and model ecosystems: **Claude Code**, **Codex**, **Google Gemini**, **GitHub Copilot**, and **Ollama**. They are not official contributors to or endorsers of TermiPet, but TermiPet adapts to their local workflows, status displays, usage reading, and pet chat experiences.

Thanks to **@Dinny-xu** and **@Gnonymous** for reporting and helping diagnose the resource bundle loading issue in the v0.1 installer.

## 👍 Support the Project

### ☕ Buy Me a Coffee

If TermiPet makes your terminal more fun and productive, you are welcome to buy me a coffee on [Afdian](https://afdian.com/a/bleetchen).

As an independent developer, every sponsorship directly helps cover hard project costs such as API testing tokens and servers, so this open-source tool can keep going further. Sponsorship is completely optional; giving the project a ⭐ or recommending it to macOS friends is already a huge support.

### 💼 Commercial Collaboration / Team Customization

If you want to build commercial use cases on top of TermiPet, or discuss custom macOS AI tool work, feel free to email me: [bleetchenxuanling@gmail.com](mailto:bleetchenxuanling@gmail.com).

## ⭐ Star History

<p align="center">
  <a href="https://www.star-history.com/#bleeeet/termipet&Date">
    <img alt="TermiPet Star History Chart" src="https://api.star-history.com/svg?repos=bleeeet/termipet&type=Date">
  </a>
</p>

## License

This project is licensed under Apache License 2.0. See [LICENSE](LICENSE).
