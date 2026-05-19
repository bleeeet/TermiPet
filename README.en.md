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
  <a href="#download-and-install">Download</a>
  ·
  <a href="#highlights">Highlights</a>
  ·
  <a href="#privacy-and-data">Privacy</a>
  ·
  <a href="#build-from-source">Build</a>
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

## Highlights

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

## Interface Preview

### Status Cards and Permission Prompts

TermiPet turns Claude Code and terminal activity into floating status cards. Cards can show the project, action, working directory, Hook source, and Allow / Deny prompts for commands that need your approval.

<p align="center">
  <img src="docs/images/termipet-claude-hook.png" width="430" alt="TermiPet Claude hook status">
</p>

### Command Panel

The command panel keeps frequent Claude Code commands close at hand, including `/compact`, `/review`, `/status`, and `/diff`. You can insert commands into the current terminal, add your own entries, reorder them, and pin favorites.

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

## Privacy and Data

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

## Requirements

| Item | Requirement |
| --- | --- |
| OS | macOS 14.0 or later |
| Build toolchain | Swift 6 |
| Local chat | Optional, requires [Ollama](https://ollama.com) |
| Online models | Optional, requires OpenAI, Google Gemini, or compatible API credentials |
| Permissions | Terminal preview and quick input require macOS Accessibility permission |

## Download and Install

### Homebrew install

If you use Homebrew, install TermiPet from its tap:

```zsh
brew tap bleeeet/termipet https://github.com/bleeeet/TermiPet
brew install --cask termipet
```

You can also use the fully qualified cask name to avoid conflicts with casks from other taps:

```zsh
brew install --cask bleeeet/termipet/termipet
```

> Maintenance note: Homebrew reads [`Casks/termipet.rb`](Casks/termipet.rb) directly from this repository. Update its `version` and `sha256` whenever a new Release is published.

### One-line script install

Most users can run this command to download the latest packaged `TermiPet.app` from GitHub Releases and install it into Applications:

```zsh
curl -fsSL https://raw.githubusercontent.com/bleeeet/TermiPet/main/install.sh | zsh
```

You can also read [`install.sh`](install.sh) before running it.

### Direct download

Most users can download the packaged macOS app without building from source:

1. Open [TermiPet Releases](https://github.com/bleeeet/TermiPet/releases).
2. Download `TermiPet-v0.1-macOS.zip` from the latest release.
3. Unzip it to get `TermiPet.app`.
4. Move `TermiPet.app` to Applications, or double-click it directly.
5. If macOS blocks the first launch, open System Settings -> Privacy & Security and allow TermiPet to run.

TermiPet appears in the macOS menu bar and does not show in the Dock by default. Terminal preview, quick command input, and folder `cd` input require macOS Accessibility permission.

## Build from Source

```zsh
git clone https://github.com/bleeeet/TermiPet.git
cd TermiPet
zsh Scripts/build-plugin.sh
```

The script runs tests, builds the app, copies resources and pet packages into `App/TermiPet.app`, signs the local build, and launches it.

## Usage

Start TermiPet from the menu bar, show the pet, and grant Accessibility permission if you want terminal preview and quick input. Hover near the pet to open the toolbar, send commands, open the chat panel, switch skins, or start Pomodoro.

Claude Code Hook can be installed from the menu bar. It writes local Hook files under `~/.claude/` and sends events to TermiPet's local service on `127.0.0.1`.

## Pet Chat Models

TermiPet supports local Ollama models such as Qwen2.5, Phi-3.5 mini, and Gemma 3 1B. Online mode supports OpenAI, Google Gemini, and custom OpenAI-compatible APIs. API keys are saved in macOS Keychain.

<p align="center">
  <img src="docs/images/termipet-local-models.png" width="860" alt="TermiPet local model settings">
</p>

<p align="center">
  <img src="docs/images/termipet-online-api.png" width="860" alt="TermiPet online API settings">
</p>

## Custom Pets

A pet package is a folder with at least:

```text
pet.json
spritesheet.webp
```

### Petdex Compatibility

TermiPet can import **Petdex / Codex-compatible pet packs**. In Settings -> Pets, choose a pet folder that contains `pet.json` and `spritesheet.webp`; TermiPet copies it into the local `ImportedPets` directory and uses it as a desktop companion.

Imported pets are copied into TermiPet's Application Support directory. The app is compatible with Codex-style pet packages.

## Acknowledgements

TermiPet is shaped by and built around practical workflows involving **Claude Code**, **Codex**, **Google Gemini**, **GitHub Copilot**, and **Ollama**. They are not official contributors to or endorsers of TermiPet, but the app integrates with related local workflows, status displays, usage reading, and pet chat experiences.

## License

TermiPet is licensed under the [Apache License 2.0](LICENSE).
