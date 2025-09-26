export HISTFILE=/commandhistory/.zsh_history
HISTSIZE=1000
SAVEHIST=1000

fpath=(${ZDOTDIR:-$HOME}/.zsh-completions/src $fpath)
autoload -U compinit
compinit -u
