# Reload functions
source src/brew.sh
source src/plugins.sh

######################
#### Requirements ####
######################
install_homebrew_if_needed
install_fzf_if_needed
install_jq_if_needed

# WsdKit installations
function wsdkit() {
    local json_file="assets/usage.json"

    if [ ! -f "$json_file" ]; then
        echo "❌ Error JSON file 'usage.json' not found."
        return 1
    fi

    while true; do
        local selected_title
        local selected_key
        local selected_enabled

        selected_title=$(jq -r '. | map(select(.enabled == true)) | .[].title' "$json_file" | fzf --prompt="👉 Select (Ctrl+C to exit): " --select-1)
        if [ -n "$selected_title" ]; then
            selected_key=$(jq -r --arg title "$selected_title" '.[] | select(.title == $title) | .key' "$json_file")
            selected_enabled=$(jq -r --arg title "$selected_title" '.[] | select(.title == $title) | .enabled' "$json_file")

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
wsdkit
