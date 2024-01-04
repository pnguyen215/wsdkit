# Define the global variable
function set_global_variables() {
    # Usage configs
    filename_conf="/Users/$(whoami)/wsdkit/assets/usage.json"

    # Key configs
    filename_secret_conf="/Users/$(whoami)/wsdkit.conf/assets/secrets.txt"
    filename_secret_bak_conf="/Users/$(whoami)/wsdkit.conf/assets/secrets.txt.bak"

    # Env Configs
    filename_ssh_kit_conf="/Users/$(whoami)/.ssh"
    filename_asset_base_conf="/Users/$(whoami)/wsdkit.conf/assets"
    filename_custom_base_conf="/Users/$(whoami)/wsdkit.conf/custom"
    filename_ssh_forward_base_conf="/Users/$(whoami)/wsdkit.conf/sfc"
    filename_telegram_base_conf="/Users/$(whoami)/wsdkit.conf/telegram"

    # Github repositories
    github_golang_template_repository="https://github.com/sivaosorg/gocell/archive/master.zip"

    # local -g vars
    # filename_secret_conf="./assets/secrets.txt"
    # filename_conf="./assets/usage.json"
}

# Set the global variables
set_global_variables

# Firstly, load all function helpers
source "$(dirname "$0")/h.sh"

# Get the absolute path of wsdkit
wsdkit_bash_source="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
wsdkit_suffix="wsdkit"
wsdkit_wrk=$(add_suffix_if_needed "$wsdkit_bash_source" "$wsdkit_suffix")
echo "🍺 DEBUG: wsdkit working on $wsdkit_wrk"

# Reload functions
source "$(dirname "$0")/deps.sh"

# wsdkit function
# Main function for managing and executing wsdkit commands.
#
# Usage:
#   wsdkit
#
# Description:
#   The 'wsdkit' function serves as the main entry point for managing and executing wsdkit commands.
#   It interacts with a configuration file ('usage.json') to display a menu of available options.
#   Users can select an option, and the corresponding command or action will be executed.
#
# Dependencies:
#   - jq: Required for parsing JSON configuration files.
#   - fzf: Required for providing an interactive selection menu.
function wsdkit() {
    ######################
    #### Requirements ####
    ######################
    install_homebrew_if_needed
    install_fzf_if_needed
    install_jq_if_needed
    local json_filename_conf=$filename_conf

    if [ ! -f "$json_filename_conf" ]; then
        echo "❌ Error JSON file 'usage.json' not found: $filename_conf"
        return 1
    fi

    while true; do
        local selected_title
        local selected_key
        local selected_enabled

        selected_title=$(jq -r '. | map(select(.enabled == true)) | .[].title' "$json_filename_conf" | fzf --prompt="👉 Select (Ctrl+C to exit): " --select-1)
        if [ -n "$selected_title" ]; then
            selected_key=$(jq -r --arg title "$selected_title" '.[] | select(.title == $title) | .key' "$json_filename_conf")
            selected_enabled=$(jq -r --arg title "$selected_title" '.[] | select(.title == $title) | .enabled' "$json_filename_conf")

            if [ "$selected_enabled" = "true" ]; then
                echo "✅ $selected_title"

                case "$selected_key" in
                "wsd_install_brew")
                    install_homebrew_if_needed
                    ;;
                "wsd_install_git")
                    install_git_if_needed
                    ;;
                "wsd_install_zsh")
                    install_zsh_if_needed
                    ;;
                "wsd_install_git_credentials")
                    install_git_credentials_if_needed
                    ;;
                "wsd_uninstall_brew")
                    wsd_exe_cmd_hook uninstall_homebrew
                    ;;
                "wsd_list_git_configs")
                    git_config_global_setting
                    ;;
                "wsd_add_secret")
                    add_secret
                    ;;
                "wsd_get_secret")
                    get_secret_noop
                    ;;
                "wsd_remove_secret")
                    delete_secret_noop
                    ;;
                "wsd_get_all_secret")
                    get_all_secret
                    ;;
                "wsd_install_jdk8")
                    install_java8_if_needed
                    ;;
                "wsd_uninstall_jdk8")
                    uninstall_java8_if_needed
                    ;;
                "wsd_bak_secret")
                    backup_key_secrets_if_needed
                    ;;
                "wsd_uninstall_zsh")
                    uninstall_zsh_if_needed
                    ;;
                "wsd_install_oh_my_zsh")
                    install_oh_my_zsh_if_needed
                    ;;
                "wsd_uninstall_oh_my_zsh")
                    uninstall_oh_my_zsh_if_needed
                    ;;
                "wsd_install_zsh_autosuggestions")
                    manual_zsh_autosuggestions_if_needed
                    ;;
                "wsd_install_zsh_syntax_highlighting")
                    manual_zsh_syntax_highlighting_if_needed
                    ;;
                "wsd_customize_theme_oh_my_zsh")
                    manual_customize_theme_oh_my_zsh_if_needed
                    ;;
                *)
                    echo "❓ Unsupported function."
                    ;;
                esac
            else
                echo "❌ The selected option is not enabled. Please choose another option."
            fi
        else
            echo "❌ Unsupported function. Exiting..."
            break
        fi
    done
}

# wsdkit_upgrade function
# Upgrade wsdkit to the latest version.
#
# Usage:
#   wsdkit_upgrade
#
# Description:
#   The 'wsdkit_upgrade' function upgrades wsdkit to the latest version by removing the existing installation
#   and installing the latest version from the official repository.
#
# Example usage:
#   wsdkit_upgrade
#
# Instructions:
#   1. Use 'wsdkit_upgrade' to upgrade wsdkit to the latest version.
#   2. After running the command, restart your terminal or run 'source ~/.zshrc' to apply changes.
#
# Notes:
#   - Ensure that 'curl' is installed on your system for the upgrade process.
#   - This function removes the existing wsdkit installation and installs the latest version.
#   - It is recommended to back up any important configuration files before upgrading.
#
# Dependencies:
#   - curl: Required for downloading the latest version of wsdkit.
function wsdkit_upgrade() {
    echo "🚀 Upgrading wsdkit..."
    wsd_exe_cmd sudo rm -rf wsdkit
    wsd_exe_cmd /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/pnguyen215/wsdkit/master/install.sh)"
    echo "🍺 wsdkit has been successfully upgraded. Please restart your terminal or run 'source ~/.zshrc' to apply changes."
}
alias wsdkitupgrade="wsdkit_upgrade"
