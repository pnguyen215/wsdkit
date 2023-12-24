function install_homebrew_if_needed() {
    if ! is_homebrew_installed; then
        echo "🚀 Installing Homebrew..."
        install_homebrew
        echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >>"/Users/$(whoami)/.zprofile"
        eval "$(/opt/homebrew/bin/brew shellenv)"
        source "/Users/$(whoami)/.zprofile"
        echo "🍺 brew installed successfully! $(which brew)"
    else
        # echo "🍺 brew already installed successfully! $(which brew)"
    fi
}

function install_fzf_if_needed() {
    if ! is_homebrew_pkg_installed "fzf"; then
        echo "🚀 Installing fzf..."
        install_homebrew_pkg "fzf"
        echo "🍺 fzf installed successfully! $(which fzf)"
    else
        # echo "🍺 fzf already installed successfully! $(which fzf)"
    fi
}

function install_jq_if_needed() {
    if ! is_homebrew_pkg_installed "jq"; then
        echo "🚀 Installing jq..."
        install_homebrew_pkg "jq"
        echo "🍺 jq installed successfully! $(which jq)"
    else
        # echo "🍺 jq already installed successfully! $(which jq)"
    fi
}

function install_zsh_if_needed() {
    if ! is_homebrew_pkg_installed "zsh"; then
        echo "🚀 Installing zsh..."
        install_homebrew_pkg "zsh"
        echo "🍺 zsh installed successfully! $(which zsh)"
    else
        echo "🍺 zsh already installed successfully! $(which zsh)"
    fi
}

function install_git_if_needed() {
    if ! is_homebrew_pkg_installed "git"; then
        echo "🚀 Installing git..."
        install_homebrew_pkg "git"
        echo "🍺 git installed successfully! $(which git)"
        install_git_credentials_if_needed
    else
        echo "🍺 git already installed successfully! $(which git)"
    fi
}

function install_git_credentials_if_needed() {
    git_user_info_setting
}

function install_java8_if_needed() {
    local java8_cask="adoptopenjdk/openjdk/adoptopenjdk8"

    if ! is_homebrew_pkg_installed "$java8_cask"; then
        echo "🚀 Installing Java 8..."
        brew tap adoptopenjdk/openjdk
        brew install --cask "$java8_cask"
        echo "🍺 Java 8 installed successfully!"
    else
        echo "🍺 Java 8 is already installed."
    fi
}

function uninstall_java8_if_needed() {
    local java8_cask="adoptopenjdk8"

    if is_homebrew_pkg_installed "$java8_cask"; then
        echo "🚀 Uninstalling Java 8..."
        brew uninstall --cask "$java8_cask"
        brew untap adoptopenjdk/openjdk
        echo "🍺 Java 8 uninstalled successfully!"
    else
        echo "🍺 Java 8 is not installed. Nothing to uninstall."
    fi
}
