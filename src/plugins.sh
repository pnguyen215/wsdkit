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
        java_version=$(java -version 2>&1 | awk -F '"' '/version/ {print $2}')
        echo "🍺 Java 8 installed successfully! ($java_version)"
    else
        java_version=$(java -version 2>&1 | awk -F '"' '/version/ {print $2}')
        echo "🍺 Java 8 is already installed. ($java_version)"
    fi
}

function uninstall_java8_if_needed() {
    local java8_cask="adoptopenjdk8"

    if is_homebrew_pkg_installed "$java8_cask"; then
        java_version=$(java -version 2>&1 | awk -F '"' '/version/ {print $2}')
        echo "🚀 Uninstalling Java 8 ($java_version)..."
        brew uninstall --cask "$java8_cask"
        brew untap adoptopenjdk/openjdk
        echo "🍺 Java 8 uninstalled successfully!"
    else
        echo "🍺 Java 8 is not installed. Nothing to uninstall."
    fi
}

function backup_key_secrets_if_needed() {
    sync
}

function uninstall_zsh_if_needed() {
    if is_homebrew_pkg_installed "zsh"; then
        echo "🚀 Uninstalling zsh..."
        brew uninstall "zsh"
        # Optionally, remove zsh-related configurations from your shell profile
        sed -i.bak '/# Homebrew Utility Functions/d' "$HOME/.zprofile"
        echo "🍺 zsh uninstalled successfully!"
    else
        echo "🍺 zsh is not installed. Nothing to uninstall."
    fi
}

function install_oh_my_zsh_if_needed() {
    local oh_my_zsh_dir="$HOME/.oh-my-zsh"
    if [ -d "$oh_my_zsh_dir" ]; then
        echo "🍺 Oh My Zsh is already installed. Nothing to do."
    else
        echo "🚀 Installing Oh My Zsh..."
        wsd_exe_cmd sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
        # Optionally, customize Zsh theme and plugins after installation
        # sed -i.bak 's/ZSH_THEME="robbyrussell"/ZSH_THEME="your_custom_theme"/' "$HOME/.zshrc"
        # plugins=(your_plugin1 your_plugin2)
        # sed -i.bak '/^plugins=(/a \ \ your_custom_plugin)' "$HOME/.zshrc"
        echo "🍺 Oh My Zsh installed successfully!"
    fi
}

function uninstall_oh_my_zsh_if_needed() {
    local oh_my_zsh_dir="$HOME/.oh-my-zsh"
    if [ -d "$oh_my_zsh_dir" ]; then
        echo "🚀 Uninstalling Oh My Zsh..."
        # Optionally, backup your custom Zsh configurations before uninstalling
        send_telegram_attachment ".zshrc backup conf" "$HOME/.zshrc"
        wsd_exe_cmd cp "$HOME/.zshrc" "$HOME/.zshrc_backup_before_oh_my_zsh_uninstall"
        wsd_exe_cmd sudo rm -rf "$oh_my_zsh_dir"
        # Optionally, restore your custom Zsh configurations after uninstalling
        wsd_exe_cmd cp "$HOME/.zshrc_backup_before_oh_my_zsh_uninstall" "$HOME/.zshrc"
        echo "🍺 Oh My Zsh uninstalled successfully!"
    else
        echo "🍺 Oh My Zsh is not installed. Nothing to uninstall."
    fi
}

function manual_zsh_autosuggestions_if_needed() {
    loading_spinner 2
    open_link "https://github.com/zsh-users/zsh-autosuggestions/blob/master/INSTALL.md"
}

function manual_zsh_syntax_highlighting_if_needed() {
    loading_spinner 2
    open_link "https://github.com/zsh-users/zsh-syntax-highlighting/blob/master/INSTALL.md"
}

function manual_customize_theme_oh_my_zsh_if_needed() {
    echo "🚀 Clone repository"
    wsd_exe_cmd_hook git clone https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/themes/powerlevel10k
    echo "🔧 Edit file .zshrc"
    wsd_exe_cmd_hook "ZSH_THEME="powerlevel10k/powerlevel10k""
}
