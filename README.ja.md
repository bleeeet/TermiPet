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
  <a href="#-ダウンロードとインストール">ダウンロードとインストール</a>
  ·
  <a href="#-主な機能">主な機能</a>
  ·
  <a href="#クイックスタート">クイックスタート</a>
  ·
  <a href="#プライバシーとデータ">プライバシーとデータ</a>
  ·
  <a href="#-star-history">Star History</a>
  ·
  <a href="#-使い方">使い方</a>
  ·
  <a href="#-開発">開発</a>
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

## ✨ 主な機能

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

## 🖼️ 画面プレビュー

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

## 🔐プライバシーとデータ

TermiPet は Mac 上でローカルに動作し、**独自のクラウド中継サーバーを持ちません**。設定、キー、状態情報は基本的にローカルに保存され、外部モデルや公式サービスを明示的に設定した場合のみ、そのサービスのエンドポイントにリクエストを送信します。

| データ | 保存または利用方法 |
| --- | --- |
| オンラインモデル API Key | **macOS キーチェーンに保存**され、TermiPet のサーバーへアップロードされません。 |
| モデル Base URL とモデル名 | Application Support にローカル保存されます。 |
| ローカル Ollama チャット | Mac 上の Ollama サービスへ送信されます。 |
| OpenAI / Gemini / カスタム API チャット | 設定したプロバイダーのエンドポイントへ直接送信されます。 |
| Claude Code / Codex 利用状況 | ローカルの認証情報または設定を使い、Mac から公式 API へ直接リクエストします。 |
| Claude Code Hook 状態 | `127.0.0.1` のローカル TermiPet サービスにのみ送信されます。 |

## 💻 要件

| 項目 | 要件 |
| --- | --- |
| OS | macOS 13.0 以降 |
| ビルド環境 | Swift 6 |
| ローカルチャット | 任意。ローカルモデルでチャットする場合のみ [Ollama](https://ollama.com) のインストールと起動が必要 |
| オンラインモデル | 任意、OpenAI、Google Gemini、または互換 API のキーが必要 |
| 権限 | ターミナルプレビューと入力には macOS アクセシビリティ権限が必要 |

## 📦 ダウンロードとインストール

### 🚀 App を直接ダウンロード

通常のユーザーにはこの方法をおすすめします。Swift、Homebrew、その他の開発ツールは不要で、パッケージ済みの macOS App をそのままダウンロードできます。

1. [TermiPet Releases](https://github.com/bleeeet/TermiPet/releases) を開きます。
2. 最新リリースから `TermiPet-v0.1.2-macOS.zip` をダウンロードします。
3. 解凍して `TermiPet.app` を取り出します。
4. `TermiPet.app` を「アプリケーション」フォルダへ移動するか、そのままダブルクリックして起動します。
5. 初回起動時に macOS が未確認の開発元として警告する場合は、「システム設定 -> プライバシーとセキュリティ」から実行を許可してください。

起動後、TermiPet は macOS のメニューバーに表示されます。デフォルトでは Dock には表示されません。

ターミナルプレビュー、クイックコマンドの自動入力、フォルダ `cd` の自動入力には macOS のアクセシビリティ権限が必要です。メニューバーの「アクセシビリティ権限を要求」または「アクセシビリティ設定を開く」から許可できます。権限がない場合、クイックコマンドはクリップボードにコピーされ、手動で貼り付ける必要があります。

### 🧪 ワンラインスクリプトでインストール

ターミナルに慣れている場合は、次のコマンドで GitHub Releases の最新版 `TermiPet.app` をダウンロードし、「アプリケーション」にインストールできます。

```zsh
curl -fsSL https://raw.githubusercontent.com/bleeeet/TermiPet/main/install.sh | zsh
```

実行前に [`install.sh`](install.sh) の内容を確認することもできます。

### 🍺 Homebrew でインストール

Homebrew を使っている場合は、TermiPet の tap から最新版をインストールできます。

```zsh
brew tap bleeeet/termipet https://github.com/bleeeet/TermiPet
brew install --cask termipet
```

他の tap の同名 cask と区別したい場合は、完全な名前も使えます。

```zsh
brew install --cask bleeeet/termipet/termipet
```

> メンテナンスメモ: Homebrew はこのリポジトリの [`Casks/termipet.rb`](Casks/termipet.rb) を直接読みます。新しい Release を公開するたびに、`version` と `sha256` を更新する必要があります。

### 🧰 ソースからビルド

プロジェクトルートで次を実行します。

```zsh
zsh Scripts/build-plugin.sh
```

このスクリプトは自動で次を行います。

1. すべてのテストを実行します。
2. Swift Package をビルドします。
3. `App/TermiPet.app` を生成して更新します。
4. バイナリ、リソース、デフォルトのペットパックをコピーします。
5. 拡張属性をクリアします。
6. ローカルの自己署名証明書で署名します。証明書が使えない場合は ad-hoc 署名へフォールバックします。
7. 古い TermiPet プロセスを終了し、新しいアプリを起動します。

一般ユーザー向けの詳しい操作説明は [USAGE.md](USAGE.md) を参照してください。

## 🏁クイックスタート

### 1. ペットを表示する

メニューバーの TermiPet アイコンをクリックし、「ペットを表示」を選択します。

### 2. アクセシビリティ権限を許可する

ターミナルプレビュー、クイックコマンド入力、フォルダ `cd` 入力を使う場合は、macOS のアクセシビリティ権限を許可します。

手順:

1. メニューバーの TermiPet アイコンをクリックします。
2. 「アクセシビリティ権限を要求」または「アクセシビリティ設定を開く」を選択します。
3. システム設定のアクセシビリティページで TermiPet を見つけます。
4. TermiPet の権限をオンにします。
5. すぐに反映されない場合は、TermiPet を再起動します。

アクセシビリティ権限がなくても、ペットの表示とチャットは利用できます。ただし、ターミナル読み取り、自動入力、一部の状態認識は制限されます。

### 3. フローティングツールバーを使う

ペットの上にマウスを移動すると、ツールボタンの列が表示されます。

| ボタン | 用途 |
| --- | --- |
| 🖥️ ターミナル | クイックコマンドパネルを開く、または閉じる |
| 📁 フォルダ | フォルダを選択してターミナルに `cd` を入力する |
| 💬 チャット | ペットチャットウィンドウを開く |
| 🎨 パレット | スキンを順番に切り替える |
| 🍅 タイマー | 25 分のポモドーロを開始、一時停止、再開する |
| ⏹️ 停止 | ポモドーロ実行中にタイマーを停止する |
| ☕ カップ | 5 分休憩を開始する |

ペットの下にはアクションボタンもあり、待機、実行、移動、喜び、注意、エラー、睡眠、思考、お祝いなどのアニメーションを手動で再生できます。

## 🎮 使い方

### Claude Code コマンドをすばやく送信する

1. ターミナルウィンドウを開いてフォーカスします。
2. マウスをペットの上に移動します。
3. ターミナルボタンをクリックします。
4. クイックコマンドパネルからコマンドを選びます。

TermiPet にコマンドをターミナルへ自動入力させるには、先に macOS メニューバーの TermiPet アイコンをクリックし、「アクセシビリティ権限を要求」または「アクセシビリティ設定を開く」を選択して、システム設定で TermiPet を許可してください。権限がない場合、コマンドはクリップボードにコピーされるだけなので、手動で貼り付ける必要があります。

内蔵コマンドには次が含まれます。

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

「設定 -> クイックコマンド」で自分のコマンドを追加し、ピン留めや並び順も調整できます。

<p align="center">
  <img src="docs/images/termipet-command-settings.png" width="860" alt="TermiPet command settings">
</p>

### 📁 プロジェクトディレクトリをすばやく切り替える

フォルダボタンをクリックしてプロジェクトフォルダを選択します。TermiPet は対応する `cd` コマンドを、最近使った対象ターミナルへ入力します。

### 👀 Claude Code の状態を見る

TermiPet は Claude Code Hook を通じて開発 Agent の状態を受け取れます。インストール後、ペットカードには Claude Code が思考中か、ツール呼び出し中か、権限待ちか、コンテキスト圧縮中か、完了済みかを表示できます。

メニューバーには次の項目があります。

- Claude Code Hook をインストール
- Claude Code Hook をアンインストール

インストール操作は次を変更します。

```text
~/.claude/settings.json
~/.claude/hooks/
```

初回インストール時、元の設定は次へバックアップされます。

```text
~/.claude/settings.json.floating-pet.bak
```

インストール後、実行中の `claude` プロセスを再起動すると有効になります。Hook はローカルの Claude Code イベントを `127.0.0.1` で動く TermiPet のローカルサービスへ送信し、ペット状態を更新します。外部サーバーは不要です。

### 💬 ペットとチャットする

チャットボタンをクリックするとチャットウィンドウが開きます。チャットモデルには 2 つのソースがあります。

| モデルソース | 説明 |
| --- | --- |
| ローカル Ollama | ローカル実行を重視し、外部 API 依存を減らしたいユーザー向け。 |
| オンライン API | OpenAI、Google Gemini、OpenAI Chat Completions 互換のカスタムサービスに対応。 |

API Key は macOS キーチェーンに保存され、通常設定は Application Support ディレクトリに保存されます。

## ⚙️ 設定

メニューバーの「設定...」をクリックするか、ペットを右クリックして「設定...」を選ぶと、設定ウィンドウを開けます。

| ページ | 用途 |
| --- | --- |
| ℹ️ 情報 | バージョン、開発者、プロジェクト情報を確認する。 |
| 🎨 スキン | ガラス、ダーク、ピクセルなどの外観を切り替える。 |
| 🌍 言語 | 簡体字中国語、繁体字中国語、英語、日本語、韓国語を切り替える。完全反映には再起動が必要。 |
| ⚡ クイックコマンド | 内蔵コマンドとカスタムコマンドを管理し、追加、削除、ピン留め、ドラッグ並べ替えに対応。 |
| 🐾 ペット | ペットリソースパックをインポートして選択する。 |
| 🎭 性格 | ペット名、オーナー名、性格プリセット、カスタム Prompt、追加制約を設定する。 |
| 🧠 モデル | ローカル Ollama またはオンライン API のチャットモデルを設定する。 |

<p align="center">
  <img src="docs/images/termipet-personality-settings.png" width="860" alt="TermiPet personality settings">
</p>

## 🧠 ペットチャットモデル

### ローカルモデル

設定パス: `設定 -> モデル -> ローカルモデル`。

TermiPet は Ollama が実行中かどうかを検出します。内蔵モデルカタログには次が含まれます。

<p align="center">
  <img src="docs/images/termipet-local-models.png" width="860" alt="TermiPet local model settings">
</p>

| モデル | 説明 | サイズ |
| --- | --- | --- |
| Qwen2.5 0.5B | 非常に軽量で低スペック環境向け、中国語も優秀 | ~400MB |
| Qwen2.5 1.5B | 推奨。中国語品質が高く高速 | ~1.1GB |
| Phi-3.5 mini | 小型で高品質 | ~2.2GB |
| Gemma 3 1B | バランスのよい軽量モデル | ~815MB |

未ダウンロードのモデルは直接選択できません。設定ページから Ollama を起動したり、インストールページを開いたり、推奨モデルをダウンロードしたり、検出結果を手動更新できます。

### オンライン API

設定パス: `設定 -> モデル -> オンライン API`。

対応プロバイダー:

<p align="center">
  <img src="docs/images/termipet-online-api.png" width="860" alt="TermiPet online API settings">
</p>

- OpenAI。デフォルト Base URL は `https://api.openai.com/v1`。
- Google Gemini。デフォルト Base URL は `https://generativelanguage.googleapis.com/v1beta`。
- カスタム API。OpenAI Chat Completions 形式に互換性のあるサービス向け。

API Key は macOS キーチェーンに保存されます。Base URL、モデル名などの非機密設定は Application Support ディレクトリに保存されます。入力後は、まず「モデルを読み込む」と「接続をテスト」をクリックすることをおすすめします。

## 🎨 カスタムペット

TermiPet には複数のペットが内蔵されています。デフォルトの主役は `Terminal Cat` で、ターミナルのそばにいる小さな猫であり、このアプリのマスコットです。内蔵ペットにはピクセル風の猫、Wizard Claude、Mochi なども含まれます。Codex ペットファイルと互換性のある独自のペットリソースパックもインポートできます。

### Petdex 互換性

TermiPet は **Petdex / Codex 互換のペットパック**をインポートできます。「設定 -> ペット」で `pet.json` と `spritesheet.webp` を含むペットフォルダを選択すると、TermiPet はそれをローカルの `ImportedPets` ディレクトリへコピーし、デスクトップペットとして使用します。

ペットリソースパックはフォルダで、少なくとも次を含む必要があります。

```text
pet.json
spritesheet.webp
```

`pet.json` の例:

```json
{
  "id": "example-pet",
  "displayName": "Example Pet",
  "description": "A custom pixel pet.",
  "spritesheetPath": "spritesheet.webp"
}
```

spritesheet はデフォルトで 9 行のアクションとして解析されます。

| インデックス | アクション |
| --- | --- |
| 0 | 待機 |
| 1 | 実行 |
| 2 | 移動 |
| 3 | 喜び |
| 4 | 注意 |
| 5 | エラー |
| 6 | 睡眠 |
| 7 | 思考 |
| 8 | お祝い |

インポートされたペットは次へコピーされます。

```text
~/Library/Application Support/TermiPet/ImportedPets/
```

現在の選択は次に保存されます。

```text
~/Library/Application Support/TermiPet/selected-pet.json
```

## 🧭 設計思想

TermiPet の設計は 3 つの層に分かれています。

### フローティングコンパニオン層

ペットはユーザーが目にする入口です。デフォルトでは軽量に保たれ、注意を強制的に奪いません。ホバーしたときだけ、ツールバー、ステータスカード、使用量カード、チャットウィンドウを展開します。

### ワークフロー支援層

TermiPet は現在のターミナル、エディタ、AI チャットアプリを認識し、それらのコンテキストを読みやすい状態ヒントへ変換します。

主に 3 つの操作を支援します。

- 見る: ターミナル、エディタ、Agent、AI 使用量の状態を確認する。
- 押す: よく使うコマンドの送信、ディレクトリ切り替え、タイマー開始をクリックで行う。
- 話す: ローカルまたはオンラインモデルを通じてペットと会話する。

### 設定と拡張層

コマンド、ペット、スキン、言語、チャットモデル、性格 Prompt はすべて設定可能です。今後もペットリソースパック、コマンドテンプレート、モデルサービス、さらに多くの開発ワークフローを拡張できます。

## 🗂️ プロジェクト構成

```text
.
├── README.md
├── USAGE.md
├── LICENSE
├── Scripts/
│   ├── build-plugin.sh          # テスト、ビルド、署名、App 起動
│   └── open-plugin.sh           # 既存 App を開く
├── Source/
│   ├── Package.swift            # Swift Package 設定
│   ├── AppBundle/               # Info.plist と App アイコン
│   ├── Sources/
│   │   ├── TermiPet/            # macOS App、SwiftUI UI、システム連携
│   │   └── TermiPetCore/        # コアモデル、設定、ポリシー、純粋ロジック
│   └── Tests/TermiPetTests/     # ユニットテスト
├── Pets/                        # デフォルトペットリソースパック
├── icon/                        # 元アイコンとソーシャルプレビュー素材
└── App/TermiPet.app             # スクリプトが生成するビルド成果物
```

## 🧑‍💻 開発

完全なビルド、テスト、署名、起動:

```zsh
zsh Scripts/build-plugin.sh
```

リリース zip の生成:

```zsh
zsh Scripts/package-release.sh 0.1.2
```

テストのみ実行:

```zsh
cd Source
swift test
```

デバッグ版のみビルド:

```zsh
cd Source
swift build -c debug
```

ソースからビルドすると、ローカルに `App/TermiPet.app` が生成されます。開発者のテストやパッケージングに適しています。

## 📝 設定ファイル

TermiPet のユーザー設定は主に次へ保存されます。

```text
~/Library/Application Support/TermiPet/
```

主なファイル:

| ファイル | 説明 |
| --- | --- |
| `config.json` | クイックコマンド設定 |
| `personality.json` | ペット性格設定 |
| `ollama-config.json` | モデルソース、Base URL、モデル名 |
| `selected-pet.json` | 現在選択中のペットフォルダパス |
| `ImportedPets/` | インポートされたペットリソースパック |

オンラインモデル API Key は macOS キーチェーンに保存され、通常の JSON 設定ファイルには書き込まれません。

## 🛡️ 権限とプライバシー

TermiPet は次の用途でアクセシビリティ権限を必要とする場合があります。

- 現在前面にあるターミナル、エディタ、AI アプリを識別する。
- ターミナルウィンドウのタイトルや一部のテキストを読み取り、ターミナルプレビューを生成する。
- クイックコマンドや `cd` コマンドをターミナルへ入力する。

許可しなくてもアプリは動作しますが、ターミナルプレビューと自動入力は制限されます。メニューバーの「アクセシビリティ設定を開く」からシステム設定へ移動して許可できます。より詳しいデータ説明は上の「プライバシーとデータ」を参照してください。

## 🗺️ Roadmap

- より安定したインストーラーパッケージ公開フローを提供する。
- さらに多くのデフォルトペットリソースを追加する。
- より多くの AI コーディングツールの状態認識を強化する。
- 初回案内と初回権限許可体験を改善する。

## 🤝 コントリビューションの提案

- 挙動変更にはテストの追加または更新をお願いします。
- コードやリソースを変更した後は `zsh Scripts/build-plugin.sh` を実行し、App を確認してください。

## 🙏 謝辞

TermiPet のユースケースは、**Claude Code**、**Codex**、**Google Gemini**、**GitHub Copilot**、**Ollama** という AI コーディングおよびモデルエコシステムから大きな着想と互換性の支えを受けています。これらは TermiPet の公式コントリビューターや推奨者ではありませんが、TermiPet はそれらのローカルワークフロー、状態表示、使用量読み取り、ペットチャット体験に合わせて設計されています。

v0.1 インストーラーのリソース bundle 読み込み問題を報告し、原因特定に協力してくれた **@Dinny-xu** と **@Gnonymous** に感謝します。

## 👍 プロジェクトを支援する

### ☕ コーヒーをおごる

TermiPet があなたのターミナルをもっと楽しく、もっと生産的にしてくれたなら、[愛發電](https://afdian.com/a/bleethen) でコーヒーをおごっていただけるとうれしいです。

独立開発者として、すべての支援は各種 API テスト Token、サーバーなどの固定費に直接使われ、このオープンソースツールをより長く続ける助けになります。支援しなくてもまったく問題ありません。⭐ を付けたり、macOS を使う友人に紹介したりしてくれるだけでも大きな励みです。

### 💼 商用連携 / チーム向けカスタマイズ

TermiPet をもとに商用利用を進めたい場合や、macOS AI ツールのカスタム開発について相談したい場合は、いつでもメールでご連絡ください: [bleetchenxuanling@gmail.com](mailto:bleetchenxuanling@gmail.com)。

## ⭐ Star History

<p align="center">
  <a href="https://www.star-history.com/#bleeeet/termipet&Date">
    <img alt="TermiPet Star History Chart" src="https://api.star-history.com/svg?repos=bleeeet/termipet&type=Date">
  </a>
</p>

## ライセンス

本プロジェクトは Apache License 2.0 の下で公開されています。詳しくは [LICENSE](LICENSE) を参照してください。
