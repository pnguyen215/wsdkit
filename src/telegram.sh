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
    local message="$1"
    # reloading file conf
    source "$filename_secret_conf"
    # local variables
    local token="$JARVIS_TELEGRAM_BOT_TOKEN_1"
    local chatId="$JARVIS_TELEGRAM_BOT_GROUP_CHAT_ID_1"

    # setting token
    if [[ -n "$token" ]]; then
        echo "🚀 Processing token"
    else
        echo "❌ Key 'JARVIS_TELEGRAM_BOT_TOKEN_1' not found or empty."
        echo "🚀 Setting key 'JARVIS_TELEGRAM_BOT_TOKEN_1'"
        add_secret
        source "$filename_secret_conf"
        token="$JARVIS_TELEGRAM_BOT_TOKEN_1"
    fi

    # setting chatId
    if [[ -n "$chatId" ]]; then
        echo "🚀 Processing chat_id"
    else
        echo "❌ Key 'JARVIS_TELEGRAM_BOT_GROUP_CHAT_ID_1' not found or empty."
        echo "🚀 Setting key 'JARVIS_TELEGRAM_BOT_GROUP_CHAT_ID_1'"
        add_secret
        source "$filename_secret_conf"
        chatId="$JARVIS_TELEGRAM_BOT_GROUP_CHAT_ID_1"
    fi

    send_telegram_message_setting "$token" "$chatId" "$message"
}

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
    if [[ -n "$token" ]]; then
        echo "🚀 Processing token"
    else
        echo "❌ Key 'JARVIS_TELEGRAM_BOT_TOKEN_1' not found or empty."
        echo "🚀 Setting key 'JARVIS_TELEGRAM_BOT_TOKEN_1'"
        add_secret
        source "$filename_secret_conf"
        token="$JARVIS_TELEGRAM_BOT_TOKEN_1"
    fi

    # setting chatId
    if [[ -n "$chatId" ]]; then
        echo "🚀 Processing chat_id"
    else
        echo "❌ Key 'JARVIS_TELEGRAM_BOT_GROUP_CHAT_ID_2' not found or empty."
        echo "🚀 Setting key 'JARVIS_TELEGRAM_BOT_GROUP_CHAT_ID_2'"
        add_secret
        source "$filename_secret_conf"
        chatId="$JARVIS_TELEGRAM_BOT_GROUP_CHAT_ID_2"
    fi

    # Send files using send_telegram_files_setting function
    send_telegram_files_setting "$token" "$chatId" "${files[@]}"
}

# Example usage:
# send_telegram_guardian "/path/to/file1.txt" "/path/to/file2.jpg"
