# Define the global variable
function set_global_variables() {
    filename_conf="/Users/$(whoami)/wsdkit/assets/usage.json"
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

# WsdKit installations
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

# Execute wsdkit to suggest options to install packages
# wsdkit
