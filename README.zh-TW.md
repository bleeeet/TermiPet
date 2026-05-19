# TermiPet

<p align="center">
  <img src="Source/Sources/TermiPet/Resources/AppLogo.png" width="96" alt="TermiPet App Icon">
</p>

<p align="center">
  <b>一個面向 macOS 終端和 Claude Code 的桌面寵物助手</b>
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
  <a href="#下載與安裝">下載與安裝</a>
  ·
  <a href="#主要功能">主要功能</a>
  ·
  <a href="#隱私與資料">隱私</a>
  ·
  <a href="#star-history">Star History</a>
  ·
  <a href="#從原始碼建置">建置</a>
  ·
  <a href="#授權">授權</a>
</p>

TermiPet 是一個懸浮在 macOS 桌面上的寵物助手。它面向終端使用者和 AI 編程工具使用者，幫你**查看終端狀態**、**發送常用指令**、**觀察 Claude Code / Codex / GitHub Copilot 用量**，並支援透過本地模型或線上 API 和寵物聊天。

<p align="center">
  <img src="docs/images/termipet-hero.png" width="100%" alt="TermiPet hero">
</p>

它不是單純的桌面裝飾，而是一個**輕量工作流入口**：平時安靜待在螢幕邊緣，需要時展開工具列、狀態卡片、快捷指令、番茄鐘和聊天視窗。

<p align="center">
  <img src="docs/images/termipet-workspace-overview.png" width="100%" alt="TermiPet workspace overview">
</p>

## 主要功能

| 功能 | 說明 |
| --- | --- |
| 懸浮桌面寵物 | 以選單列 App 運行，不佔 Dock，可懸浮在螢幕邊緣或終端旁。 |
| 終端識別 | 支援 Terminal、iTerm2、Ghostty、Warp、WezTerm、Alacritty、Kitty 等終端。 |
| 終端預覽 | 聚焦終端時顯示視窗標題、輸出摘要、目前狀態和提醒。 |
| 快捷指令面板 | 內建 Claude Code 常用指令，也支援新增、置頂和排序自訂指令。 |
| 資料夾快捷入口 | 選擇專案資料夾後，自動向目標終端輸入對應的 `cd` 指令。 |
| Claude Code Hook | 同步 Claude Code 的思考、工具呼叫、等待授權、壓縮上下文和完成狀態。 |
| 寵物聊天 | 支援本地 Ollama、OpenAI、Google Gemini 和 OpenAI-compatible 自訂 API。 |
| 性格設定 | 支援寵物名稱、主人名稱、性格預設、自訂 Prompt 和額外約束。 |
| 番茄鐘 | 支援 25 分鐘專注和 5 分鐘休息，完成時觸發寵物慶祝動作。 |
| AI 用量卡片 | 嘗試讀取 Claude Code、Codex、GitHub Copilot 的輕量用量資訊。 |
| 內建和自訂寵物 | Terminal Cat 是 TermiPet 的吉祥物；也可匯入自訂寵物資源包。 |
| 多語言和皮膚 | 支援簡體中文、繁體中文、英文、日文、韓文，以及多種皮膚。 |

## 介面預覽

### 狀態卡片和授權提示

TermiPet 會把 Claude Code 等 AI 編程工具的狀態整理成懸浮卡片，顯示目前專案、執行動作、工作目錄和 Hook 來源。遇到需要授權的 Bash 或工具呼叫時，也可以在卡片中看到 Allow / Deny 操作。

<p align="center">
  <img src="docs/images/termipet-claude-hook.png" width="430" alt="TermiPet Claude hook status">
</p>

### 快捷指令面板

快捷指令面板把常用 Claude Code 指令放在手邊，適合頻繁使用 `/compact`、`/review`、`/status`、`/diff` 等指令的工作流。你可以一鍵輸入到目前終端，也可以新增自己的指令。

<p align="center">
  <img src="docs/images/termipet-command-panel.png" width="360" alt="TermiPet command panel">
</p>

### 可切換寵物

TermiPet 內建多款寵物，預設主角是 `Terminal Cat`。不同寵物會跟隨待機、思考、提醒、錯誤、睡覺和慶祝等狀態播放對應動作。

你也可以到 [Petdex 中文社群](https://petdex.crafter.run/zh) 取得更多 Petdex / Codex 相容的寵物資源包。

<p align="center">
  <img src="docs/images/termipet-pet-library.png" width="860" alt="TermiPet pet selection">
</p>

### 寵物對話

點擊懸浮工具列裡的聊天按鈕，就可以和目前寵物直接對話。聊天模型可以選擇本地 Ollama，也可以配置 OpenAI、Google Gemini 或相容 OpenAI API 的自訂服務。

<p align="center">
  <img src="docs/images/termipet-pet-chat.png" width="430" alt="TermiPet pet chat">
</p>

### 懸浮工具列和用量卡片

滑鼠移到寵物附近時，懸浮工具列會展開，提供快捷指令、專案資料夾、聊天、皮膚和番茄鐘入口。AI 用量卡片會讀取 Claude Code、Codex、GitHub Copilot 的輕量套餐狀態。

<p align="center">
  <img src="docs/images/termipet-floating-panel.png" width="520" alt="TermiPet floating panel">
</p>

## 隱私與資料

TermiPet 是本地運行的 macOS 應用，**沒有自建雲端中轉伺服器**。配置、密鑰和狀態讀取會盡量留在你的 Mac 上；只有在你主動配置外部模型或官方服務接口時，才會向對應地址發起請求。

| 資料類型 | 存放或使用方式 |
| --- | --- |
| 線上模型 API Key | **保存在 macOS 鑰匙圈中**，不會上傳到任何 TermiPet 自建伺服器。 |
| 模型 Base URL 和模型名 | 保存在本地 Application Support 目錄，用於決定請求哪個 API 地址。 |
| 本地 Ollama 聊天 | 請求發送到本機 Ollama 服務。 |
| OpenAI / Gemini / 自訂 API 聊天 | 只請求你配置的模型服務地址。TermiPet 不提供中轉服務。 |
| Claude Code / Codex 套餐讀取 | 使用本機已有憑據或本地配置，從本機直接請求對應官方接口。 |
| Claude Code Hook 狀態 | Hook 只把事件發送給本機 `127.0.0.1` 上的 TermiPet 本地服務。 |

## 系統需求

| 項目 | 要求 |
| --- | --- |
| 作業系統 | macOS 14.0 或更高版本 |
| 建置工具 | Swift 6 工具鏈 |
| 本地聊天 | 可選，需要安裝 [Ollama](https://ollama.com) |
| 線上模型 | 可選，需要 OpenAI、Google Gemini 或相容服務的 API Key |
| 系統權限 | 終端預覽和自動輸入需要 macOS 輔助使用權限 |

## 下載與安裝

普通使用者不需要自己編譯，可以直接下載已打包好的 macOS App：

1. 打開 [TermiPet Releases](https://github.com/bleeeet/TermiPet/releases)。
2. 下載最新版本中的 `TermiPet-v0.1-macOS.zip`。
3. 解壓後得到 `TermiPet.app`。
4. 將 `TermiPet.app` 拖到「應用程式」資料夾，或直接雙擊執行。
5. 首次開啟時，如果 macOS 提示來自未驗證開發者，可以到「系統設定 -> 隱私權與安全性」允許開啟。

TermiPet 會出現在 macOS 選單列中，預設不會顯示在 Dock。終端預覽、快捷指令輸入和資料夾 `cd` 輸入需要 macOS 輔助使用權限。

## 從原始碼建置

```zsh
git clone https://github.com/bleeeet/TermiPet.git
cd TermiPet
zsh Scripts/build-plugin.sh
```

腳本會執行測試、編譯 App、複製資源和預設寵物包、簽名本地版本，並啟動 `App/TermiPet.app`。

## Petdex 相容性

TermiPet 可以匯入 **Petdex / Codex 相容的寵物包**。在「設定 -> 寵物」中選擇包含 `pet.json` 和 `spritesheet.webp` 的寵物資料夾，TermiPet 會將它複製到本地 `ImportedPets` 目錄，並作為桌面寵物使用。

## 致謝

TermiPet 的使用場景受到 **Claude Code**、**Codex**、**Google Gemini**、**GitHub Copilot** 和 **Ollama** 等 AI 編程與模型生態啟發，也圍繞相關本地工作流、狀態顯示、用量讀取和寵物對話體驗做了適配。它們不是 TermiPet 的官方貢獻者或背書方。

## Star History

<p align="center">
  <a href="https://www.star-history.com/#bleeeet/termipet&Date">
    <img alt="TermiPet Star History Chart" src="https://api.star-history.com/svg?repos=bleeeet/termipet&type=Date">
  </a>
</p>

## 授權

TermiPet 使用 [Apache License 2.0](LICENSE) 授權。
