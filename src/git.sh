# Get the absolute path of the directory containing this script
# SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" &>/dev/null && pwd)"

# Reload functions
source "$SCRIPT_DIR/src/brew.sh"
echo "git lib path: $SCRIPT_DIR/src/brew.sh"

function git_user_info_setting() {
    local username=""
    local email=""

    # Set yout git username
    while [ -z "$username" ]; do
        echo -n "Enter your Git username: "
        read username
        if [ -z "$username" ]; then
            echo "❌ Invalid username. Please try again."
        fi
    done
    # Set your git email
    while [ -z "$email" ]; do
        echo -n "Enter your Git email: "
        read email
        if [ -z "$email" ]; then
            echo "❌ Invalid email. Please try again."
        fi
    done

    echo "🚀 Updating git configuration..."
    git config --global user.name "$username"
    git config --global user.email "$email"
    echo "🍺 Git username $username and email $email updated successfully!"
}
