function add_suffix_if_missing() {
    local path="$1"
    local suffix="$2"
    if [[ "$path" != *"$suffix" ]]; then
        path="$path/$suffix"
    fi
    echo "$path"
}
# Get the absolute path of wsdkit
wsdkit_bash_source="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
wsdkit_suffix="wsdkit"
wsdkit_wrk=$(add_suffix_if_missing "$wsdkit_bash_source" "$wsdkit_suffix")
echo "🍺 DEBUG: wsdkit working on $wsdkit_wrk"

# Reload functions
# source "$wsdkit_wrk/src/brew.sh"
# source "$wsdkit_wrk/src/plugins.sh"
# source "$wsdkit_wrk/src/git.sh"
source "$(dirname "$0")/brew.sh"
source "$(dirname "$0")/plugins.sh"
source "$(dirname "$0")/git.sh"

# WsdKit installations
function wsdkit() {
    ######################
    #### Requirements ####
    ######################
    install_homebrew_if_needed
    install_fzf_if_needed
    install_jq_if_needed
    local json_file="$wsdkit_wrk/assets/usage.json"

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
# wsdkit
