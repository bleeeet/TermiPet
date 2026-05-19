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
  <a href="#-下載與安裝">下載與安裝</a>
  ·
  <a href="#-主要功能">主要功能</a>
  ·
  <a href="#快速開始">快速開始</a>
  ·
  <a href="#隱私與數據">隱私與數據</a>
  ·
  <a href="#-star-history">Star History</a>
  ·
  <a href="#-使用方式">使用方式</a>
  ·
  <a href="#-開發">開發</a>
  ·
  <a href="#授權">授權</a>
</p>

TermiPet 是一個懸浮在 macOS 桌面上的寵物助手。它面向終端用戶和 AI 編程工具用戶，幫你**查看終端狀態**、**發送常用命令**、**觀察 Claude Code / Codex / GitHub Copilot 用量**，並支持用本地模型或線上 API 和寵物聊天。

<p align="center">
  <img src="docs/images/termipet-hero.png" width="100%" alt="TermiPet hero">
</p>

它不是單純的桌面裝飾，而是一個**輕量的工作流入口**：平時安靜待在屏幕邊緣，需要時展開工具欄、狀態卡片、快捷命令、番茄鍾和聊天窗口。

<p align="center">
  <img src="docs/images/termipet-workspace-overview.png" width="100%" alt="TermiPet workspace overview">
</p>

## ✨ 主要功能

| 功能 | 說明 |
| --- | --- |
| 🐾 懸浮桌面寵物 | 以菜單欄應用運行，不佔 Dock，可懸浮在屏幕邊緣或終端旁。 |
| 🖥️ 終端識別 | 支持 Terminal、iTerm2、Ghostty、Warp、WezTerm、Alacritty、Kitty 等終端。 |
| 👀 終端預覽 | 聚焦終端時顯示窗口標題、輸出摘要、當前狀態和提醒信息。 |
| ⚡ 快捷指令面板 | 內置 Claude Code 常用命令，也支持添加、置頂、排序自定義命令。 |
| 📁 文件夾快捷入口 | 選擇項目文件夾後，自動向目標終端輸入對應的 `cd` 命令。 |
| 🪝 Claude Code Hook | 同步 Claude Code 的思考、工具調用、等待授權、壓縮上下文、完成等狀態。 |
| 💬 寵物聊天 | 支持本地 Ollama、OpenAI、Google Gemini 和 OpenAI-compatible 自定義 API。 |
| 🎭 性格配置 | 支持寵物名、主人名、性格預設、自定義 Prompt 和額外約束。 |
| 🍅 番茄鍾 | 支持 25 分鐘專注和 5 分鐘休息，完成時觸發寵物慶祝動作。 |
| 📊 AI 用量卡片 | 嘗試讀取 Claude Code、Codex、GitHub Copilot 的輕量用量信息。 |
| 🐱 內置和自定義寵物 | 內置多款寵物，Terminal Cat 是 TermiPet 的吉祥物；也可導入自定義寵物資源包。 |
| 🌍 多語言和皮膚 | 支持簡體中文、繁體中文、英文、日文、韓文，以及玻璃、暗色、像素等皮膚。 |

## 🖼️ 界面預覽

### 狀態卡片和授權提示

TermiPet 會把 Claude Code 等 AI 編程工具的狀態整理成懸浮卡片，顯示當前項目、執行動作、工作目錄和 Hook 來源。遇到需要授權的 Bash 或工具調用時，也可以在卡片裡直接看到 Allow / Deny 操作，減少在終端窗口之間來回找提示的成本。

<p align="center">
  <img src="docs/images/termipet-claude-hook.png" width="430" alt="TermiPet Claude hook status">
</p>

### 快捷指令面板

快捷指令面板把常用 Claude Code 命令放在手邊，適合頻繁使用 `/compact`、`/review`、`/status`、`/diff` 等命令的工作流。你可以用它一鍵把命令輸入到當前終端，也可以在設置裡添加自己的命令、調整順序和置頂常用項。

自動輸入需要先點擊 macOS 頂部菜單欄裡的 TermiPet 圖標，並選擇「請求輔助功能授權」或「打開輔助功能設置」。如果沒有授予輔助功能權限，快捷指令仍可使用，但只能把命令複製到剪切板，需要你手動粘貼到終端。

<p align="center">
  <img src="docs/images/termipet-command-panel.png" width="360" alt="TermiPet command panel">
</p>

### 可切換寵物

TermiPet 內置多款寵物，默認主角是 `Terminal Cat`。寵物頁可以切換內置角色，也可以導入自己的寵物資源包；不同寵物會跟隨待機、思考、提醒、錯誤、慶祝等狀態播放對應動作。

你也可以到 [Petdex 中文社區](https://petdex.crafter.run/zh) 獲取更多 Petdex / Codex 兼容的寵物資源包。

<p align="center">
  <img src="docs/images/termipet-pet-library.png" width="860" alt="TermiPet pet selection">
</p>

### 寵物對話

點擊懸浮工具欄裡的聊天按鈕，就可以和當前寵物直接對話。對話窗口會跟隨桌面寵物一起出現，適合在寫代碼時快速問一句、讓寵物解釋當前狀態，或用不同性格預設獲得更有陪伴感的回應。聊天模型可以選擇本地 Ollama，也可以配置 OpenAI、Google Gemini 或兼容 OpenAI API 的自定義服務。

<p align="center">
  <img src="docs/images/termipet-pet-chat.png" width="430" alt="TermiPet pet chat">
</p>

### 懸浮工具欄和用量卡片

鼠標移到寵物附近時，懸浮工具欄會展開，提供快捷指令、項目文件夾、聊天、皮膚和番茄鍾入口。AI 用量卡片會讀取 Claude Code、Codex、GitHub Copilot 的輕量套餐狀態，幫助你在寫代碼時順手看一眼剩餘額度和重置時間。

<p align="center">
  <img src="docs/images/termipet-floating-panel.png" width="520" alt="TermiPet floating panel">
</p>

## 🔐隱私與數據

TermiPet 是本地運行的 macOS 應用，**沒有自建的雲端中轉服務器**。它儘量把配置、密鑰和狀態讀取都留在你的 Mac 上，只在你主動配置並使用外部模型或官方服務接口時，才會向對應的服務地址發起請求。

| 數據類型 | 存放或使用方式 |
| --- | --- |
| 線上模型 API Key | **保存在 macOS 鑰匙串中**，不寫入普通配置文件，也不會上傳到任何 TermiPet 自建服務器。 |
| 模型 Base URL 和模型名 | 保存在本地 Application Support 目錄，用於決定請求哪個 API 地址。 |
| 本地 Ollama 聊天 | 請求發送到本機 Ollama 服務，不經過外部模型 API。 |
| OpenAI / Gemini / 自定義 API 聊天 | 只會在你選擇線上模型時，請求你配置的模型服務地址。TermiPet 不提供中轉服務器。 |
| Claude Code / Codex 套餐讀取 | 讀取本機已有登錄憑據或本地配置，並從本機直接請求對應官方接口；**密鑰不會上傳到任何 TermiPet 自建服務器**。 |
| Claude Code Hook 狀態 | Hook 只把事件發送給本機 `127.0.0.1` 上的 TermiPet 本地服務，用於更新寵物狀態。 |
| 終端預覽和快捷輸入 | 依賴 macOS 輔助功能權限，在本機識別窗口標題、部分文本和輸入命令。 |

換句話說：TermiPet 本身更像一個**本地插件和桌面助手**。聊天 API 會走你配置的請求地址；套餐讀取會用本地已有憑據請求對應服務；終端狀態、寵物配置、快捷指令和 API Key 都保存在本地。

## 💻 系統要求

| 項目 | 要求 |
| --- | --- |
| 💻 操作系統 | macOS 14.0 或更高版本 |
| 🧰 構建工具 | 僅從源碼構建時需要 Swift 6 工具鏈 |
| 🏠 本地聊天 | 可選；只有使用本地模型聊天時才需要安裝並啟動 [Ollama](https://ollama.com) |
| ☁️ 線上模型 | 可選，需要 OpenAI、Google Gemini 或兼容服務的 API Key |
| 🔓 系統權限 | 終端預覽和自動輸入需要 macOS 輔助功能權限 |

## 📦 下載與安裝

### 🚀 直接下載 App

最推薦普通用戶使用這個方式：不需要安裝 Swift、Homebrew 或其他開發工具，直接下載已經打包好的 macOS App。

1. 打開 [TermiPet Releases](https://github.com/bleeeet/TermiPet/releases)。
2. 下載最新版本里的 `TermiPet-v0.1.1-macOS.zip`。
3. 解壓後得到 `TermiPet.app`。
4. 將 `TermiPet.app` 拖到「應用程序」文件夾，或直接雙擊運行。
5. 首次打開時，如果 macOS 提示來自未驗證開發者，可以在「系統設置 -> 隱私與安全性」裡允許打開。

啟動後，TermiPet 會出現在 macOS 菜單欄中。它默認不會顯示在 Dock 裡。

終端預覽、快捷命令自動輸入、文件夾 `cd` 自動輸入等能力需要 macOS 輔助功能權限。可以通過菜單欄裡的「請求輔助功能授權」和「打開輔助功能設置」完成授權；未授權時，快捷指令會複製到剪切板，需要手動粘貼。

### 🧪 一行腳本安裝

如果你習慣用終端，也可以運行下面這行命令，腳本會自動下載 GitHub Releases 裡的最新版 `TermiPet.app` 並安裝到「應用程序」：

```zsh
curl -fsSL https://raw.githubusercontent.com/bleeeet/TermiPet/main/install.sh | zsh
```

如果你想先查看腳本內容，也可以打開 [`install.sh`](install.sh) 後再決定是否運行。

### 🍺 Homebrew 安裝

如果你使用 Homebrew，可以通過 TermiPet 的 tap 安裝最新版：

```zsh
brew tap bleeeet/termipet https://github.com/bleeeet/TermiPet
brew install --cask termipet
```

也可以使用完整名稱，避免和其他 tap 裡的同名 cask 混淆：

```zsh
brew install --cask bleeeet/termipet/termipet
```

> 維護說明：Homebrew 會直接從當前倉庫讀取 [`Casks/termipet.rb`](Casks/termipet.rb)。每次發佈新版 Release 後，需要更新裡面的 `version` 和 `sha256`。

### 🧰 從源碼構建

進入項目根目錄後運行：

```zsh
zsh Scripts/build-plugin.sh
```

腳本會自動完成以下步驟：

1. 運行全部測試。
2. 編譯 Swift Package。
3. 生成並刷新 `App/TermiPet.app`。
4. 複製二進制、資源和默認寵物包。
5. 清理擴展屬性。
6. 使用本地自簽證書籤名；如果證書不可用，會回退到 ad-hoc 簽名。
7. 關閉舊版本 TermiPet 進程並啟動新版本應用。

更詳細的普通用戶操作說明見 [USAGE.md](USAGE.md)。

## 🏁快速開始

### 1. 顯示寵物

點擊菜單欄裡的 TermiPet 圖標，選擇「顯示寵物」。

### 2. 授予輔助功能權限

如果你想使用終端預覽、快捷命令輸入、文件夾 `cd` 輸入等能力，需要授予 macOS 輔助功能權限。

操作步驟：

1. 點擊菜單欄 TermiPet 圖標。
2. 選擇「請求輔助功能授權」或「打開輔助功能設置」。
3. 在系統設置的輔助功能頁面裡找到 TermiPet。
4. 打開 TermiPet 的權限。
5. 如果沒有立即生效，重啟 TermiPet。

沒有輔助功能權限時，寵物仍然可以顯示和聊天，但終端讀取、自動輸入和部分狀態識別會受限。

### 3. 使用懸浮工具欄

把鼠標移動到寵物上方，會出現一排工具按鈕：

| 按鈕 | 用途 |
| --- | --- |
| 🖥️ 終端 | 打開或收起快捷指令面板 |
| 📁 文件夾 | 選擇文件夾並向終端輸入 `cd` |
| 💬 聊天 | 打開寵物聊天窗口 |
| 🎨 調色板 | 在皮膚之間循環切換 |
| 🍅 計時器 | 開始、暫停或繼續 25 分鐘番茄鍾 |
| ⏹️ 停止 | 番茄鍾運行時停止計時 |
| ☕ 杯子 | 開始 5 分鐘休息 |

寵物下方還有動作按鈕，可手動觸發待機、運行、移動、開心、提醒、錯誤、睡覺、思考、慶祝等動畫。

## 🎮 使用方式

### 快速發送 Claude Code 命令

1. 打開並聚焦一個終端窗口。
2. 鼠標移到寵物上。
3. 點擊終端按鈕。
4. 從快捷指令面板選擇命令。

如果要讓 TermiPet 自動把命令輸入到終端，需要先點擊 macOS 頂部菜單欄裡的 TermiPet 圖標，選擇「請求輔助功能授權」或「打開輔助功能設置」，並在系統設置中允許 TermiPet。沒有輔助功能權限時，命令只會複製到剪切板，需要你手動粘貼。

內置命令包括：

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

你也可以在「設置 -> 快捷指令」裡添加自己的命令，並調整置頂和排序。

<p align="center">
  <img src="docs/images/termipet-command-settings.png" width="860" alt="TermiPet command settings">
</p>

### 📁 快速切換項目目錄

點擊文件夾按鈕，選擇一個項目文件夾。TermiPet 會把對應的 `cd` 命令輸入到最近使用的目標終端中。

### 👀 查看 Claude Code 狀態

TermiPet 可以通過 Claude Code Hook 接收開發 Agent 狀態。安裝後，寵物卡片可以顯示 Claude Code 是否正在思考、調用工具、等待授權、壓縮上下文或已經完成。

菜單欄提供：

- 安裝 Claude Code Hook
- 卸載 Claude Code Hook

安裝動作會修改：

```text
~/.claude/settings.json
~/.claude/hooks/
```

第一次安裝時會備份原始設置到：

```text
~/.claude/settings.json.floating-pet.bak
```

安裝後需要重啟正在運行的 `claude` 進程才能生效。Hook 會把本機 Claude Code 事件發送給 TermiPet 啟動在 `127.0.0.1` 的本地服務，用於更新寵物狀態，不需要外部服務器參與。

### 💬 和寵物聊天

點擊聊天按鈕即可打開聊天窗口。聊天模型有兩種來源：

| 模型來源 | 說明 |
| --- | --- |
| 本地 Ollama | 適合希望本地運行、減少外部 API 依賴的用戶。 |
| 線上 API | 支持 OpenAI、Google Gemini 和兼容 OpenAI Chat Completions 的自定義服務。 |

API Key 會保存在 macOS 鑰匙串中，普通配置會保存在 Application Support 目錄。

## ⚙️ 設置

從菜單欄點擊「設置...」，或右鍵寵物選擇「設置...」，可以進入設置窗口。

| 頁面 | 用途 |
| --- | --- |
| ℹ️ 關於 | 查看版本、開發者和項目信息。 |
| 🎨 皮膚 | 切換玻璃、暗色、像素等外觀。 |
| 🌍 語言 | 切換簡體中文、繁體中文、英文、日文、韓文，重啟後完整生效。 |
| ⚡ 快捷指令 | 管理內置命令和自定義命令，支持添加、刪除、置頂和拖拽排序。 |
| 🐾 寵物 | 導入並選擇寵物資源包。 |
| 🎭 性格 | 配置寵物名稱、主人名稱、性格預設、自定義 Prompt 和額外約束。 |
| 🧠 模型 | 配置本地 Ollama 或線上 API 聊天模型。 |

<p align="center">
  <img src="docs/images/termipet-personality-settings.png" width="860" alt="TermiPet personality settings">
</p>

## 🧠 寵物聊天模型

### 本地模型

設置路徑：`設置 -> 模型 -> 本地模型`。

TermiPet 會檢測 Ollama 是否運行。內置模型目錄包括：

<p align="center">
  <img src="docs/images/termipet-local-models.png" width="860" alt="TermiPet local model settings">
</p>

| 模型 | 說明 | 大小 |
| --- | --- | --- |
| Qwen2.5 0.5B | 極輕量，適合低配，中文優秀 | ~400MB |
| Qwen2.5 1.5B | 推薦，中文較好，速度快 | ~1.1GB |
| Phi-3.5 mini | 小體積高質量 | ~2.2GB |
| Gemma 3 1B | 均衡輕量 | ~815MB |

未下載的模型不能直接選擇。可以在設置頁啟動 Ollama、打開安裝頁、下載推薦模型或手動刷新檢測結果。

### 線上 API

設置路徑：`設置 -> 模型 -> 線上 API`。

支持：

<p align="center">
  <img src="docs/images/termipet-online-api.png" width="860" alt="TermiPet online API settings">
</p>

- OpenAI，默認 Base URL 為 `https://api.openai.com/v1`。
- Google Gemini，默認 Base URL 為 `https://generativelanguage.googleapis.com/v1beta`。
- 自定義 API，適用於兼容 OpenAI Chat Completions 格式的服務。

API Key 會保存在 macOS 鑰匙串中；Base URL、模型名等非敏感配置會保存在 Application Support 目錄。填寫後建議先點擊「讀取模型」和「測試連接」。

## 🎨 自定義寵物

TermiPet 內置多款寵物。默認主角是 `Terminal Cat`，它是一隻陪在終端旁邊的小貓，也是這個軟件的吉祥物。內置寵物裡還包括偏像素風的貓、巫師克勞德、Mochi 等角色；你也可以導入自己的寵物資源包，與 Codex 寵物文件兼容。

### Petdex 兼容性

TermiPet 可以導入 **Petdex / Codex 兼容的寵物包**：在「設置 -> 寵物」中選擇一個包含 `pet.json` 和 `spritesheet.webp` 的寵物文件夾，TermiPet 會把它複製到本地 `ImportedPets` 目錄並作為桌面寵物使用。

寵物資源包是一個文件夾，至少需要包含：

```text
pet.json
spritesheet.webp
```

`pet.json` 示例：

```json
{
  "id": "example-pet",
  "displayName": "Example Pet",
  "description": "A custom pixel pet.",
  "spritesheetPath": "spritesheet.webp"
}
```

spritesheet 默認按 9 行動作解析：

| 索引 | 動作 |
| --- | --- |
| 0 | 待機 |
| 1 | 運行 |
| 2 | 移動 |
| 3 | 開心 |
| 4 | 提醒 |
| 5 | 錯誤 |
| 6 | 睡覺 |
| 7 | 思考 |
| 8 | 慶祝 |

導入後的寵物會複製到：

```text
~/Library/Application Support/TermiPet/ImportedPets/
```

當前選擇記錄保存在：

```text
~/Library/Application Support/TermiPet/selected-pet.json
```

## 🧭 設計思路

TermiPet 的設計分成三層：

### 懸浮陪伴層

寵物是用戶看得見的入口。它默認保持輕量，不強行佔用注意力；當鼠標懸停時，再展開工具欄、狀態卡片、用量卡片和聊天窗口。

### 工作流輔助層

TermiPet 會識別當前終端、編輯器和 AI 對話應用，並把這些上下文轉成更容易看的狀態提示。

它重點服務三個動作：

- 看：查看終端、編輯器、Agent 和 AI 用量狀態。
- 點：點擊發送常用命令、切換目錄、啟動計時。
- 聊：通過本地或線上模型和寵物對話。

### 配置擴展層

命令、寵物、皮膚、語言、聊天模型、性格 Prompt 都做成可配置內容。後續可以繼續擴展寵物資源包、命令模板、模型服務和更多開發工作流。

## 🗂️ 項目結構

```text
.
├── README.md
├── USAGE.md
├── LICENSE
├── Scripts/
│   ├── build-plugin.sh          # 測試、構建、簽名並啟動 App
│   └── open-plugin.sh           # 打開已有 App
├── Source/
│   ├── Package.swift            # Swift Package 配置
│   ├── AppBundle/               # Info.plist 與 App 圖標
│   ├── Sources/
│   │   ├── TermiPet/            # macOS App、SwiftUI 界面和系統集成
│   │   └── TermiPetCore/        # 核心模型、配置、策略和純邏輯
│   └── Tests/TermiPetTests/     # 單元測試
├── Pets/                        # 默認寵物資源包
├── icon/                        # 原始圖標和社交圖標素材
└── App/TermiPet.app             # 構建產物，由腳本生成
```

## 🧑‍💻 開發

完整構建、測試、簽名並啟動：

```zsh
zsh Scripts/build-plugin.sh
```

生成發佈 zip：

```zsh
zsh Scripts/package-release.sh 0.1.1
```

僅運行測試：

```zsh
cd Source
swift test
```

僅編譯調試版本：

```zsh
cd Source
swift build -c debug
```

源碼構建會在本機生成 `App/TermiPet.app`，適合開發者自己調試或打包。

## 📝 配置文件

TermiPet 的用戶配置主要保存在：

```text
~/Library/Application Support/TermiPet/
```

常見文件：

| 文件 | 說明 |
| --- | --- |
| `config.json` | 快捷指令配置 |
| `personality.json` | 寵物性格配置 |
| `ollama-config.json` | 模型來源、Base URL 和模型名 |
| `selected-pet.json` | 當前選擇的寵物文件夾路徑 |
| `ImportedPets/` | 導入後的寵物資源包 |

線上模型 API Key 保存在 macOS 鑰匙串中，不寫入普通 JSON 配置文件。

## 🛡️ 權限和隱私

TermiPet 可能需要輔助功能權限，用於：

- 識別當前前臺終端、編輯器或 AI 應用。
- 讀取終端窗口標題和部分文本，生成終端預覽。
- 將快捷指令或 `cd` 命令輸入到終端。

如果不授權，應用仍可運行，但終端預覽和自動輸入能力會受限。可以通過菜單欄「打開輔助功能設置」前往系統設置授權。更完整的數據說明見上方「隱私與數據」。

## 🗺️ Roadmap

- 提供更穩定的安裝包發佈流程。
- 增加更多默認寵物資源。
- 增強更多 AI 編程工具的狀態識別。
- 優化新手引導和首次授權體驗。

## 🤝 貢獻建議

- 行為改動請補充或更新測試。
- 修改代碼或資源後請運行 `zsh Scripts/build-plugin.sh` 並驗證 App。

## 🙏 致謝

TermiPet 的使用場景離不開這些 AI 編程和模型生態的啟發與兼容支持：**Claude Code**、**Codex**、**Google Gemini**、**GitHub Copilot** 和 **Ollama**。它們不是 TermiPet 的官方貢獻者或背書方，但 TermiPet 圍繞這些工具的本地工作流、狀態顯示、用量讀取和寵物對話體驗做了適配。

感謝 **@Dinny-xu** 和 **@Gnonymous** 報告並協助定位 v0.1 安裝包中的資源 bundle 加載問題。

## 👍 支持項目

### ☕ 請我喝杯咖啡

如果 TermiPet 讓你的終端變得更有趣、更有生產力，歡迎在 [愛發電](https://afdian.com/a/bleethen) 上請我喝杯咖啡。

作為一名獨立開發者，所有贊助都會直接用於覆蓋項目的各大 API 測試 Token、服務器等硬性開銷，讓這個開源小工具能走得更遠。不讚助也完全沒關係，點個 ⭐ 或是推薦給身邊用 macOS 的朋友，都是對我極大的支持。

### 💼 商業合作 / 團隊定製

想基於 TermiPet 繼續開發商業使用，或者有其他定製 macOS AI 工具合作，歡迎隨時通過郵件聊聊：[bleetchenxuanling@gmail.com](mailto:bleetchenxuanling@gmail.com)。

## ⭐ Star History

<p align="center">
  <a href="https://www.star-history.com/#bleeeet/termipet&Date">
    <img alt="TermiPet Star History Chart" src="https://api.star-history.com/svg?repos=bleeeet/termipet&type=Date">
  </a>
</p>

## 授權

本專案使用 Apache License 2.0。詳見 [LICENSE](LICENSE)。
