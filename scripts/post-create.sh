#!/usr/bin/zsh

# remove ssh program settings for host env
git config --global --unset gpg.ssh.program || true

# install project-specific tools from workspace mise.toml
mise install --yes

# setup pnpm configs
mise exec -- pnpm config set store-dir /home/kintone/.pnpm-store
mise exec -- pnpm config set minimumReleaseAge 1440
mise exec -- npm config set ignore-scripts true --global
mise cache clear
