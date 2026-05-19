# TermiPet

<p align="center">
  <img src="Source/Sources/TermiPet/Resources/AppLogo.png" width="96" alt="TermiPet App Icon">
</p>

<p align="center">
  <b>macOS ターミナルと Claude Code ワークフローのためのデスクトップペット</b>
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
  <a href="#ダウンロードとインストール">ダウンロード</a>
  ·
  <a href="#主な機能">機能</a>
  ·
  <a href="#プライバシーとデータ">プライバシー</a>
  ·
  <a href="#star-history">Star History</a>
  ·
  <a href="#ソースからビルド">ビルド</a>
  ·
  <a href="#ライセンス">ライセンス</a>
</p>

TermiPet は macOS のデスクトップに浮かぶペット型アシスタントです。ターミナルユーザーと AI コーディングツールの利用者向けに、**ターミナル状態の確認**、**よく使うコマンドの送信**、**Claude Code / Codex / GitHub Copilot の利用状況表示**、そしてローカルモデルまたはオンライン API を使った**ペットとのチャット**を提供します。

<p align="center">
  <img src="docs/images/termipet-hero.png" width="100%" alt="TermiPet hero">
</p>

TermiPet はただの装飾ではありません。普段は静かに画面端にいて、必要なときだけツールバー、ステータスカード、コマンドパネル、ポモドーロ、チャットを開く小さなワークフローの入り口です。

<p align="center">
  <img src="docs/images/termipet-workspace-overview.png" width="100%" alt="TermiPet workspace overview">
</p>

## 主な機能

| 機能 | 説明 |
| --- | --- |
| フローティングペット | メニューバーアプリとして動作し、Dock を占有せずターミナルの近くに配置できます。 |
| ターミナル認識 | Terminal、iTerm2、Ghostty、Warp、WezTerm、Alacritty、Kitty などに対応します。 |
| ターミナルプレビュー | ウィンドウタイトル、出力の要約、現在の状態、注意事項を表示します。 |
| コマンドパネル | Claude Code のよく使うコマンドを内蔵し、カスタムコマンド、ピン留め、並べ替えに対応します。 |
| フォルダショートカット | プロジェクトフォルダを選択し、対応する `cd` コマンドをターミナルへ入力します。 |
| Claude Code Hook | 思考中、ツール呼び出し、権限確認、コンテキスト圧縮、完了などの状態を同期します。 |
| ペットチャット | Ollama、OpenAI、Google Gemini、OpenAI 互換のカスタム API に対応します。 |
| 性格設定 | ペット名、オーナー名、性格プリセット、カスタム Prompt、追加制約を設定できます。 |
| ポモドーロ | 25 分の集中時間と 5 分休憩をサポートし、完了時にペットが反応します。 |
| AI 利用状況カード | Claude Code、Codex、GitHub Copilot の軽量な利用状況を表示します。 |
| 内蔵・カスタムペット | Terminal Cat は TermiPet のマスコットです。独自のペットパッケージも読み込めます。 |
| 多言語とスキン | 簡体字中国語、繁体字中国語、英語、日本語、韓国語と複数のスキンに対応します。 |

## 画面プレビュー

### ステータスカードと権限確認

TermiPet は Claude Code などの AI コーディングツールの状態をフローティングカードとして表示します。プロジェクト、実行中の動作、作業ディレクトリ、Hook の情報、Allow / Deny の確認を見やすく整理します。

<p align="center">
  <img src="docs/images/termipet-claude-hook.png" width="430" alt="TermiPet Claude hook status">
</p>

### コマンドパネル

`/compact`、`/review`、`/status`、`/diff` などの Claude Code コマンドをすぐに入力できます。自分のコマンドを追加し、順序変更やピン留めもできます。

自動入力には macOS のアクセシビリティ権限が必要です。先にメニューバーの TermiPet アイコンをクリックし、「アクセシビリティ権限を要求」または「アクセシビリティ設定を開く」を選択してください。権限がない場合でもコマンドパネルは使えますが、コマンドはクリップボードにコピーされるだけなので、手動でターミナルへ貼り付ける必要があります。

<p align="center">
  <img src="docs/images/termipet-command-panel.png" width="360" alt="TermiPet command panel">
</p>

### ペットの切り替え

TermiPet には複数のペットが内蔵されています。デフォルトの `Terminal Cat` はマスコットで、待機、思考、実行、注意、エラー、睡眠、お祝いなどの状態に合わせて動きます。

さらに [Petdex コミュニティ](https://petdex.crafter.run/zh) から、Petdex / Codex 互換のペットパックを入手できます。

<p align="center">
  <img src="docs/images/termipet-pet-library.png" width="860" alt="TermiPet pet selection">
</p>

### ペットチャット

フローティングツールバーからチャットを開き、現在のペットと直接会話できます。ローカル Ollama、OpenAI、Google Gemini、OpenAI 互換 API を使えます。

<p align="center">
  <img src="docs/images/termipet-pet-chat.png" width="430" alt="TermiPet pet chat">
</p>

### ツールバーと利用状況カード

ペットの近くにマウスを置くと、コマンド、フォルダ、チャット、スキン、ポモドーロの入り口が表示されます。AI 利用状況カードでは Claude Code、Codex、GitHub Copilot の状態を確認できます。

<p align="center">
  <img src="docs/images/termipet-floating-panel.png" width="520" alt="TermiPet floating panel">
</p>

## プライバシーとデータ

TermiPet は Mac 上でローカルに動作し、**独自のクラウド中継サーバーを持ちません**。設定、キー、状態情報は基本的にローカルに保存され、外部モデルや公式サービスを明示的に設定した場合のみ、そのサービスのエンドポイントにリクエストを送信します。

| データ | 保存または利用方法 |
| --- | --- |
| オンラインモデル API Key | **macOS キーチェーンに保存**され、TermiPet のサーバーへアップロードされません。 |
| モデル Base URL とモデル名 | Application Support にローカル保存されます。 |
| ローカル Ollama チャット | Mac 上の Ollama サービスへ送信されます。 |
| OpenAI / Gemini / カスタム API チャット | 設定したプロバイダーのエンドポイントへ直接送信されます。 |
| Claude Code / Codex 利用状況 | ローカルの認証情報または設定を使い、Mac から公式 API へ直接リクエストします。 |
| Claude Code Hook 状態 | `127.0.0.1` のローカル TermiPet サービスにのみ送信されます。 |

## 要件

| 項目 | 要件 |
| --- | --- |
| OS | macOS 14.0 以降 |
| ビルド環境 | Swift 6 |
| ローカルチャット | 任意。ローカルモデルでチャットする場合のみ [Ollama](https://ollama.com) のインストールと起動が必要 |
| オンラインモデル | 任意、OpenAI、Google Gemini、または互換 API のキーが必要 |
| 権限 | ターミナルプレビューと入力には macOS アクセシビリティ権限が必要 |

## ダウンロードとインストール

### App を直接ダウンロード

通常のユーザーにはこの方法をおすすめします。Swift、Homebrew、その他の開発ツールは不要で、パッケージ済みの macOS App を直接ダウンロードできます。

1. [TermiPet Releases](https://github.com/bleeeet/TermiPet/releases) を開きます。
2. 最新リリースから `TermiPet-v0.1.1-macOS.zip` をダウンロードします。
3. 解凍して `TermiPet.app` を取り出します。
4. `TermiPet.app` を「アプリケーション」フォルダへ移動するか、そのままダブルクリックして起動します。
5. 初回起動時に macOS がブロックする場合は、「システム設定 -> プライバシーとセキュリティ」から実行を許可してください。

TermiPet は macOS のメニューバーに表示され、デフォルトでは Dock に表示されません。ターミナルプレビュー、クイックコマンドの自動入力、フォルダ `cd` の自動入力には macOS アクセシビリティ権限が必要です。権限がない場合、コマンドはクリップボードにコピーされるため、手動で貼り付けてください。

### ワンラインスクリプトでインストール

ターミナルに慣れている場合は、次のコマンドで GitHub Releases の最新版 `TermiPet.app` をダウンロードし、「アプリケーション」にインストールできます。

```zsh
curl -fsSL https://raw.githubusercontent.com/bleeeet/TermiPet/main/install.sh | zsh
```

実行前に [`install.sh`](install.sh) の内容を確認することもできます。

### Homebrew でインストール

Homebrew を使っている場合は、TermiPet の tap から最新版をインストールできます。

```zsh
brew tap bleeeet/termipet https://github.com/bleeeet/TermiPet
brew install --cask termipet
```

他の tap の同名 cask と区別したい場合は、完全な名前も使えます。

```zsh
brew install --cask bleeeet/termipet/termipet
```

## ソースからビルド

```zsh
git clone https://github.com/bleeeet/TermiPet.git
cd TermiPet
zsh Scripts/build-plugin.sh
```

このスクリプトはテスト、ビルド、リソースとペットパッケージのコピー、署名、`App/TermiPet.app` の起動を行います。

## Petdex 互換性

TermiPet は **Petdex / Codex 互換のペットパック**をインポートできます。「設定 -> ペット」で `pet.json` と `spritesheet.webp` を含むペットフォルダを選択すると、TermiPet はそれをローカルの `ImportedPets` ディレクトリへコピーし、デスクトップペットとして使用します。

## 謝辞

TermiPet の利用体験は、**Claude Code**、**Codex**、**Google Gemini**、**GitHub Copilot**、**Ollama** などの AI コーディングおよびモデルエコシステムに強く関係しています。これらは TermiPet の公式コントリビューターや推奨者ではありませんが、TermiPet は関連するローカルワークフロー、状態表示、利用状況の読み取り、ペットチャット体験に合わせて設計されています。

## Star History

<p align="center">
  <a href="https://www.star-history.com/#bleeeet/termipet&Date">
    <img alt="TermiPet Star History Chart" src="https://api.star-history.com/svg?repos=bleeeet/termipet&type=Date">
  </a>
</p>

## ライセンス

TermiPet は [Apache License 2.0](LICENSE) の下で公開されています。
