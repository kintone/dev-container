FROM node:22@sha256:afff6d8c97964a438d2e6a9c96509367e45d8bf93f790ad561a1eaea926303d9

ENV DEVCONTAINER=true

# initial setting for pnpm
ENV PNPM_HOME=/pnpm
ENV PATH="$PNPM_HOME:$PATH"
RUN corepack enable pnpm
ENV COREPACK_ENABLE_DOWNLOAD_PROMPT=0

# install zsh
RUN apt update && \
    apt install -y --ignore-missing \
    zsh
RUN chsh -s $(which zsh)
ENV SHELL=/bin/zsh

# setup user
ARG USER_UID=1001
ARG USER_GID=$USER_UID
ARG USERNAME=kintone
RUN groupadd --gid $USER_GID $USERNAME && \
    useradd -s /bin/zsh --uid $USER_UID --gid $USER_GID -m $USERNAME
RUN mkdir -p /home/${USERNAME}/.claude /workspace/node_modules /pnpm && \
    touch /usr/local/etc/npmrc && \
    chown -R ${USER_UID}:${USER_GID} /home/${USERNAME}/.claude /workspace/node_modules /pnpm /usr/local/etc/npmrc

# copy zshrc file
COPY .zshrc /home/${USERNAME}/
RUN chown -R ${USER_UID}:${USER_GID} /home/${USERNAME}/.zshrc

# setup command history
RUN mkdir /commandhistory && \
    touch /commandhistory/.zsh_history && \
    chown -R ${USER_UID}:${USER_GID} /commandhistory

# setup git completions
RUN git clone https://github.com/zsh-users/zsh-completions.git  "${ZDOTDIR:-/home/${USERNAME}}/.zsh-completions"

# node configs
RUN mkdir -p /usr/local/share/npm-global && \
    chown -R ${USER_UID}:${USER_GID} /usr/local/share

USER ${USERNAME}

RUN pnpm config set store-dir ${HOME}/.pnpm-store && \
    pnpm config set minimumReleaseAge 1440 && \
    npm config set ignore-scripts true --global

# install claude code
RUN pnpm add -g @anthropic-ai/claude-code

WORKDIR /workspace
