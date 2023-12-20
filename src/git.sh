# git_user_info_setting function
# This function prompts the user to enter their Git username and email, and updates the global Git configuration accordingly.
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
