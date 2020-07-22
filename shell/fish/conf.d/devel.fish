# ============================== Haskell ======================================
stack --fish-completion-script stack | source

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

# ========================== Docker ===========================================
set -gx DOCKER_BUILDKIT 1
set -gx COMPOSE_DOCKER_CLI_BUILD 1
# =============================================================================

# ========================== Kubernetes =======================================
set -gx PATH $PATH $HOME/.krew/bin
# =============================================================================
