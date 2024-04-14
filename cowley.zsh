# Copy this file to "$HOME/.oh-my-zsh/custom/" to be usable.
# Helper method for showing python virtual env info in the prompt.

venv_prompt_info() {
  if [[ -z "$VIRTUAL_ENV" ]]
  then
    return
  fi
  echo -e "${ZSH_THEME_VENV_PROMPT_PREFIX}$(basename $VIRTUAL_ENV)${ZSH_THEME_VENV_PROMPT_SUFFIX}"
}

conda_prompt_info() {
  if [[ -z "$CONDA_DEFAULT_ENV" ]]
  then
    return
  fi
  echo -e "${ZSH_THEME_CONDA_PROMPT_PREFIX}${CONDA_DEFAULT_ENV}${ZSH_THEME_CONDA_PROMPT_SUFFIX}"
}
