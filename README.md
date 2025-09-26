# Generic Dev Container Configuration

**内部使用専用（Internal Use Only）**

汎用開発環境用のDev Container設定です。社内の各プロジェクトでサブモジュールとして追加して使用します。

## 前提条件

- Docker Desktop
  - 他のdocker engineでも可
- 1Password (SSH Agent設定済み)
- Dev Container対応エディタ（VS Code/IntelliJ）またはDev Container CLI

### 1Password SSH Agentの設定

1Passwordの設定実施後はDocker Desktopを一度完全終了させること(設定を反映させるため)

1. **1PasswordでSSH Agentを有効化**
   - 1Password の設定を開く
   - 「開発者」セクションで「SSH エージェントを使用」をオンにする

2. **Docker Desktopで設定**
   - Settings > Resources > Advanced
   - 「Enable SSH agent forwarding」をオンにする

3. **SSH_AUTH_SOCKの環境変数を設定**
   - [1Password SSH Agent公式ドキュメント](https://developer.1password.com/docs/ssh/agent/compatibility/#ssh-auth-sock)を参考に`SSH_AUTH_SOCK`の設定を行う
   - LaunchAgentsの設定まで実施する


## 含まれる機能

- **Node.js 22** ベースの開発環境
- **pnpm** パッケージマネージャー
- **Claude Code** AI開発アシスタント統合
- **SSH Agent転送** (1Password対応)
- **データ永続化** (node_modules, pnpmストア, コマンド履歴)
- **zsh** シェル環境

## 使用方法

### 1. サブモジュールとして追加

プロジェクトのルートディレクトリで以下のコマンドを実行:

```bash
# .devcontainerディレクトリにサブモジュールとして追加
git submodule add [このリポジトリのURL] .devcontainer

# サブモジュールを初期化
git submodule update --init
```

### 2. プロジェクト固有の設定（オプション）

プロジェクト固有の設定が必要な場合は、`.devcontainer.override/docker-compose.override.yml`を作成してカスタマイズできます

```yaml
# .devcontainer.override/docker-compose.override.yml（カスタマイズ例）
services:
  app:
    environment:
      - YOUR_ENV_VAR=value
    ports:
      - "3000:3000"
```

`initialize.sh`により、起動時に自動的に以下の処理が行われます：
- `.devcontainer.override/docker-compose.override.yml`が存在する場合：そのファイルを`.devcontainer/`にコピー
- 存在しない場合：空の`docker-compose.override.yml`を自動生成

### 3. Dev Containerを開く

#### VS Codeの場合
1. プロジェクトをVS Codeで開く
2. コマンドパレット（`Cmd+Shift+P` / `Ctrl+Shift+P`）を開く
3. 「Dev Containers: Reopen in Container」を選択

#### IntelliJ IDEAの場合
1. プロジェクトをIntelliJで開く
2. Dev Containersプラグインから「Open in Dev Container」を選択

#### CLIの場合
```bash
devcontainer up --workspace-folder .
devcontainer exec --workspace-folder . zsh
```

### 4. サブモジュールの更新
dev-containerの更新を反映するには以下のコマンドを実行します
```
git submodule update --remote .devcontainer
git add .devcontainer
git commit -m "Update submodule"
```

## 設定内容

### コンテナ環境

- **ベースイメージ**: Node.js 22 (Alpine)
- **デフォルトユーザー**: kintone (UID: 1001)
- **作業ディレクトリ**: /workspace
- **シェル**: zsh (git補完機能付き)

### 永続化ボリューム

| ボリューム名 | マウント先 | 用途 |
|------------|-----------|------|
| devcontainer-${PROJECT_ROOT_DIR_NAME}-node_modules | /workspace/node_modules | npmパッケージ |
| devcontainer-${PROJECT_ROOT_DIR_NAME}-pnpm_store | /home/kintone/.pnpm-store | pnpmキャッシュ |
| devcontainer-${PROJECT_ROOT_DIR_NAME}-commandhistory | /commandhistory | コマンド履歴 |
| claude-code-config | /home/kintone/.claude | Claude設定 |

### 含まれるツール

- **pnpm**: 高速なパッケージマネージャー
- **Claude Code**: AIペアプログラミングツール
- **Git**: バージョン管理（zsh補完付き）
