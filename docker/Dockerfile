FROM debian:bookworm-slim AS install-brew

ENV DEVCONTAINER=true
ENV LANG=C.UTF-8

# install packages for brew
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    build-essential \
    ca-certificates \
    procps \
    curl \
    file \
    git && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# create linuxbrew user for Homebrew installation
RUN useradd -m -s /bin/bash linuxbrew && \
    mkdir -p /home/linuxbrew/.linuxbrew && \
    chown -R linuxbrew:linuxbrew /home/linuxbrew

# install brew as linuxbrew user
USER linuxbrew
ARG NONINTERACTIVE=1
RUN /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/09792a0a1565f62eb8c90f1578a992968c85468c/install.sh)"

FROM debian:bookworm-slim AS dev-container

ENV LANG=C.UTF-8

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
    gnupg \
    vim \
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
    mkdir -p ${HOME_DIR}/.claude /workspace/node_modules /pnpm /commandhistory /usr/local/share/npm-global /usr/local/bin/mise ${HOME_DIR}/.config && \
    touch /usr/local/etc/npmrc /commandhistory/.zsh_history && \
    git clone --depth 1 https://github.com/zsh-users/zsh-completions.git "${ZDOTDIR:-${HOME_DIR}}/.zsh-completions" && \
    chown -R ${USER_UID}:${USER_GID} ${HOME_DIR}/.claude /workspace/node_modules /pnpm /usr/local/etc/npmrc /commandhistory /usr/local ${HOME_DIR}/.config

# copy zshrc file
COPY --chown=${USER_UID}:${USER_GID} .zshrc ${HOME_DIR}/

# mise config
COPY --chown=${USER_UID}:${USER_GID} mise /mise
ENV MISE_DATA_DIR="/mise"
ENV MISE_CONFIG_DIR="/mise"
ENV MISE_CACHE_DIR="/mise/cache"
ENV MISE_INSTALL_PATH="/usr/local/bin/mise"

RUN mkdir -p /home/linuxbrew && \
    chown -R ${USER_UID}:${USER_GID} /home/linuxbrew

USER ${USERNAME}

# setup brew
COPY --from=install-brew --chown=${USER_UID}:${USER_GID} /home/linuxbrew/.linuxbrew /home/linuxbrew/.linuxbrew

# install mise
RUN eval $(/home/linuxbrew/.linuxbrew/bin/brew shellenv) && \
    brew install mise

# install claude-code
RUN eval $(/home/linuxbrew/.linuxbrew/bin/brew shellenv) && \
    brew install --cask claude-code

# cleanup brew
RUN eval $(/home/linuxbrew/.linuxbrew/bin/brew shellenv) && \
    brew cleanup -s && \
    rm -rf $(brew --cache)

# install baseline tools from /mise/config.toml
RUN --mount=type=secret,id=github_token,env=GITHUB_TOKEN \
    eval $(/home/linuxbrew/.linuxbrew/bin/brew shellenv) && \
    mise install --yes

ARG PNPM_HOME="${HOME_DIR}/.local/share/pnpm"
ARG PATH="$PNPM_HOME:$PATH"

WORKDIR /workspace

SHELL ["/bin/zsh", "-c"]

CMD ["/bin/zsh"]
