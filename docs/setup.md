# セットアップガイド

このドキュメントでは、dev-containerの詳細なセットアップ方法とカスタマイズ方法を説明します。

## 前提条件

- Docker Desktop（または他のDocker Engine）
- Dev Container対応エディタ（VS Code / IntelliJ IDEA / Dev Container CLI）
- 1Password（SSH Agent設定済み）

### 1Password SSH Agentの設定

1. **1PasswordでSSH Agentを有効化**
   - 1Password の設定を開く
   - 「開発者」セクションで「SSH エージェントを使用」をオンにする

2. **SSH_AUTH_SOCKの環境変数を設定**
   - [1Password SSH Agent公式ドキュメント](https://developer.1password.com/docs/ssh/agent/compatibility/#ssh-auth-sock)を参考に`SSH_AUTH_SOCK`の設定を行う
   - LaunchAgentsの設定まで実施する
   - **LaunchAgents設定後はDocker Desktopを一度完全終了させること**（設定を反映させるため）

**注:** Docker Desktop 側での設定は不要です。`docker-compose.yml`で`/run/host-services/ssh-auth.sock`をマウントすることで自動的に SSH agent forwarding が有効になります。

**参考:**
- [1Password SSH Agent](https://developer.1password.com/docs/ssh/agent/)
- [Docker Desktop SSH agent forwarding](https://docs.docker.com/desktop/features/networking/#ssh-agent-forwarding)

## カスタマイズ設定

このDev Containerは3層のカスタマイズ構造を採用しています：

1. **共通設定** (`docker-compose.yml`): 全プロジェクト共通の基本設定
2. **プロジェクト設定** (`.devcontainer.override/docker-compose.override.yml`): プロジェクト固有の設定（リポジトリで管理）
3. **ローカル設定** (`.devcontainer/docker-compose.local.yml`): 個人用設定（コミット対象外）

各設定は順に読み込まれ、後の設定が前の設定を上書きします。

### プロジェクト設定（リポジトリで管理）

プロジェクト全体で共有する設定は、`.devcontainer.override/docker-compose.override.yml`を作成してカスタマイズします。

カスタマイズ例：
- `node_modules`のボリュームマウント（`docker-compose.override.yml.template`を参照）
- 環境変数の設定
- ポートのフォワーディング

このファイルはリポジトリにコミットして管理します。

### ローカル設定（コミット対象外）

個人的なカスタマイズは、`.devcontainer/docker-compose.local.yml`を作成してカスタマイズします。

カスタマイズ例：
- 個人用のディレクトリマウント
- GITHUB_TOKEN の設定（`docker-compose.local.yml.template`を参照）

**GITHUB_TOKENについて:** miseのインストール時にGitHub APIレート制限エラーが発生する場合は、[スコープ不要のトークン](https://github.com/settings/tokens/new?description=MISE_GITHUB_TOKEN)を環境変数`GITHUB_TOKEN`に設定してください。

## コンテナ環境

**基本構成:**
- Debian bookworm-slim
- Node.js 24.9.0 / pnpm 10.17.1（mise管理）
- zsh
- Homebrew
- Claude Code

**永続化ボリューム:**
- `devcontainer-${PROJECT_ROOT_DIR_NAME}-pnpm_store`: pnpmキャッシュ
- `devcontainer-${PROJECT_ROOT_DIR_NAME}-commandhistory`: コマンド履歴
- `claude-code-config`: Claude設定

**注:** プロジェクトによっては`node_modules`ボリュームを追加することを推奨します（[プロジェクト設定](#プロジェクト設定リポジトリで管理)参照）。

## サブモジュールの更新

dev-containerの更新を反映するには以下のコマンドを実行します

```bash
git submodule update --remote .devcontainer
git add .devcontainer
git commit -m "Update submodule"
```
