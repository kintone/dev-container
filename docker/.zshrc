export HISTFILE=/commandhistory/.zsh_history
HISTSIZE=1000
SAVEHIST=1000

export PS1="%d %% "

eval $(/home/linuxbrew/.linuxbrew/bin/brew shellenv)
eval "$(mise activate zsh)"

fpath=(${ZDOTDIR:-$HOME}/.zsh-completions/src $fpath)
autoload -U compinit
compinit -u

# pnpm
export PNPM_HOME="/home/kintone/.local/share/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac
# pnpm end
