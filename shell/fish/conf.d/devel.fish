# ============================== Haskell ======================================
# add Cabal's bin directory to the executable search PATH if it exists
if [ -d ~/.cabal/bin ]
    set -x -g PATH ~/.cabal/bin $PATH
end

# add Stack's bin directory to the executable search PATH if it exists
if [ -d ~/.local/bin ]
    set -x -g PATH ~/.local/bin $PATH
end
# =============================================================================

# ============================== Python =======================================
if [ (uname) != 'Linux' ]
    set -x -g PATH ~/Library/Python/3.7/bin $PATH
end

set -x PYENV_ROOT ~/.pyenv
set -x -g PATH $PYENV_ROOT/bin $PATH
set -x PYENV_VIRTUALENV_DISABLE_PROMPT 1
status --is-interactive; and pyenv init - | source
status --is-interactive; and pyenv virtualenv-init - | source


function pyenv-install
    set PYTHON_CONFIGURE_OPTS "--enable-shared"
    pyenv install $argv
end

# =============================================================================

# ============================== Rust =========================================
set -x -g PATH ~/.cargo/bin $PATH
# =============================================================================

# ============================== Ruby =========================================
if [ (uname) = 'Linux' ]
    set -x -g PATH ~/.gem/ruby/2.5.0/bin $PATH
end
# =============================================================================

# =============================== JS ==========================================
set -x -g PATH ~/.npm-global/bin $PATH
set -x CHROME_BIN (which chromium)
# =============================================================================
