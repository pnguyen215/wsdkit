# send_telegram_message_setting function
# Sends a text message to a Telegram bot using the Telegram Bot API.
# Parameters:
#   $1: Telegram bot token
#   $2: Chat ID where the message will be sent
#   $3: Message to be sent
# Returns:
#   0 on success, 1 on error
function send_telegram_message_setting() {
    if [ $# -lt 3 ]; then
        echo "Usage: send_telegram_message_setting <token> <chat_id> <message>"
        return 1
    fi

    local token="$1"
    local chatId="$2"
    local message="$3"

    # Use curl to send a POST request to the Telegram Bot API
    curl -s -X POST "https://api.telegram.org/bot$token/sendMessage" -d "chat_id=$chatId&text=$message&parse_mode=markdown" >/dev/null
}

# send_telegram_files_setting function
# Sends documents (files) to a Telegram bot using the Telegram Bot API.
# Parameters:
#   $1: Telegram bot token
#   $2: Chat ID where the files will be sent
#   $3 and onwards: List of filenames (can include multiple files)
# Returns:
#   0 on success, 1 on error
function send_telegram_files_setting() {
    if [ $# -lt 1 ]; then
        echo "Usage: send_telegram_files_setting <token> <chat_id> <filename_1> [filename_2] [filename_3] ..."
        return 1
    fi

    local token="$1"
    local chatId="$2"

    # Loop through each filename provided as an argument
    for filename in "${@:3}"; do
        # Check if the file exists
        if [ -f "$filename" ]; then
            # Use curl to send a POST request to the Telegram Bot API for each file
            curl -s -F chat_id="$chatId" -F document=@"$filename" "https://api.telegram.org/bot$token/sendDocument" >/dev/null
            echo "File '$filename' sent."
        else
            echo "File '$filename' not found. Skipping."
        fi
    done
}

# send_telegram_git_activity function
function send_telegram_git_activity() {
    if [ $# -lt 1 ]; then
        echo "Usage: send_telegram_git_activity <message>"
        return 1
    fi
    local message="$1"
    # reloading file conf
    source "$filename_secret_conf"
    # local variables
    local token="$JARVIS_TELEGRAM_BOT_TOKEN_1"
    local chatId="$JARVIS_TELEGRAM_BOT_GROUP_CHAT_ID_1"

    # setting token
    if [[ -z "$token" ]]; then
        echo "❌ Key 'JARVIS_TELEGRAM_BOT_TOKEN_1' not found or empty."
        echo "🚀 Setting key 'JARVIS_TELEGRAM_BOT_TOKEN_1'"
        add_secret
        source "$filename_secret_conf"
        token="$JARVIS_TELEGRAM_BOT_TOKEN_1"
    fi

    # setting chatId
    if [[ -z "$chatId" ]]; then
        echo "❌ Key 'JARVIS_TELEGRAM_BOT_GROUP_CHAT_ID_1' not found or empty."
        echo "🚀 Setting key 'JARVIS_TELEGRAM_BOT_GROUP_CHAT_ID_1'"
        add_secret
        source "$filename_secret_conf"
        chatId="$JARVIS_TELEGRAM_BOT_GROUP_CHAT_ID_1"
    fi

    send_telegram_message_setting "$token" "$chatId" "$message"
}
alias sendtelegramgitactivity="send_telegram_git_activity"

# send_telegram_guardian function
# Sends a predefined message and files to a Telegram bot using the Telegram Bot API.
# Parameters:
#   $1 and onwards: List of filenames (can include multiple files)
# Returns:
#   0 on success, 1 on error
function send_telegram_guardian() {
    if [ $# -lt 1 ]; then
        echo "Usage: send_telegram_guardian <filename_1> [filename_2] [filename_3] ..."
        return 1
    fi

    local files=("${@}")

    # reloading file conf
    source "$filename_secret_conf"
    # local variables
    local token="$JARVIS_TELEGRAM_BOT_TOKEN_1"
    local chatId="$JARVIS_TELEGRAM_BOT_GROUP_CHAT_ID_2"

    # setting token
    if [[ -z "$token" ]]; then
        echo "❌ Key 'JARVIS_TELEGRAM_BOT_TOKEN_1' not found or empty."
        echo "🚀 Setting key 'JARVIS_TELEGRAM_BOT_TOKEN_1'"
        add_secret
        source "$filename_secret_conf"
        token="$JARVIS_TELEGRAM_BOT_TOKEN_1"
    fi

    # setting chatId
    if [[ -z "$chatId" ]]; then
        echo "❌ Key 'JARVIS_TELEGRAM_BOT_GROUP_CHAT_ID_2' not found or empty."
        echo "🚀 Setting key 'JARVIS_TELEGRAM_BOT_GROUP_CHAT_ID_2'"
        add_secret
        source "$filename_secret_conf"
        chatId="$JARVIS_TELEGRAM_BOT_GROUP_CHAT_ID_2"
    fi

    # Send files using send_telegram_files_setting function
    send_telegram_files_setting "$token" "$chatId" "${files[@]}"
}

# send_telegram_attachment function
# Send attachments to a Telegram group chat using a Telegram bot.
#
# Usage:
#   send_telegram_attachment <description> [filename_1] [filename_2] [filename_3] ...
#
# Description:
#   The 'send_telegram_attachment' function sends attachments to a specified Telegram group chat
#   using a Telegram bot. It supports sending multiple files at once, and each file is captioned
#   with a description and timestamp.
#
# Options:
#   <description>: A description for the attachments.
#   [filename_1] [filename_2] [filename_3] ...: File paths of the attachments to be sent.
#
# Example usage:
#   send_telegram_attachment "Logs for today" "/path/to/logfile1.txt" "/path/to/logfile2.txt"
#
# Instructions:
#   1. Run the 'send_telegram_attachment' function with a description and file paths.
#
# Notes:
#   - Ensure that the necessary Telegram bot token and group chat ID are available in the secrets file.
#   - The function uses the 'curl' command to interact with the Telegram Bot API.
#   - Timestamps are added to the captions for better identification.
#
# Dependencies:
#   - 'curl' must be installed for API communication.
#   - The function relies on Telegram bot and chat IDs stored in the secrets file.
#
# Example:
#   send_telegram_attachment "Logs for today" "/path/to/logfile1.txt" "/path/to/logfile2.txt"
function send_telegram_attachment() {
    if [ $# -lt 2 ]; then
        echo "Usage: send_telegram_attachment <description> [filename_1] [filename_2] [filename_3] ..."
        return 1
    fi

    local description="$1"
    local files=("${@:2}")

    # reloading file conf
    source "$filename_secret_conf"
    # local variables
    local token="$JARVIS_TELEGRAM_BOT_TOKEN_1"
    local chatId="$JARVIS_TELEGRAM_BOT_GROUP_CHAT_ID_2"
    local timestamp=$(date +"%Y-%m-%d %H:%M:%S")

    # setting token
    if [[ -z "$token" ]]; then
        echo "❌ Key 'JARVIS_TELEGRAM_BOT_TOKEN_1' not found or empty."
        echo "🚀 Setting key 'JARVIS_TELEGRAM_BOT_TOKEN_1'"
        add_secret
        source "$filename_secret_conf"
        token="$JARVIS_TELEGRAM_BOT_TOKEN_1"
    fi

    # setting chatId
    if [[ -z "$chatId" ]]; then
        echo "❌ Key 'JARVIS_TELEGRAM_BOT_GROUP_CHAT_ID_2' not found or empty."
        echo "🚀 Setting key 'JARVIS_TELEGRAM_BOT_GROUP_CHAT_ID_2'"
        add_secret
        source "$filename_secret_conf"
        chatId="$JARVIS_TELEGRAM_BOT_GROUP_CHAT_ID_2"
    fi

    # sending files to group chatId
    for filename in "${files[@]}"; do
        if [ -f "$filename" ]; then
            progress_bar 0.1
            curl -s -F chat_id="$chatId" -F document=@"$filename" -F caption="$description ($timestamp)" "https://api.telegram.org/bot$token/sendDocument" >/dev/null
            echo "🍺 Attachment '$filename' sent."
        else
            echo "❌ Attachment '$filename' not found. Skipping."
        fi
    done
}
