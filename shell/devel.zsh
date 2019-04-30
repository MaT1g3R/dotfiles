# ============================== Haskell ======================================
# add Cabal's bin directory to the executable search PATH if it exists
if [ -d "$HOME/.cabal/bin" ] ; then
    export PATH="$HOME/.cabal/bin:$PATH"
fi

# add Stack's bin directory to the executable search PATH if it exists
if [ -d "$HOME/.local/bin" ] ; then
    export PATH="$HOME/.local/bin:$PATH"
fi 
# =============================================================================

# ============================== Python =======================================
export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"
export PYENV_VIRTUALENV_DISABLE_PROMPT=1
if command -v pyenv 1>/dev/null 2>&1; then
  eval "$(pyenv init -)"
fi
eval "$(pyenv virtualenv-init -)"

if [ `uname` != 'Linux' ]; then
    export PATH="$HOME/Library/Python/3.7/bin:$PATH"
fi

pyenv-install() {
    PYTHON_CONFIGURE_OPTS="--enable-shared" pyenv install $@
}

# =============================================================================

# ============================== Rust =========================================
export PATH="$HOME/.cargo/bin:$PATH"
# =============================================================================

# ============================== Ruby =========================================
if [ `uname` = 'Linux' ]; then
    export PATH="${HOME}/.gem/ruby/2.5.0/bin:$PATH"
fi
# =============================================================================

# =============================== JS ==========================================
export PATH="$HOME/.npm-global/bin:$PATH"
export CHROME_BIN=$(which chromium)
# =============================================================================

# heroku autocomplete setup
HEROKU_AC_ZSH_SETUP_PATH=/Users/umi/Library/Caches/heroku/autocomplete/zsh_setup && test -f $HEROKU_AC_ZSH_SETUP_PATH && source $HEROKU_AC_ZSH_SETUP_PATH;
