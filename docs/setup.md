# セットアップガイド

このドキュメントでは、dev-containerの詳細なセットアップ方法とカスタマイズ方法を説明します。

## 前提条件

### Docker Desktop

- Docker Desktop
  - 他のdocker engineでも可

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

### Dev Container対応エディタ

- VS Code
- IntelliJ IDEA
- Dev Container CLI

## カスタマイズ設定

### プロジェクト固有設定（リポジトリで管理）

プロジェクト全体で共有する設定は、`.devcontainer.override/docker-compose.override.yml`を作成してカスタマイズできます。

```yaml
# .devcontainer.override/docker-compose.override.yml（カスタマイズ例）
services:
  app:
    environment:
      - YOUR_ENV_VAR=value
    ports:
      - "3000:3000"
```

このファイルはリポジトリにコミットして管理します。

### 個人用設定（コミット対象外）

個人的なカスタマイズは、`.devcontainer/docker-compose.local.yml`を作成します。このファイルは`.gitignore`に登録されており、コミット対象外です。

個人用のvolumeマウント、.zshrcの上書き、GITHUB_TOKENの設定などに使用します。

```yaml
# .devcontainer/docker-compose.local.yml（カスタマイズ例）
services:
  app:
    build:
      secrets:
        - github_token
    volumes:
      - /path/to/your/local/dir:/mount/point

secrets:
  github_token:
    environment: GITHUB_TOKEN
```

#### GITHUB_TOKENについて

miseは多くのツールのインストール時にGitHub APIを使用します。レート制限によりエラーが発生した場合は、スコープ不要のトークンを設定してください。

- [GitHubトークン生成](https://github.com/settings/tokens/new?description=MISE_GITHUB_TOKEN)
- トークンにスコープは不要です（public read only）
- 環境変数`GITHUB_TOKEN`に設定

テンプレートファイル（`docker-compose.local.yml.template`）を参考にしてください。

### 起動時の処理

`initialize.sh`により、起動時に自動的に以下の処理が行われます：
- `.devcontainer.override/docker-compose.override.yml`が存在する場合：そのファイルを`.devcontainer/`にコピー
- 存在しない場合：空の`docker-compose.override.yml`を自動生成
- `.devcontainer/docker-compose.local.yml`が存在しない場合：空のファイルを自動生成

## コンテナ環境の詳細

### コンテナ環境

- **ベースイメージ**: Debian bookworm-slim
- **デフォルトユーザー**: kintone (UID: 1001)
- **作業ディレクトリ**: /workspace
- **シェル**: zsh (git補完機能付き)
- **ツールバージョン管理**: mise (Node.js 24.9.0, pnpm 10.17.1)

### 永続化ボリューム

| ボリューム名 | マウント先 | 用途 |
|------------|-----------|------|
| devcontainer-${PROJECT_ROOT_DIR_NAME}-node_modules | /workspace/node_modules | npmパッケージ |
| devcontainer-${PROJECT_ROOT_DIR_NAME}-pnpm_store | /home/kintone/.pnpm-store | pnpmキャッシュ |
| devcontainer-${PROJECT_ROOT_DIR_NAME}-commandhistory | /commandhistory | コマンド履歴 |
| claude-code-config | /home/kintone/.claude | Claude設定 |

### 含まれるツール

- **Homebrew**: パッケージマネージャー
- **mise**: ツールバージョン管理（Node.js, pnpm）
- **pnpm**: 高速なパッケージマネージャー
- **Claude Code**: AIペアプログラミングツール
- **Git**: バージョン管理（zsh補完付き）

## サブモジュールの更新

dev-containerの更新を反映するには以下のコマンドを実行します

```bash
git submodule update --remote .devcontainer
git add .devcontainer
git commit -m "Update submodule"
```
