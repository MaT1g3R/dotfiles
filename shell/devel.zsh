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
    export PATH="$HOME/Library/Python/3.6/bin:$PATH"
fi
# =============================================================================

# ============================== Rust =========================================
export PATH="$HOME/.cargo/bin:$PATH"
# =============================================================================

# ============================== Ruby =========================================
if [ `uname` = 'Linux' ]; then
    export PATH="${HOME}/.gem/ruby/2.5.0/bin:$PATH"
fi
# =============================================================================
