# sync function
# Synchronize secret key files to a Telegram group chat using the send_telegram_attachment function.
#
# Usage:
#   sync
#
# Description:
#   The 'sync' function synchronizes secret key files to a Telegram group chat using the 'send_telegram_attachment' function.
#   It sends the contents of the main and backup secret key files to the specified Telegram group chat.
#
# Options:
#   None
#
# Example usage:
#   sync
#
# Instructions:
#   1. Run the 'sync' function to send the contents of the main and backup secret key files to a Telegram group chat.
#   2. The function uses the 'send_telegram_attachment' function to send files to Telegram.
#
# Notes:
#   - Ensure that the 'send_telegram_attachment' function is correctly configured with valid Telegram bot tokens and group chat ID.
#
# Dependencies:
#   - send_telegram_attachment function
function sync() {
    send_telegram_attachment "wsdkit secret_key" "$filename_secret_conf"
    send_telegram_attachment "wsdkit secret_key_bak" "$filename_secret_bak_conf"
    sync_dir_current
}

# sync_dir function
# Synchronize files from a specified folder to a Telegram group chat using the send_telegram_attachment function.
#
# Usage:
#   sync_dir <description> <folder>
#
# Parameters:
#   - <description>: A description or caption for the synchronized files.
#   - <folder>: The directory containing the files you want to synchronize.
#
# Description:
#   The 'sync_dir' function synchronizes files from a specified folder to a Telegram group chat using the
#   'send_telegram_attachment' function. It sends each file in the folder as a Telegram attachment.
#
# Options:
#   - <description>: A short description or caption for the files being synchronized.
#   - <folder>: The path to the folder containing the files to be synchronized.
#
# Example usage:
#   sync_dir "Daily Sync" ~/documents
#
# Instructions:
#   1. Run the 'sync_dir' function with a description and the path to the folder you want to synchronize.
#   2. The function sends each file in the folder as a Telegram attachment using the 'send_telegram_attachment' function.
#
# Notes:
#   - Ensure that the 'send_telegram_attachment' function is correctly configured with valid Telegram bot tokens and group chat ID.
#   - Make sure the specified folder contains files you want to synchronize.
#
# Dependencies:
#   - send_telegram_attachment function
function sync_dir() {
    if [ $# -lt 2 ]; then
        echo "Usage: sync_dir <description> <folder>"
        return 1
    fi

    local description="$1"
    local folder="$2"

    if [ ! -d "$folder" ]; then
        echo "❌ Folder '$folder' not found."
        return 1
    fi

    local files=("$folder"/*)

    if [ ${#files[@]} -eq 0 ]; then
        echo "❌ No files found in the folder '$folder'."
        return 1
    fi

    # Send each file to Telegram using send_telegram_attachment function
    send_telegram_attachment "$description" "${files[@]}"
    return 0
}
alias syncdir="sync_dir"

# sync_dir_current function
# Synchronize the contents of the current SSH configuration directory to a Telegram group chat.
#
# Usage:
#   sync_dir_current
#
# Description:
#   The 'sync_dir_current' function synchronizes the contents of the current SSH configuration directory
#   to a Telegram group chat using the 'sync_dir' function. It sends each file in the directory to the specified Telegram group chat.
#
# Options:
#   None
#
# Example usage:
#   sync_dir_current
#
# Instructions:
#   1. Run the 'sync_dir_current' function to send each file in the current SSH configuration directory to a Telegram group chat.
#   2. The function uses the 'sync_dir' function, which requires a description and the folder path as parameters.
#
# Notes:
#   - Ensure that the 'sync_dir' function is correctly configured and that the Telegram bot tokens and group chat ID are valid.
#
# Dependencies:
#   - sync_dir function
function sync_dir_current() {
    sync_dir "wsdkit ssh_forward conf" "$filename_ssh_forward_base_conf"
    sync_dir "wsdkit custom conf" "$filename_custom_base_conf"
}
alias syncdircurrent="sync_dir_current"
