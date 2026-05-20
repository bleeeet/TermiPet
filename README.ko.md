# TermiPet

<p align="center">
  <img src="Source/Sources/TermiPet/Resources/AppLogo.png" width="96" alt="TermiPet App Icon">
</p>

<p align="center">
  <b>macOS 터미널과 Claude Code 워크플로를 위한 데스크톱 펫 어시스턴트</b>
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
  <a href="#-다운로드-및-설치">다운로드 및 설치</a>
  ·
  <a href="#-주요-기능">주요 기능</a>
  ·
  <a href="#빠른-시작">빠른 시작</a>
  ·
  <a href="#개인정보와-데이터">개인정보와 데이터</a>
  ·
  <a href="#-star-history">Star History</a>
  ·
  <a href="#-사용-방식">사용 방식</a>
  ·
  <a href="#-개발">개발</a>
  ·
  <a href="#라이선스">라이선스</a>
</p>

TermiPet은 macOS 데스크톱 위에 떠 있는 펫 어시스턴트입니다. 터미널 사용자와 AI 코딩 도구 사용자를 위해 **터미널 상태 확인**, **자주 쓰는 명령 입력**, **Claude Code / Codex / GitHub Copilot 사용량 확인**, 그리고 로컬 모델 또는 온라인 API를 통한 **펫 채팅**을 제공합니다.

<p align="center">
  <img src="docs/images/termipet-hero.png" width="100%" alt="TermiPet hero">
</p>

TermiPet은 단순한 장식이 아닙니다. 평소에는 화면 가장자리에서 조용히 있다가, 필요할 때 툴바, 상태 카드, 명령 패널, 포모도로, 채팅 창을 열어 주는 가벼운 워크플로 입구입니다.

<p align="center">
  <img src="docs/images/termipet-workspace-overview.png" width="100%" alt="TermiPet workspace overview">
</p>

## ✨ 주요 기능

| 기능 | 설명 |
| --- | --- |
| 플로팅 데스크톱 펫 | 메뉴 막대 앱으로 실행되며 Dock 공간을 차지하지 않고 터미널 근처에 둘 수 있습니다. |
| 터미널 인식 | Terminal, iTerm2, Ghostty, Warp, WezTerm, Alacritty, Kitty 등을 지원합니다. |
| 터미널 미리보기 | 창 제목, 출력 요약, 현재 상태, 알림 정보를 표시합니다. |
| 명령 패널 | Claude Code 자주 쓰는 명령을 내장하고, 사용자 명령 추가, 고정, 정렬을 지원합니다. |
| 폴더 바로가기 | 프로젝트 폴더를 선택하면 해당 `cd` 명령을 대상 터미널에 입력합니다. |
| Claude Code Hook | 생각 중, 도구 호출, 권한 요청, 컨텍스트 압축, 완료 상태를 동기화합니다. |
| 펫 채팅 | 로컬 Ollama, OpenAI, Google Gemini, OpenAI-compatible 커스텀 API를 지원합니다. |
| 성격 설정 | 펫 이름, 사용자 이름, 성격 프리셋, 커스텀 Prompt, 추가 제약을 설정할 수 있습니다. |
| 포모도로 | 25분 집중과 5분 휴식을 지원하며 완료 시 펫 애니메이션이 재생됩니다. |
| AI 사용량 카드 | Claude Code, Codex, GitHub Copilot의 간단한 사용량 정보를 읽어 옵니다. |
| 내장 및 커스텀 펫 | Terminal Cat은 TermiPet의 마스코트이며, 직접 만든 펫 패키지도 가져올 수 있습니다. |
| 다국어와 스킨 | 중국어 간체, 중국어 번체, 영어, 일본어, 한국어와 여러 스킨을 지원합니다. |

## 🖼️ 인터페이스 미리보기

### 상태 카드와 권한 요청

TermiPet은 Claude Code 같은 AI 코딩 도구의 상태를 플로팅 카드로 정리합니다. 프로젝트, 실행 동작, 작업 디렉터리, Hook 출처, Allow / Deny 권한 요청을 한눈에 볼 수 있습니다.

<p align="center">
  <img src="docs/images/termipet-claude-hook.png" width="430" alt="TermiPet Claude hook status">
</p>

### 명령 패널

명령 패널은 `/compact`, `/review`, `/status`, `/diff` 같은 Claude Code 명령을 가까이에 둡니다. 현재 터미널에 바로 입력하거나, 사용자 명령을 추가하고 순서를 바꾸거나 고정할 수 있습니다.

자동 입력을 사용하려면 먼저 macOS 상단 메뉴 막대의 TermiPet 아이콘을 클릭하고 "손쉬운 사용 권한 요청" 또는 "손쉬운 사용 설정 열기"를 선택해야 합니다. 권한을 허용하지 않아도 명령 패널은 사용할 수 있지만, 명령은 클립보드에 복사되며 터미널에는 직접 붙여넣어야 합니다.

<p align="center">
  <img src="docs/images/termipet-command-panel.png" width="360" alt="TermiPet command panel">
</p>

### 펫 전환

TermiPet에는 여러 펫이 내장되어 있습니다. 기본 주인공은 `Terminal Cat`이며, 대기, 생각, 실행, 알림, 오류, 수면, 축하 같은 상태에 맞춰 움직입니다.

[Petdex 커뮤니티](https://petdex.crafter.run/zh)에서 더 많은 Petdex / Codex 호환 펫 패키지도 받을 수 있습니다.

<p align="center">
  <img src="docs/images/termipet-pet-library.png" width="860" alt="TermiPet pet selection">
</p>

### 펫 대화

플로팅 툴바의 채팅 버튼을 누르면 현재 펫과 바로 대화할 수 있습니다. 채팅 모델은 로컬 Ollama, OpenAI, Google Gemini 또는 OpenAI API 호환 서비스를 사용할 수 있습니다.

<p align="center">
  <img src="docs/images/termipet-pet-chat.png" width="430" alt="TermiPet pet chat">
</p>

### 플로팅 툴바와 사용량 카드

펫 근처로 마우스를 옮기면 명령, 폴더, 채팅, 스킨, 포모도로 입구가 열립니다. AI 사용량 카드는 Claude Code, Codex, GitHub Copilot의 가벼운 사용량 상태를 보여 줍니다.

<p align="center">
  <img src="docs/images/termipet-floating-panel.png" width="520" alt="TermiPet floating panel">
</p>

## 🔐개인정보와 데이터

TermiPet은 Mac에서 로컬로 실행되며 **자체 클라우드 중계 서버를 제공하지 않습니다**. 설정, 키, 상태 정보는 가능한 한 로컬에 보관되며, 사용자가 외부 모델 또는 공식 서비스 엔드포인트를 설정한 경우에만 해당 주소로 요청합니다.

| 데이터 | 저장 또는 사용 방식 |
| --- | --- |
| 온라인 모델 API Key | **macOS Keychain에 저장**되며 TermiPet 서버로 업로드되지 않습니다. |
| 모델 Base URL과 모델명 | Application Support 디렉터리에 로컬 저장됩니다. |
| 로컬 Ollama 채팅 | Mac의 로컬 Ollama 서비스로 전송됩니다. |
| OpenAI / Gemini / 커스텀 API 채팅 | 사용자가 설정한 제공자 엔드포인트로 직접 전송됩니다. |
| Claude Code / Codex 사용량 읽기 | 로컬 인증 정보 또는 설정을 사용해 Mac에서 공식 API로 직접 요청합니다. |
| Claude Code Hook 상태 | `127.0.0.1`의 TermiPet 로컬 서비스로만 전송됩니다. |

## 💻 요구 사항

| 항목 | 요구 사항 |
| --- | --- |
| OS | macOS 13.0 이상 |
| 빌드 도구 | Swift 6 |
| 로컬 채팅 | 선택 사항; 로컬 모델 채팅을 사용할 때만 [Ollama](https://ollama.com) 설치와 실행 필요 |
| 온라인 모델 | 선택 사항, OpenAI, Google Gemini 또는 호환 API 키 필요 |
| 시스템 권한 | 터미널 미리보기와 빠른 입력에는 macOS 손쉬운 사용 권한이 필요 |

## 📦 다운로드 및 설치

### 🚀 App 직접 다운로드

일반 사용자에게 가장 추천하는 방법입니다. Swift, Homebrew, 기타 개발 도구를 설치할 필요 없이 패키징된 macOS App을 바로 다운로드하면 됩니다.

1. [TermiPet Releases](https://github.com/bleeeet/TermiPet/releases)를 엽니다.
2. 최신 릴리스에서 `TermiPet-v0.1.2-macOS.zip`을 다운로드합니다.
3. 압축을 풀어 `TermiPet.app`을 얻습니다.
4. `TermiPet.app`을 Applications 폴더로 옮기거나 바로 더블 클릭해 실행합니다.
5. 처음 실행할 때 macOS가 확인되지 않은 개발자라고 안내하면, 시스템 설정 -> 개인정보 보호 및 보안에서 실행을 허용하세요.

실행 후 TermiPet은 macOS 메뉴 막대에 표시됩니다. 기본적으로 Dock에는 표시되지 않습니다.

터미널 미리보기, 빠른 명령 자동 입력, 폴더 `cd` 자동 입력에는 macOS 손쉬운 사용 권한이 필요합니다. 메뉴 막대의 "손쉬운 사용 권한 요청" 또는 "손쉬운 사용 설정 열기"에서 권한을 부여할 수 있습니다. 권한이 없으면 빠른 명령은 클립보드에 복사되며 직접 붙여넣어야 합니다.

### 🧪 한 줄 스크립트 설치

터미널 사용에 익숙하다면 아래 명령으로 GitHub Releases의 최신 `TermiPet.app`을 다운로드해 Applications에 설치할 수 있습니다.

```zsh
curl -fsSL https://raw.githubusercontent.com/bleeeet/TermiPet/main/install.sh | zsh
```

실행하기 전에 [`install.sh`](install.sh)를 먼저 확인할 수도 있습니다.

### 🍺 Homebrew 설치

Homebrew를 사용한다면 TermiPet tap에서 최신 버전을 설치할 수 있습니다.

```zsh
brew tap bleeeet/termipet https://github.com/bleeeet/TermiPet
brew install --cask termipet
```

다른 tap의 같은 이름 cask와 충돌을 피하려면 전체 이름을 사용할 수도 있습니다.

```zsh
brew install --cask bleeeet/termipet/termipet
```

> 유지보수 메모: Homebrew는 이 저장소의 [`Casks/termipet.rb`](Casks/termipet.rb)를 직접 읽습니다. 새 Release를 게시할 때마다 `version`과 `sha256`을 업데이트해야 합니다.

### 🧰 소스에서 빌드

프로젝트 루트에서 실행합니다.

```zsh
zsh Scripts/build-plugin.sh
```

스크립트는 자동으로 다음을 수행합니다.

1. 모든 테스트를 실행합니다.
2. Swift Package를 컴파일합니다.
3. `App/TermiPet.app`을 생성하고 갱신합니다.
4. 바이너리, 리소스, 기본 펫 패키지를 복사합니다.
5. 확장 속성을 정리합니다.
6. 로컬 자체 서명 인증서로 서명합니다. 인증서를 사용할 수 없으면 ad-hoc 서명으로 대체합니다.
7. 이전 TermiPet 프로세스를 종료하고 새 앱을 실행합니다.

일반 사용자용 자세한 안내는 [USAGE.md](USAGE.md)를 참고하세요.

## 🏁빠른 시작

### 1. 펫 표시

메뉴 막대의 TermiPet 아이콘을 클릭하고 "펫 표시"를 선택합니다.

### 2. 손쉬운 사용 권한 부여

터미널 미리보기, 빠른 명령 입력, 폴더 `cd` 입력을 사용하려면 macOS 손쉬운 사용 권한을 부여해야 합니다.

절차:

1. 메뉴 막대의 TermiPet 아이콘을 클릭합니다.
2. "손쉬운 사용 권한 요청" 또는 "손쉬운 사용 설정 열기"를 선택합니다.
3. 시스템 설정의 손쉬운 사용 페이지에서 TermiPet을 찾습니다.
4. TermiPet 권한을 켭니다.
5. 바로 적용되지 않으면 TermiPet을 다시 시작합니다.

손쉬운 사용 권한이 없어도 펫 표시와 채팅은 사용할 수 있지만, 터미널 읽기, 자동 입력, 일부 상태 인식은 제한됩니다.

### 3. 플로팅 툴바 사용

펫 위로 마우스를 옮기면 도구 버튼 줄이 나타납니다.

| 버튼 | 용도 |
| --- | --- |
| 🖥️ 터미널 | 빠른 명령 패널 열기 또는 접기 |
| 📁 폴더 | 폴더를 선택하고 터미널에 `cd` 입력 |
| 💬 채팅 | 펫 채팅 창 열기 |
| 🎨 팔레트 | 스킨 순환 전환 |
| 🍅 타이머 | 25분 포모도로 시작, 일시 정지, 재개 |
| ⏹️ 정지 | 포모도로 실행 중 타이머 정지 |
| ☕ 컵 | 5분 휴식 시작 |

펫 아래에는 대기, 실행, 이동, 기쁨, 알림, 오류, 수면, 생각, 축하 애니메이션을 수동으로 재생하는 액션 버튼도 있습니다.

## 🎮 사용 방식

### Claude Code 명령 빠르게 보내기

1. 터미널 창을 열고 포커스합니다.
2. 마우스를 펫 위로 옮깁니다.
3. 터미널 버튼을 클릭합니다.
4. 빠른 명령 패널에서 명령을 선택합니다.

TermiPet이 명령을 터미널에 자동으로 입력하게 하려면 먼저 macOS 메뉴 막대의 TermiPet 아이콘을 클릭하고 "손쉬운 사용 권한 요청" 또는 "손쉬운 사용 설정 열기"를 선택한 뒤 시스템 설정에서 TermiPet을 허용해야 합니다. 권한이 없으면 명령은 클립보드에 복사되며 직접 붙여넣어야 합니다.

내장 명령은 다음과 같습니다.

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

설정 -> 빠른 명령에서 직접 명령을 추가하고 고정 및 순서도 조정할 수 있습니다.

<p align="center">
  <img src="docs/images/termipet-command-settings.png" width="860" alt="TermiPet command settings">
</p>

### 📁 프로젝트 디렉터리 빠르게 전환

폴더 버튼을 클릭하고 프로젝트 폴더를 선택합니다. TermiPet은 해당 `cd` 명령을 최근 사용한 대상 터미널에 입력합니다.

### 👀 Claude Code 상태 보기

TermiPet은 Claude Code Hook을 통해 개발 Agent 상태를 받을 수 있습니다. 설치 후 펫 카드는 Claude Code가 생각 중인지, 도구를 호출 중인지, 권한을 기다리는지, 컨텍스트를 압축 중인지, 완료되었는지를 표시할 수 있습니다.

메뉴 막대에는 다음 항목이 있습니다.

- Claude Code Hook 설치
- Claude Code Hook 제거

설치 작업은 다음을 수정합니다.

```text
~/.claude/settings.json
~/.claude/hooks/
```

처음 설치할 때 원래 설정은 다음 위치에 백업됩니다.

```text
~/.claude/settings.json.floating-pet.bak
```

설치 후 실행 중인 `claude` 프로세스를 다시 시작해야 적용됩니다. Hook은 로컬 Claude Code 이벤트를 `127.0.0.1`에서 실행되는 TermiPet 로컬 서비스로 보내 펫 상태를 업데이트하며, 외부 서버가 필요하지 않습니다.

### 💬 펫과 채팅

채팅 버튼을 클릭하면 채팅 창이 열립니다. 채팅 모델은 두 가지 출처를 사용할 수 있습니다.

| 모델 출처 | 설명 |
| --- | --- |
| 로컬 Ollama | 로컬 실행을 원하고 외부 API 의존을 줄이고 싶은 사용자에게 적합합니다. |
| 온라인 API | OpenAI, Google Gemini, OpenAI Chat Completions 호환 커스텀 서비스를 지원합니다. |

API Key는 macOS Keychain에 저장됩니다. 일반 설정은 Application Support 디렉터리에 저장됩니다.

## ⚙️ 설정

메뉴 막대에서 "설정..."을 클릭하거나 펫을 오른쪽 클릭하고 "설정..."을 선택하면 설정 창을 열 수 있습니다.

| 페이지 | 용도 |
| --- | --- |
| ℹ️ 정보 | 버전, 개발자, 프로젝트 정보를 확인합니다. |
| 🎨 스킨 | 유리, 다크, 픽셀 등 외관을 전환합니다. |
| 🌍 언어 | 중국어 간체, 중국어 번체, 영어, 일본어, 한국어를 전환합니다. 완전 적용에는 재시작이 필요합니다. |
| ⚡ 빠른 명령 | 내장 명령과 사용자 명령을 관리하며 추가, 삭제, 고정, 드래그 정렬을 지원합니다. |
| 🐾 펫 | 펫 리소스 패키지를 가져오고 선택합니다. |
| 🎭 성격 | 펫 이름, 사용자 이름, 성격 프리셋, 커스텀 Prompt, 추가 제약을 설정합니다. |
| 🧠 모델 | 로컬 Ollama 또는 온라인 API 채팅 모델을 설정합니다. |

<p align="center">
  <img src="docs/images/termipet-personality-settings.png" width="860" alt="TermiPet personality settings">
</p>

## 🧠 펫 채팅 모델

### 로컬 모델

설정 경로: `설정 -> 모델 -> 로컬 모델`.

TermiPet은 Ollama 실행 여부를 감지합니다. 내장 모델 카탈로그는 다음을 포함합니다.

<p align="center">
  <img src="docs/images/termipet-local-models.png" width="860" alt="TermiPet local model settings">
</p>

| 모델 | 설명 | 크기 |
| --- | --- | --- |
| Qwen2.5 0.5B | 매우 가볍고 저사양에 적합하며 중국어 품질이 좋음 | ~400MB |
| Qwen2.5 1.5B | 추천, 중국어 품질이 좋고 빠름 | ~1.1GB |
| Phi-3.5 mini | 작은 크기와 높은 품질 | ~2.2GB |
| Gemma 3 1B | 균형 잡힌 경량 모델 | ~815MB |

다운로드되지 않은 모델은 직접 선택할 수 없습니다. 설정 페이지에서 Ollama를 시작하거나, 설치 페이지를 열거나, 추천 모델을 다운로드하거나, 감지 결과를 수동으로 새로고침할 수 있습니다.

### 온라인 API

설정 경로: `설정 -> 모델 -> 온라인 API`.

지원 항목:

<p align="center">
  <img src="docs/images/termipet-online-api.png" width="860" alt="TermiPet online API settings">
</p>

- OpenAI, 기본 Base URL은 `https://api.openai.com/v1`.
- Google Gemini, 기본 Base URL은 `https://generativelanguage.googleapis.com/v1beta`.
- 커스텀 API, OpenAI Chat Completions 형식과 호환되는 서비스용.

API Key는 macOS Keychain에 저장됩니다. Base URL, 모델명 등 민감하지 않은 설정은 Application Support 디렉터리에 저장됩니다. 입력 후 먼저 "모델 읽기"와 "연결 테스트"를 클릭하는 것을 권장합니다.

## 🎨 커스텀 펫

TermiPet에는 여러 펫이 내장되어 있습니다. 기본 주인공은 `Terminal Cat`으로, 터미널 옆에 있는 작은 고양이이자 이 앱의 마스코트입니다. 내장 펫에는 픽셀 스타일 고양이, Wizard Claude, Mochi 같은 캐릭터도 포함됩니다. Codex 펫 파일과 호환되는 직접 만든 펫 리소스 패키지도 가져올 수 있습니다.

### Petdex 호환성

TermiPet은 **Petdex / Codex 호환 펫 패키지**를 가져올 수 있습니다. 설정 -> 펫에서 `pet.json`과 `spritesheet.webp`가 들어 있는 펫 폴더를 선택하면, TermiPet은 이를 로컬 `ImportedPets` 디렉터리로 복사하고 데스크톱 펫으로 사용합니다.

펫 리소스 패키지는 폴더이며, 최소한 다음을 포함해야 합니다.

```text
pet.json
spritesheet.webp
```

`pet.json` 예시:

```json
{
  "id": "example-pet",
  "displayName": "Example Pet",
  "description": "A custom pixel pet.",
  "spritesheetPath": "spritesheet.webp"
}
```

spritesheet는 기본적으로 9개 행의 액션으로 해석됩니다.

| 인덱스 | 액션 |
| --- | --- |
| 0 | 대기 |
| 1 | 실행 |
| 2 | 이동 |
| 3 | 기쁨 |
| 4 | 알림 |
| 5 | 오류 |
| 6 | 수면 |
| 7 | 생각 |
| 8 | 축하 |

가져온 펫은 다음 위치로 복사됩니다.

```text
~/Library/Application Support/TermiPet/ImportedPets/
```

현재 선택 기록은 다음에 저장됩니다.

```text
~/Library/Application Support/TermiPet/selected-pet.json
```

## 🧭 설계 방향

TermiPet의 설계는 세 계층으로 나뉩니다.

### 플로팅 동반자 계층

펫은 사용자가 볼 수 있는 입구입니다. 기본적으로 가볍게 유지되어 주의를 강제로 빼앗지 않으며, 마우스를 올렸을 때만 툴바, 상태 카드, 사용량 카드, 채팅 창을 펼칩니다.

### 워크플로 보조 계층

TermiPet은 현재 터미널, 편집기, AI 대화 앱을 인식하고, 이 컨텍스트를 더 보기 쉬운 상태 힌트로 바꿉니다.

세 가지 동작을 중점적으로 지원합니다.

- 보기: 터미널, 편집기, Agent, AI 사용량 상태 확인.
- 클릭: 자주 쓰는 명령 전송, 디렉터리 전환, 타이머 시작.
- 대화: 로컬 또는 온라인 모델을 통해 펫과 대화.

### 설정 확장 계층

명령, 펫, 스킨, 언어, 채팅 모델, 성격 Prompt는 모두 설정 가능한 콘텐츠입니다. 앞으로 펫 리소스 패키지, 명령 템플릿, 모델 서비스, 더 많은 개발 워크플로를 계속 확장할 수 있습니다.

## 🗂️ 프로젝트 구조

```text
.
├── README.md
├── USAGE.md
├── LICENSE
├── Scripts/
│   ├── build-plugin.sh          # 테스트, 빌드, 서명, App 실행
│   └── open-plugin.sh           # 기존 App 열기
├── Source/
│   ├── Package.swift            # Swift Package 설정
│   ├── AppBundle/               # Info.plist 및 App 아이콘
│   ├── Sources/
│   │   ├── TermiPet/            # macOS App, SwiftUI UI, 시스템 통합
│   │   └── TermiPetCore/        # 핵심 모델, 설정, 정책, 순수 로직
│   └── Tests/TermiPetTests/     # 단위 테스트
├── Pets/                        # 기본 펫 리소스 패키지
├── icon/                        # 원본 아이콘과 소셜 프리뷰 소재
└── App/TermiPet.app             # 스크립트가 생성하는 빌드 산출물
```

## 🧑‍💻 개발

전체 빌드, 테스트, 서명, 실행:

```zsh
zsh Scripts/build-plugin.sh
```

릴리스 zip 생성:

```zsh
zsh Scripts/package-release.sh 0.1.2
```

테스트만 실행:

```zsh
cd Source
swift test
```

디버그 버전만 빌드:

```zsh
cd Source
swift build -c debug
```

소스 빌드는 로컬에 `App/TermiPet.app`을 생성하며, 개발자 테스트나 패키징에 적합합니다.

## 📝 설정 파일

TermiPet 사용자 설정은 주로 다음 위치에 저장됩니다.

```text
~/Library/Application Support/TermiPet/
```

일반 파일:

| 파일 | 설명 |
| --- | --- |
| `config.json` | 빠른 명령 설정 |
| `personality.json` | 펫 성격 설정 |
| `ollama-config.json` | 모델 출처, Base URL, 모델명 |
| `selected-pet.json` | 현재 선택한 펫 폴더 경로 |
| `ImportedPets/` | 가져온 펫 리소스 패키지 |

온라인 모델 API Key는 macOS Keychain에 저장되며 일반 JSON 설정 파일에는 기록되지 않습니다.

## 🛡️ 권한과 개인정보

TermiPet은 다음 용도로 손쉬운 사용 권한이 필요할 수 있습니다.

- 현재 전면의 터미널, 편집기 또는 AI 앱 식별.
- 터미널 창 제목과 일부 텍스트를 읽어 터미널 미리보기 생성.
- 빠른 명령 또는 `cd` 명령을 터미널에 입력.

권한을 허용하지 않아도 앱은 실행되지만, 터미널 미리보기와 자동 입력 기능은 제한됩니다. 메뉴 막대의 "손쉬운 사용 설정 열기"를 통해 시스템 설정으로 이동해 권한을 부여할 수 있습니다. 더 완전한 데이터 설명은 위의 "개인정보와 데이터"를 참고하세요.

## 🗺️ Roadmap

- 더 안정적인 설치 패키지 배포 흐름 제공.
- 더 많은 기본 펫 리소스 추가.
- 더 많은 AI 코딩 도구의 상태 인식 강화.
- 신규 사용자 안내와 최초 권한 부여 경험 개선.

## 🤝 기여 제안

- 동작 변경에는 테스트를 추가하거나 업데이트해 주세요.
- 코드나 리소스를 변경한 뒤에는 `zsh Scripts/build-plugin.sh`를 실행하고 App을 확인해 주세요.

## 🙏 감사의 말

TermiPet의 사용 시나리오는 **Claude Code**, **Codex**, **Google Gemini**, **GitHub Copilot**, **Ollama** 같은 AI 코딩 및 모델 생태계의 영감과 호환 지원에 기반합니다. 이들은 TermiPet의 공식 기여자나 보증 주체는 아니지만, TermiPet은 이 도구들의 로컬 워크플로, 상태 표시, 사용량 읽기, 펫 채팅 경험에 맞춰 설계되었습니다.

v0.1 설치 패키지의 리소스 bundle 로딩 문제를 보고하고 진단을 도와준 **@Dinny-xu**와 **@Gnonymous**에게 감사드립니다.

## 👍 프로젝트 지원

### ☕ 커피 한 잔 사주기

TermiPet이 당신의 터미널을 더 재미있고 생산적으로 만들어 주었다면, [爱发电](https://afdian.com/a/bleethen)에서 커피 한 잔으로 응원해 주세요.

독립 개발자로서 모든 후원은 각종 API 테스트 Token, 서버 같은 고정 비용을 충당하는 데 직접 사용되며, 이 오픈소스 도구가 더 오래 나아가는 데 도움이 됩니다. 후원하지 않아도 전혀 괜찮습니다. ⭐ 를 누르거나 macOS를 쓰는 친구에게 추천하는 것만으로도 큰 응원입니다.

### 💼 상업 협력 / 팀 맞춤 개발

TermiPet을 기반으로 상업적 사용을 계속 개발하고 싶거나, 다른 맞춤형 macOS AI 도구 협업이 있다면 언제든지 이메일로 이야기해 주세요: [bleetchenxuanling@gmail.com](mailto:bleetchenxuanling@gmail.com).

## ⭐ Star History

<p align="center">
  <a href="https://www.star-history.com/#bleeeet/termipet&Date">
    <img alt="TermiPet Star History Chart" src="https://api.star-history.com/svg?repos=bleeeet/termipet&type=Date">
  </a>
</p>

## 라이선스

이 프로젝트는 Apache License 2.0에 따라 배포됩니다. 자세한 내용은 [LICENSE](LICENSE)를 참고하세요.
