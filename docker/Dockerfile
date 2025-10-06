FROM debian:bookworm-slim AS install-brew

ENV DEVCONTAINER=true

# install packages for install brew
RUN apt update && \
    apt install -y --ignore-missing \
    build-essential \
    procps \
    curl \
    file \
    git && \
    apt clean && \
    rm -rf /var/lib/apt/lists/*

# setup sudo user
ARG SUDO_USER_UID=1001
ARG SUDO_USER_GID=$SUDO_USER_UID
ARG SUDO_USERNAME=sudo-user
RUN apt-get update && apt-get install -y sudo && \
    echo "Defaults:sudo-user !env_reset" > /etc/sudoers && \
    echo "sudo-user    ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers
RUN groupadd --gid ${SUDO_USER_GID} ${SUDO_USERNAME} && \
    useradd -s /bin/bash --uid ${SUDO_USER_UID} --gid ${SUDO_USER_GID} -G sudo -m ${SUDO_USERNAME}
USER ${SUDO_USERNAME}

# install brew
ENV NONINTERACTIVE=1
RUN /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/09792a0a1565f62eb8c90f1578a992968c85468c/install.sh)"

FROM debian:bookworm-slim AS dev-container
RUN apt update && \
    apt install -y --ignore-missing \
    build-essential \
    procps \
    curl \
    file \
    git \
    zsh && \
    apt clean && \
    rm -rf /var/lib/apt/lists/*

# setup dev user
ARG USER_UID=1001
ARG USER_GID=$USER_UID
ARG USERNAME=kintone
ARG HOME_DIR=/home/${USERNAME}
RUN groupadd --gid $USER_GID $USERNAME && \
    useradd -s /bin/zsh --uid $USER_UID --gid $USER_GID -m $USERNAME
RUN mkdir -p ${HOME_DIR}/.claude /workspace/node_modules /pnpm && \
    touch /usr/local/etc/npmrc && \
    chown -R ${USER_UID}:${USER_GID} ${HOME_DIR}/.claude /workspace/node_modules /pnpm /usr/local/etc/npmrc

# copy zshrc file
COPY .zshrc ${HOME_DIR}/
RUN chown -R ${USER_UID}:${USER_GID} ${HOME_DIR}/.zshrc

# setup command history
RUN mkdir /commandhistory && \
    touch /commandhistory/.zsh_history && \
    chown -R ${USER_UID}:${USER_GID} /commandhistory

# setup git completions
RUN git clone https://github.com/zsh-users/zsh-completions.git  "${ZDOTDIR:-${HOME_DIR}}/.zsh-completions"

# node configs
RUN mkdir -p /usr/local/share/npm-global && \
    chown -R ${USER_UID}:${USER_GID} /usr/local

# mise config
COPY mise /mise
RUN mkdir -p /usr/local/bin/mise && \
    chown -R ${USER_UID}:${USER_GID} /mise /usr/local/bin/mise
ENV MISE_DATA_DIR="/mise"
ENV MISE_CONFIG_DIR="/mise"
ENV MISE_CACHE_DIR="/mise/cache"
ENV MISE_INSTALL_PATH="/usr/local/bin/mise"

USER ${USERNAME}

# setup brew
COPY --from=install-brew /home/linuxbrew/.linuxbrew /home/linuxbrew/.linuxbrew
COPY Brewfile ${HOME_DIR}/Brewfile
RUN eval $(/home/linuxbrew/.linuxbrew/bin/brew shellenv) && \
    brew bundle --file=${HOME_DIR}/Brewfile

ARG PNPM_HOME="${HOME_DIR}/.local/share/pnpm"
ARG PATH="$PNPM_HOME:$PATH"

# setup mise and pnpm
RUN --mount=type=secret,id=github_token,env=GITHUB_TOKEN \
    eval $(/home/linuxbrew/.linuxbrew/bin/brew shellenv) && \
    mise install --yes && \
    mise exec -- pnpm config set store-dir ${HOME_DIR}/.pnpm-store && \
    mise exec -- pnpm config set minimumReleaseAge 1440 && \
    mise exec -- npm config set ignore-scripts true --global && \
    mise exec -- pnpm add -g @anthropic-ai/claude-code

WORKDIR /workspace
