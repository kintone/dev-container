FROM debian:bookworm-slim AS install-brew

ENV DEVCONTAINER=true

# install packages for brew
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    build-essential \
    ca-certificates \
    procps \
    curl \
    file \
    git \
    sudo && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# setup sudo user
ARG SUDO_USER_UID=1001
ARG SUDO_USER_GID=$SUDO_USER_UID
ARG SUDO_USERNAME=sudo-user
RUN echo "Defaults:sudo-user !env_reset" > /etc/sudoers && \
    echo "sudo-user    ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers && \
    groupadd --gid ${SUDO_USER_GID} ${SUDO_USERNAME} && \
    useradd -s /bin/bash --uid ${SUDO_USER_UID} --gid ${SUDO_USER_GID} -G sudo -m ${SUDO_USERNAME}
USER ${SUDO_USERNAME}

# install brew
ARG NONINTERACTIVE=1
RUN /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/09792a0a1565f62eb8c90f1578a992968c85468c/install.sh)"

FROM debian:bookworm-slim AS dev-container
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    build-essential \
    ca-certificates \
    curl \
    git \
    patch \
    less \
    ssh-client \
    procps \
    zsh && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# setup dev user
ARG USER_UID=1001
ARG USER_GID=$USER_UID
ARG USERNAME=kintone
ARG HOME_DIR=/home/${USERNAME}
RUN groupadd --gid $USER_GID $USERNAME && \
    useradd -s /bin/zsh --uid $USER_UID --gid $USER_GID -m $USERNAME && \
    mkdir -p ${HOME_DIR}/.claude /workspace/node_modules /pnpm /commandhistory /usr/local/share/npm-global /usr/local/bin/mise && \
    touch /usr/local/etc/npmrc /commandhistory/.zsh_history && \
    git clone --depth 1 https://github.com/zsh-users/zsh-completions.git "${ZDOTDIR:-${HOME_DIR}}/.zsh-completions" && \
    chown -R ${USER_UID}:${USER_GID} ${HOME_DIR}/.claude /workspace/node_modules /pnpm /usr/local/etc/npmrc /commandhistory /usr/local

# copy zshrc file
COPY --chown=${USER_UID}:${USER_GID} .zshrc ${HOME_DIR}/

# mise config
COPY --chown=${USER_UID}:${USER_GID} mise /mise
ENV MISE_DATA_DIR="/mise"
ENV MISE_CONFIG_DIR="/mise"
ENV MISE_CACHE_DIR="/mise/cache"
ENV MISE_INSTALL_PATH="/usr/local/bin/mise"

USER ${USERNAME}

# setup brew
COPY --from=install-brew /home/linuxbrew/.linuxbrew /home/linuxbrew/.linuxbrew
COPY Brewfile ${HOME_DIR}/Brewfile
RUN eval $(/home/linuxbrew/.linuxbrew/bin/brew shellenv) && \
    brew bundle --file=${HOME_DIR}/Brewfile && \
    brew cleanup -s && \
    rm -rf $(brew --cache) && \
    rm -rf ${HOME_DIR}/Brewfile

ARG PNPM_HOME="${HOME_DIR}/.local/share/pnpm"
ARG PATH="$PNPM_HOME:$PATH"

# setup mise and pnpm
RUN --mount=type=secret,id=github_token,env=GITHUB_TOKEN \
    eval $(/home/linuxbrew/.linuxbrew/bin/brew shellenv) && \
    mise install --yes && \
    mise exec -- pnpm config set store-dir ${HOME_DIR}/.pnpm-store && \
    mise exec -- pnpm config set minimumReleaseAge 1440 && \
    mise exec -- npm config set ignore-scripts true --global && \
    mise exec -- pnpm add -g @anthropic-ai/claude-code && \
    mise cache clear

WORKDIR /workspace
