# Copy this file to the "$HOME/.oh-my-zsh/custom/themes/" directory.
# This theme includes a python virtual env indicator in the prompt.

VIRTUAL_ENV_DISABLE_PROMPT=true

PROMPT="%(?:%{$fg_bold[green]%}➜ :%{$fg_bold[red]%}➜ ) %{$fg[cyan]%}%c%{$reset_color%} "
PROMPT+='$(git_prompt_info)'
PROMPT+='$(venv_prompt_info)'

ZSH_THEME_GIT_PROMPT_PREFIX="%{$fg_bold[yellow]%}("
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%} "
ZSH_THEME_GIT_PROMPT_DIRTY="%{$fg_bold[yellow]%}) %{$fg[yellow]%}✗"
ZSH_THEME_GIT_PROMPT_CLEAN="%{$fg_bold[yellow]%})"

ZSH_THEME_VENV_PROMPT_PREFIX="%{$fg_bold[blue]%}("
ZSH_THEME_VENV_PROMPT_SUFFIX=")%{$reset_color%} "
