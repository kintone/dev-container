# Generic Dev Container Configuration

> [!WARNING]
> このリポジトリはサイボウズ社内のOSSリポジトリ開発作業での利用を想定したものです。

TypeScript開発環境用の汎用Dev Container設定です。社内の各プロジェクトでサブモジュールとして追加して使用します。

## 含まれる機能

- **Homebrew** パッケージマネージャー
- **mise** ツールバージョン管理
- **Node.js** / **pnpm** (mise管理)
- **Claude Code** AI開発アシスタント
- **SSH Agent転送** (1Password対応)
- **データ永続化** (node_modules, pnpm store, コマンド履歴)
- **zsh** シェル環境

## 前提条件

- Docker Desktop
- 1Password (SSH Agent設定済み)
- Dev Container対応エディタ（VS Code/IntelliJ）またはDev Container CLI

詳細なセットアップ手順は [セットアップガイド](docs/setup.md) を参照してください。

## クイックスタート

### 1. サブモジュールとして追加

```bash
git submodule add [このリポジトリのURL] .devcontainer
git submodule update --init
```

### 2. Dev Containerを開く

- **VS Code**: コマンドパレット → 「Dev Containers: Reopen in Container」
- **IntelliJ**: Dev Containersプラグイン → 「Open in Dev Container」
- **CLI**: `devcontainer up --workspace-folder .`

### 3. カスタマイズ（オプション）

プロジェクト固有の設定や個人用設定が必要な場合は、[セットアップガイド](docs/setup.md)のカスタマイズセクションを参照してください。

## ドキュメント

- [セットアップガイド](docs/setup.md) - 詳細なセットアップ手順とカスタマイズ方法
