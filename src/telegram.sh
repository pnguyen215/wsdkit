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
    for file_path in "${@:3}"; do
        # Check if the file exists
        if [ -f "$file_path" ]; then
            # Use curl to send a POST request to the Telegram Bot API for each file
            curl -s -F chat_id="$chatId" -F document=@"$file_path" "https://api.telegram.org/bot$token/sendDocument" >/dev/null
            echo "File '$file_path' sent."
        else
            echo "File '$file_path' not found. Skipping."
        fi
    done
}

# send_telegram_git_activity function
function send_telegram_git_activity() {
    if [ $# -lt 1 ]; then
        echo "Usage: send_telegram_git_activity <message>"
        return 1
    fi
    local token=$(get_secret "JARVIS_TELEGRAM_BOT_TOKEN_1")
    if is_blank "$token"; then
        echo "❌ Key 'JARVIS_TELEGRAM_BOT_TOKEN_1' not found"
        echo "🚀 Setting key 'JARVIS_TELEGRAM_BOT_TOKEN_1'"
        add_secret
        token=$(get_secret "JARVIS_TELEGRAM_BOT_TOKEN_1")
    fi
    local chatId=$(get_secret "JARVIS_TELEGRAM_BOT_GROUP_CHAT_ID_1")
    if is_blank "$chatId"; then
        echo "❌ Key 'JARVIS_TELEGRAM_BOT_GROUP_CHAT_ID_1' not found"
        echo "🚀 Setting key 'JARVIS_TELEGRAM_BOT_GROUP_CHAT_ID_1'"
        add_secret
        chatId=$(get_secret "JARVIS_TELEGRAM_BOT_GROUP_CHAT_ID_1")
    fi
    local message="$1"
    send_telegram_message_setting "$token" "$chatId" "$message"
}
