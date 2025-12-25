# 開発ガイド

このドキュメントは、このリポジトリ自体の開発者向けのガイドです。

## 開発環境のセットアップ

このリポジトリ自体を開発する際は、`.devcontainer`シンボリックリンクを作成することで、submoduleで導入した状態を再現したDev Container内で開発できます：

```bash
ln -s . .devcontainer
```

このシンボリックリンクは`.gitignore`に登録されているため、コミットされません。

## ローカル開発用のイメージビルド

デフォルトではGitHub Container Registry (`ghcr.io/kintone/dev-container:latest`) から事前ビルド済みのイメージを使用しますが、Dockerfileを修正してローカルで開発する場合は、ローカルビルドに切り替えることができます。

`docker-compose.local.yml`を作成し、以下の内容を追加します：

```yaml
services:
  app:
    build:
      context: ./docker
      dockerfile: Dockerfile
   pull_policy: build
```

設定変更後、Dev Containerを再ビルドして起動します：

## テスト

開発後は、実際のプロジェクトでサブモジュールとして導入し、正常に動作することを確認してください。
