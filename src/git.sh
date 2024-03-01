# git_user_info_setting function
# This function prompts the user to enter their Git username and email, and updates the global Git configuration accordingly.
#
# Usage:
#   git_user_info_setting
#
# Description:
#   The 'git_user_info_setting' function interactively prompts the user to enter their Git username and email.
#   It validates the input to ensure a valid username and email are provided.
#   The global Git configuration is then updated with the entered username and email.
#
# Example:
#   git_user_info_setting
#
# Note:
#   Ensure that you have Git installed and configured on your system before using this function.
#   The function uses the 'git config' command to update the global user.name and user.email settings.
#
# Recommendations:
#   It is recommended to set up your Git configuration with accurate user information to associate your commits with your identity.
#   This function provides a convenient way to update your Git credentials globally.
#
# Alias:
#   For convenience, you can set an alias for this function, e.g., in your shell profile:
#   alias gituser="git_user_info_setting"
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
    wsd_exe_cmd git config --global user.name "$username"
    wsd_exe_cmd git config --global user.email "$email"
    echo "🍺 Git username $username and email $email updated successfully!"
}
alias gituserinfosetting="git_user_info_setting"

function git_config_global_setting() {
    wsd_exe_cmd git config --global --list
}
alias gitconfigglobalsetting="git_config_global_setting"

# git_log_graph function
# Displays a graphical and decorated Git log with commit history.
# Usage:
#   git_log_graph
# Options:
#   --all: Show all branches, not just the current one
#
# Example:
#   git_log_graph --all
#
# Aliases:
#   For convenience, you can set an alias for this function, e.g., in your shell profile:
#   alias gitlg="git_log_graph"
#
# This function uses the 'git log' command with additional formatting options to enhance visibility.
# It shows the commit hash, author, relative commit time, branch names, and commit message.
# The '--graph' option adds ASCII art depicting the branching and merging structure.
# The '--decorate' option annotates commits with branch and tag names.
#
# Note: Make sure to set up appropriate aliases or customize the function name based on your preferences.
function git_log_graph() {
    local options="$@"
    wsd_exe_cmd git log --graph --decorate --format=format:'%C(bold blue)%H (%h) %C(reset) - %C(bold green)(%ar)%C(reset) %C(white)%an%C(reset)%C(bold yellow)%d%C(reset) %C(dim white)- %s%C(reset)' --all $options
}
alias gitloggraph="git_log_graph"

# git_log_graph_remote function
# Display a graph of the commit history with decorations, including remote branches.
#
# Usage:
#   git_log_graph_remote [options]
#
# Parameters:
#   - [options]: Additional options to customize the 'git log' command.
#
# Description:
#   The 'git_log_graph_remote' function displays a concise and visually informative graph of the commit history
#   using the 'git log' command. It includes decorations for branches, authors, and commit messages.
#   Additionally, it shows remote branches in the graph.
#
# Options:
#   - [options]: Additional options that can be passed to customize the behavior of the 'git log' command.
#
# Example usage:
#   Run the 'git_log_graph_remote' function to display a graph of the commit history with remote branches.
#   You can pass additional options to customize the output.
#
# Instructions:
#   1. Execute the 'git_log_graph_remote' function to display the commit history graph.
#   2. Optionally, provide additional options to customize the 'git log' command behavior.
#
# Notes:
#   - This function enhances the 'git log' output with a concise and visually appealing graph.
#   - Remote branches are included in the graph for a comprehensive view of the commit history.
#
# Example:
#   git_log_graph_remote
#   git_log_graph_remote --since="2 weeks ago"
function git_log_graph_remote() {
    local options="$@"
    wsd_exe_cmd git log --oneline --graph --decorate --format=format:'%C(bold blue)%H (%h)%C(reset) - %C(bold green)(%ar)%C(reset) %C(white)%an%C(reset)%C(bold yellow)%d%C(reset) %C(dim white)- %s%C(reset)' --all $options
}
alias gitloggraphremote="git_log_graph_remote"

# git_tags_released function
# Lists the released tags in the Git repository along with their creation date and author information.
#
# Usage:
#   git_tags_released
#
# Description:
#   The 'git_tags_released' function displays a list of released tags in the Git repository.
#   It provides information such as the tag name, creation date, and author.
#   The list is sorted in descending order based on the tag creation date.
#
# Example:
#   git_tags_released
#
# Note:
#   Ensure that you are in a Git repository and have released tags before using this function.
#   The function uses the 'git for-each-ref' command to retrieve tag information.
#
# Recommendations:
#   It is a good practice to tag releases in your Git repository to mark specific points in your project history.
#   Tags are often used to create stable release points for reference or deployment.
#
# Customize:
#   You may customize this function or add additional logic based on your specific requirements.
#   For instance, you can extend it to filter tags based on a specific pattern or display additional tag details.
function git_tags_released() {
    echo "✅ Released Tags:"

    git for-each-ref --sort=-creatordate --format='Tag: %(tag)\nDate: %(creatordate:iso8601)\nAuthor: %(subject)\n' refs/tags |
        while IFS= read -r tag_info; do
            echo "$tag_info"
            echo "---"
        done
}
alias gittagsreleased="git_tags_released"

# git_create_tag function
# Sets an alias to create a new Git tag with an annotated message for release.
#
# Usage:
#   git_create_tag <tag_version>
#
# Parameters:
#   <tag_version>: The version number or identifier for the new tag.
#
# Description:
#   The 'git_create_tag' function simplifies the process of creating a new Git tag.
#   It takes a version number as a parameter and creates an annotated tag with a release message.
#   The release message includes an emoji ":gem:" and indicates the successful creation of the release.
#
# Example:
#   git_create_tag 1.0.0
#
# Note:
#   Ensure that you are in a Git repository before using this function.
#   The function uses the 'git tag' command with the '-a' option to create an annotated tag.
#
# Recommendations:
#   Tagging releases is a best practice in version control to mark specific points in your project history.
#   Annotated tags provide additional information, such as a release message, to describe the significance of the release.
function git_create_tag() {
    if [ $# -lt 1 ]; then
        echo "Usage: git_create_tag <tag_version>"
        return 1
    fi
    wsd_exe_cmd git tag -a "$1" -m ":gem: release: $1 created successfully"
}
alias gitcreatetag="git_create_tag"

# git_push_tag function
# Sets an alias to push a specific Git tag to the remote repository.
#
# Usage:
#   git_push_tag <tag_version>
#
# Parameters:
#   <tag_version>: The version number or identifier of the tag to be pushed.
#
# Description:
#   The 'git_push_tag' function simplifies the process of pushing a Git tag to the remote repository.
#   It takes a version number as a parameter and pushes the specified tag to the 'origin' remote.
#
# Example:
#   git_push_tag 1.0.0
#
# Note:
#   Ensure that you are in a Git repository before using this function.
#   The function uses the 'git push' command to push the specified tag to the 'origin' remote.
#
# Recommendations:
#   After creating a new tag using 'git_create_tag', it is essential to push the tag to the remote repository.
#   Pushing tags ensures that the tagged releases are available in the remote repository for collaboration and deployment.
#
# Alias:
#   For convenience, you can set an alias for this function, e.g., in your shell profile:
#   alias gitpushtag="git_push_tag"
function git_push_tag() {
    if [ $# -lt 1 ]; then
        echo "Usage: git_push_tag <tag_version>"
        return 1
    fi
    wsd_exe_cmd git push origin "$1"
}
alias gitpushtag="git_push_tag"

# git_push_tags function
function git_push_tags() {
    wsd_exe_cmd git push origin --tags
}
alias gitpushtags="git_push_tags"

# git_publish_tag_current_short function
# Creates and publishes a new Git tag for the current commit with a short version of the release message.
#
# Usage:
#   git_publish_tag_current_short <tag_version>
#
# Parameters:
#   <tag_version>: The version number or identifier for the new tag.
#
# Description:
#   The 'git_publish_tag_current_short' function simplifies the process of creating and publishing a new Git tag.
#   It takes a version number as a parameter and creates an annotated tag with a short release message.
#   The release message includes an emoji ":gem:" and indicates the successful creation of the release.
#   The tag is then pushed to the 'origin' remote.
#
# Example:
#   git_publish_tag_current_short 1.0.0
#
# Note:
#   Ensure that you are in a Git repository before using this function.
#   The function uses the 'git tag' command with the '-a' option to create an annotated tag and then pushes the tag to the 'origin' remote.
#
# Recommendations:
#   This function provides a quick way to create and publish a new tag for the current commit with minimal release information.
#   It is suitable for situations where a short release message is sufficient.
#
# Alias:
#   For convenience, you can set an alias for this function, e.g., in your shell profile:
#   alias gitpubshort="git_publish_tag_current_short"
function git_publish_tag_current_short() {
    if [ $# -lt 1 ]; then
        echo "Usage: git_publish_tag_current_short <tag_version>"
        return 1
    fi
    wsd_exe_cmd git tag -a "$1" -m ":gem: release: $1 created successfully"
    wsd_exe_cmd git push origin "$1"
}
alias gitpublishtagcurrentshort="git_publish_tag_current_short"

# git_publish_tag_current function
# Creates and publishes a new Git tag for the current commit with a detailed release message.
#
# Usage:
#   git_publish_tag_current <tag_version>
#
# Parameters:
#   <tag_version>: The version number or identifier for the new tag.
#
# Description:
#   The 'git_publish_tag_current' function simplifies the process of creating and publishing a new Git tag with detailed information.
#   It takes a version number as a parameter and constructs a release message containing branch name, latest commit details, author, and commit date.
#   The annotated tag is then created with the detailed release message and pushed to the 'origin' remote.
#
# Example:
#   git_publish_tag_current 1.0.0
function git_publish_tag_current() {
    if [ $# -lt 1 ]; then
        echo "Usage: git_publish_tag_current <tag_version>"
        return 1
    fi
    local current_branch
    local latest_commit
    local commit_author
    local commit_date
    local release_message

    # Get the current branch or exit if not on any branch
    current_branch=$(git symbolic-ref --short HEAD 2>/dev/null)
    if [[ -z "$current_branch" ]]; then
        echo "❌ Error: Not on any branch. Aborting."
        return 1
    fi

    # Get commit details
    latest_commit=$(git rev-parse --short HEAD)
    commit_author=$(git log -1 --format='%an')
    commit_date=$(git log -1 --format='%ad' --date=format:'%Y-%m-%d %H:%M:%S')

    # Construct the release message
    release_message=":gem: release: $1\n\n"
    release_message+="**Branch:** $current_branch\n"
    release_message+="**Latest Commit:** $latest_commit\n"
    release_message+="**Commit Author:** $commit_author\n"
    release_message+="**Commit Date:** $commit_date\n"

    # Create and push the tag
    if git tag -a "$1" -m "$release_message" && git push origin "$1"; then
        echo "🍺 Tag '$1' created and pushed successfully."
    else
        echo "❌ Error: Failed to create and push tag '$1'."
        return 1
    fi
}
alias gitpublishtagcurrent="git_publish_tag_current"

# git_publish_tag_branch_short function
# Creates and publishes a new Git tag for a specific branch with a short version of the release message.
#
# Usage:
#   git_publish_tag_branch_short <branch_name> <tag_version>
#
# Parameters:
#   <branch_name>: The name of the branch for which the tag is created.
#   <tag_version>: The version number or identifier for the new tag.
#
# Description:
#   The 'git_publish_tag_branch_short' function simplifies the process of creating and publishing a new Git tag for a specific branch.
#   It takes the branch name and version number as parameters, creates an annotated tag with a short release message,
#   and pushes the tag to the 'origin' remote.
#   The function ensures that the original branch is checked out after the tag is created.
#
# Example:
#   git_publish_tag_branch_short main 1.0.0
function git_publish_tag_branch_short() {
    if [ $# -lt 2 ]; then
        echo "Usage: git_publish_tag_branch_short <branch_name> <tag_version>"
        return 1
    fi
    local current_branch=$(git rev-parse --abbrev-ref HEAD)
    wsd_exe_cmd git checkout "$1"
    wsd_exe_cmd git tag -a "$2" -m ":gem: release: $2 created successfully"
    wsd_exe_cmd git push origin "$2"
    wsd_exe_cmd git checkout "$current_branch"
}
alias gitpublishtagbranchshort="git_publish_tag_branch_short"

# git_publish_tag_branch function
# Creates and publishes a new Git tag for a specified branch with a detailed release message.
#
# Usage:
#   git_publish_tag_branch <branch_name> <tag_version>
#
# Parameters:
#   <branch_name>: The name of the branch for which the tag is created.
#   <tag_version>: The version number or identifier for the new tag.
#
# Description:
#   The 'git_publish_tag_branch' function simplifies the process of creating and publishing a new Git tag for a specified branch with detailed information.
#   It takes the branch name and version number as parameters, switches to the specified branch, gathers commit details, constructs a release message,
#   creates an annotated tag with the detailed release message, and pushes the tag to the 'origin' remote.
#   The function ensures that the original branch is checked out after the tag is created.
#
# Example:
#   git_publish_tag_branch main 1.0.0
function git_publish_tag_branch() {
    if [ $# -lt 2 ]; then
        echo "Usage: git_publish_tag_branch <branch_name> <tag_version>"
        return 1
    fi

    local current_branch
    local current_commit
    local commit_author
    local commit_date
    local release_message

    # Get the current branch
    current_branch=$(git rev-parse --abbrev-ref HEAD)

    # Switch to the specified branch
    if ! git checkout "$1"; then
        echo "❌ Error: Failed to switch to branch '$1'. Aborting."
        return 1
    fi

    # Get details of the current commit
    current_commit=$(git rev-parse --short HEAD)
    commit_author=$(git log -1 --format='%an')
    commit_date=$(git log -1 --format='%ad' --date=format:'%Y-%m-%d %H:%M:%S')

    # Construct the release message
    release_message=":gem: release: $2\n\n"
    release_message+="**Branch:** $1\n"
    release_message+="**Latest Commit:** $current_commit\n"
    release_message+="**Commit Author:** $commit_author\n"
    release_message+="**Commit Date:** $commit_date\n"

    # Create and push the tag
    if git tag -a "$2" -m "$release_message" && git push origin "$2"; then
        echo "🍺 Tag '$2' created and pushed successfully."
    else
        echo "❌ Error: Failed to create and push tag '$2'."
        return 1
    fi

    # Switch back to the original branch
    wsd_exe_cmd git checkout "$current_branch"
    send_telegram_git_activity "$release_message \n\n Tag \`$2\` created and pushed successfully"
}
alias gitpublishtagbranch="git_publish_tag_branch"

# git_remove_tag function
# Removes a Git tag both locally and on the remote repository.
#
# Usage:
#   git_remove_tag <tag_version>
#
# Parameters:
#   <tag_version>: The version number or identifier of the tag to be removed.
#
# Description:
#   The 'git_remove_tag' function simplifies the process of removing a Git tag from both the local repository and the remote repository.
#   It takes the version number of the tag as a parameter, removes the tag locally, pushes the removal to the 'origin' remote, and sends a Telegram notification.
#
# Example:
#   git_remove_tag 1.0.0
function git_remove_tag() {
    if [ $# -lt 1 ]; then
        echo "Usage: git_remove_tag <tag_version>"
        return 1
    fi
    echo "🗑️ Removing tag $1 locally..."
    wsd_exe_cmd git tag -d "$1"

    echo "🗑️ Removing tag $1 on remote..."
    wsd_exe_cmd git push origin :refs/tags/"$1"
    send_telegram_git_activity "Removed tag \`$1\` on remote =)"
}
alias gitremovetag="git_remove_tag"

# git_remove_branch function
# Removes a Git branch both locally and on the remote repository.
#
# Usage:
#   git_remove_branch <branch_name>
#
# Parameters:
#   <branch_name>: The name of the branch to be removed.
#
# Description:
#   The 'git_remove_branch' function simplifies the process of removing a Git branch from both the local repository and the remote repository.
#   It takes the branch name as a parameter, removes the branch locally, pushes the removal to the 'origin' remote, and sends a Telegram notification.
#
# Example:
#   git_remove_branch feature-branch
function git_remove_branch() {
    if [ $# -lt 1 ]; then
        echo "Usage: git_remove_branch <branch_name>"
        return 1
    fi
    echo "🗑️ Removing branch $1 locally..."
    wsd_exe_cmd git branch -D "$1"

    echo "🗑️ Removing branch $1 on remote..."
    wsd_exe_cmd git push origin --delete "$1"
    send_telegram_git_activity "Removed branch \`$1\` on remote =)"
}
alias gitremovebranch="git_remove_branch"

# git_create_branch function
# Creates a new Git branch and switches to it, then pushes the branch to the remote repository.
#
# Usage:
#   git_create_branch <branch_name>
#
# Parameters:
#   <branch_name>: The name of the new branch to be created.
#
# Description:
#   The 'git_create_branch' function simplifies the process of creating a new Git branch, switching to it, and pushing it to the 'origin' remote.
#   It takes the branch name as a parameter, creates the branch locally, switches to the new branch, and pushes it to the 'origin' remote.
#
# Example:
#   git_create_branch feature-branch
function git_create_branch() {
    if [ $# -lt 1 ]; then
        echo "Usage: git_create_branch <branch_name>"
        return 1
    fi
    echo "🚀 Creating and switching to branch $1..."
    wsd_exe_cmd git checkout -b "$1"

    echo "🚀 Pushing branch $1 to remote..."
    wsd_exe_cmd git push -u origin "$1"
    send_telegram_git_activity "Pushed branch \`$1\` to remote =)"
}
alias gitcreatebranch="git_create_branch"

# git_fetch_branch function
# Checks out a Git branch and fetches the latest changes from the remote repository.
#
# Usage:
#   git_fetch_branch <branch_name>
#
# Parameters:
#   <branch_name>: The name of the branch to be checked out and fetched.
#
# Description:
#   The 'git_fetch_branch' function simplifies the process of checking out a Git branch and fetching the latest changes from the 'origin' remote.
#   It takes the branch name as a parameter, checks out the branch locally, fetches the latest changes from the remote repository, and pulls the changes.
#
# Example:
#   git_fetch_branch feature-branch
#
# Note:
#   Ensure that you are in a Git repository before using this function.
#   The function updates the local branch with the latest changes from the remote repository, allowing you to work with the most recent code.
#
# Recommendations:
#   This function is useful when you want to switch to an existing branch and ensure that it reflects the latest changes from the remote repository.
#   It helps maintain synchronization between your local branches and the remote repository.
function git_fetch_branch() {
    if [ $# -lt 1 ]; then
        echo "Usage: git_fetch_branch <branch_name>"
        return 1
    fi
    echo "🚀 Checking out branch $1"
    wsd_exe_cmd git checkout "$1"

    echo "🚀 Fetching branch $1 from remote..."
    wsd_exe_cmd git fetch --all --tags
    wsd_exe_cmd git pull -f
}
alias gitfetchbranch="git_fetch_branch"

# git_fetch_branch_current function
# Fetches the latest changes for the currently checked-out Git branch from the remote repository.
#
# Usage:
#   git_fetch_branch_current
#
# Description:
#   The 'git_fetch_branch_current' function simplifies the process of fetching the latest changes for the currently checked-out Git branch.
#   It fetches the changes from the 'origin' remote and pulls the changes, ensuring that the local branch reflects the latest code from the remote repository.
#
# Example:
#   git_fetch_branch_current
#
# Note:
#   Ensure that you are in a Git repository before using this function.
#   The function updates the currently checked-out branch with the latest changes from the remote repository, keeping your local branch synchronized.
#
# Recommendations:
#   This function is useful when you want to quickly update the currently checked-out branch without specifying the branch name.
#   It helps maintain synchronization between your local branch and the remote repository.
function git_fetch_branch_current() {
    local current_branch=$(git rev-parse --abbrev-ref HEAD)
    echo "🚀 Fetching branch $current_branch from remote..."
    wsd_exe_cmd git fetch --all --tags
    wsd_exe_cmd git pull -f
}
alias gitfetchbranchcurrent="git_fetch_branch_current"

# git_fetch_remote_branch_checkout function
# Fetches a remote Git branch and checks it out locally.
#
# Usage:
#   git_fetch_remote_branch_checkout <branch_name>
#
# Parameters:
#   <branch_name>: The name of the remote branch to be fetched and checked out locally.
#
# Description:
#   The 'git_fetch_remote_branch_checkout' function simplifies the process of fetching a remote Git branch and checking it out locally.
#   It takes the remote branch name as a parameter, fetches the branch from the 'origin' remote, and checks it out locally.
#
# Example:
#   git_fetch_remote_branch_checkout feature-branch
#
# Note:
#   Ensure that you are in a Git repository before using this function.
#   The function fetches the specified remote branch and checks it out locally, allowing you to start working on it immediately.
#
# Recommendations:
#   This function is useful when you want to quickly fetch and switch to a remote branch without separate commands.
#   It streamlines the process of setting up a local working copy of a remote branch for development or collaboration.
function git_fetch_remote_branch_checkout() {
    if [ $# -lt 1 ]; then
        echo "Usage: git_fetch_remote_branch_checkout <branch_name>"
        return 1
    fi
    wsd_exe_cmd git fetch origin "$1":"$1"
    wsd_exe_cmd git checkout "$1"
}
alias gitfetchremotebranchcheckout="git_fetch_remote_branch_checkout"

# git_push_branch_remote_force function
# Force-push a local Git branch to its remote counterpart.
#
# Usage:
#   git_push_branch_remote_force <branch_name>
#
# Parameters:
#   - <branch_name>: The name of the local branch to force-push.
#
# Description:
#   The 'git_push_branch_remote_force' function allows you to force-push a local Git branch
#   to its remote counterpart on the origin. This can be useful when you need to overwrite
#   the remote branch with your local changes.
#
# Options:
#   <branch_name>: The name of the local branch you want to force-push.
#
# Example usage:
#   git_push_branch_remote_force feature/my-feature-branch
#
# Instructions:
#   1. Run the 'git_push_branch_remote_force' function with the name of the local branch to force-push.
#   2. The function will force-push the specified branch to its remote counterpart on the origin.
#   3. After force-push, the function checks out the original branch you were on before force-pushing.
#
# Notes:
#   - Use with caution, as force-pushing can overwrite remote changes.
#   - Ensure you have the necessary permissions to force-push to the remote repository.
#
# Dependencies:
#   - git
function git_push_branch_remote_force() {
    if [ $# -lt 1 ]; then
        echo "Usage: git_push_branch_remote_force <branch_name>"
        return 1
    fi
    local current_branch=$(git rev-parse --abbrev-ref HEAD)
    wsd_exe_cmd git push --set-upstream --force origin "$1"
    wsd_exe_cmd git checkout "$current_branch"
}
alias gitpushbranchremoteforce="git_push_branch_remote_force"

# git_push_branch_remote_force_current function
# Force-push the current local Git branch to its remote counterpart.
#
# Usage:
#   git_push_branch_remote_force_current
#
# Description:
#   The 'git_push_branch_remote_force_current' function allows you to force-push the current local Git branch
#   to its remote counterpart on the origin. This is a convenient shortcut to force-push the branch you are currently on.
#
# Options:
#   None
#
# Example usage:
#   git_push_branch_remote_force_current
#
# Instructions:
#   1. Run the 'git_push_branch_remote_force_current' function to force-push the current branch to its remote counterpart.
#   2. The function will identify the current branch and force-push it to its remote counterpart on the origin.
#   3. After force-push, the function checks out the original branch you were on before force-pushing.
#
# Notes:
#   - Use with caution, as force-pushing can overwrite remote changes.
#   - Ensure you have the necessary permissions to force-push to the remote repository.
#
# Dependencies:
#   - git
function git_push_branch_remote_force_current() {
    local current_branch=$(git rev-parse --abbrev-ref HEAD)
    git_push_branch_remote_force "$current_branch"
}
alias gitpushbranchremoteforcecurrent="git_push_branch_remote_force_current"

# git_rebase_squash_push_commit function
# Rebases, squashes commits, and pushes changes to the remote Git repository.
#
# Usage:
#   git_rebase_squash_push_commit <commit_message> <no.rows_rebase_squash>
#
# Parameters:
#   <commit_message>: The commit message for the new squashed commit.
#   <no.rows_rebase_squash>: The number of recent commits to rebase and squash.
#
# Description:
#   The 'git_rebase_squash_push_commit' function automates the process of rebasing and squashing a specified number of recent commits.
#   It takes a commit message for the new squashed commit and the number of recent commits to rebase and squash.
#   After rebasing and squashing, it pushes the changes to the remote Git repository.
#
# Example:
#   git_rebase_squash_push_commit "Feature complete" 3
#
# Note:
#   Ensure that you are in a Git repository before using this function.
#   The function performs an interactive rebase, allowing you to squash multiple commits into a single commit with the specified message.
#
# Recommendations:
#   This function is useful when you want to clean up and combine multiple commits into a single commit before pushing changes to the remote repository.
#   It streamlines the process of rebasing, squashing, and pushing changes with a single command.
function git_rebase_squash_push_commit() {
    if [ $# -lt 2 ]; then
        echo "Usage: git_rebase_squash_push_commit <commit_message> <no.rows_rebase_squash>"
        return 1
    fi
    local commit_message="$1"
    local current_branch=$(git rev-parse --abbrev-ref HEAD)

    # Rebasing and Squashing commits
    wsd_exe_cmd git rebase -i HEAD~"$2"
    wsd_exe_cmd git reset --soft HEAD~
    wsd_exe_cmd git commit -m "$commit_message"

    # Push remote server
    wsd_exe_cmd git push origin "$current_branch" --force
}

# git_merge_push function
# Merges changes from a source branch into a target branch, handling conflicts interactively and pushing the changes to the remote repository.
#
# Usage:
#   git_merge_push <source_branch> <target_branch>
#
# Parameters:
#   <source_branch>: The branch from which changes will be merged.
#   <target_branch>: The branch into which changes will be merged.
#
# Description:
#   The 'git_merge_push' function automates the process of merging changes from a source branch into a target branch.
#   It handles conflicts interactively, displaying conflicted files, and allowing the user to resolve conflicts in each file.
#   After resolving conflicts, the changes are committed and pushed to the remote repository.
#
# Example:
#   git_merge_push feature-branch main
#
# Note:
#   Ensure that you are in a Git repository before using this function.
#   The function provides a detailed conflict resolution process, allowing the user to interactively resolve conflicts in each conflicted file.
#   It uses the system's default editor to open conflicted files for resolution.
#   After resolving conflicts, the user must press Enter to continue the process.
#
# Recommendations:
#   This function is useful when you want to merge changes from a feature branch into the main branch, handling conflicts interactively and pushing changes to the remote repository.
#   It streamlines the process of conflict resolution and ensures that conflicts are addressed before committing and pushing changes.
function git_merge_push() {
    if [ $# -lt 2 ]; then
        echo "Usage: git_merge_push <source_branch> <target_branch>"
        return 1
    fi
    local source_branch="$1"
    local target_branch="$2"
    local current_branch=$(git rev-parse --abbrev-ref HEAD)

    # Merge the entire code content from the source branch to the target branch
    wsd_exe_cmd git checkout "$target_branch"
    wsd_exe_cmd git merge --no-commit "$source_branch"

    # Check for conflicts
    if [[ -n $(git ls-files --unmerged) ]]; then
        # Display detailed conflicts
        conflicted_files=$(git diff --name-only --diff-filter=U)
        wsd_exe_cmd git status

        echo "There are conflicts in the following files:"
        echo "$conflicted_files"

        # Count the number of conflicts in each file
        for file in "$conflicted_files"; do
            num_conflicts=$(grep -c "conflict" "$file")
            echo "Number of conflicts in file $file: $num_conflicts"
        done

        echo "Please resolve the conflicts before proceeding."
        return 1
    fi

    # Add notes to conflicted files
    for file in $(git ls-files --unmerged | cut -f2); do
        echo "------------------------------------------------------------------------"
        echo "Conflict with file: $file"
        echo "Please resolve the conflict and save the file afterwards."
        echo "------------------------------------------------------------------------"
        echo

        # Open the file with the system's default editor
        # (You can change the command to open the preferred editor)
        # Example: code $file
        #          sublime $file
        #          vim $file

        # After saving the file, proceed notification
        read -p "Press Enter to continue after resolving the conflict on $file."
        echo
    done

    # Complete the merge process and create a new commit
    wsd_exe_cmd git commit -m "Branch $source_branch has merged into $target_branch"

    # Push the changes to the remote server (mandatory to apply from local)
    wsd_exe_cmd git push --force-with-lease origin "$target_branch"
    wsd_exe_cmd git checkout "$current_branch"
}
alias gitmergepush="git_merge_push"

# git_revert_branch function
# Creates a new branch reverting changes from a specified commit or branch and pushes the new branch to the remote repository.
#
# Usage:
#   git_revert_branch <commit/branch>
#
# Parameters:
#   <commit/branch>: The commit hash or branch name to which changes will be reverted.
#
# Description:
#   The 'git_revert_branch' function automates the process of reverting changes from a specified commit or branch.
#   It creates a new branch prefixed with 'rev/' and a timestamp, reverting changes to the specified commit or branch.
#   The new branch is then pushed to the remote repository.
#
# Example:
#   git_revert_branch feature-branch
#   git_revert_branch abc1234
#
# Notes:
#   - Ensure that you are in a Git repository before using this function.
#   - The target can be a commit hash or branch name.
#   - The new branch name is prefixed with 'rev/' followed by a timestamp and the specified commit/branch name.
#
# Recommendations:
#   - This function is useful when you need to revert changes from a specific commit or branch and push the changes to a new branch.
#   - It simplifies the process of creating a branch that contains the reverted changes, ensuring that the original branch remains unaffected.
function git_revert_branch() {
    if [ $# -lt 1 ]; then
        echo "Usage: git_revert_branch <commit/branch>"
        return 1
    fi

    target="$1"

    # Check if the target is a valid commit hash or branch name
    if ! git rev-parse --verify "$target" >/dev/null 2>&1; then
        echo "❌ Invalid commit/branch: $target"
        return 1
    fi

    timestamp=$(date +"%Y%m%d.%H%M%S")
    echo "🍉 Pre. newly branch: $timestamp"
    branch_name="rev/$timestamp"."$target"

    echo "🚀 Reverting to <commit/branch> $target..."

    # Perform the revert operation
    wsd_exe_cmd git checkout -b "$branch_name"
    wsd_exe_cmd git reset --hard "$target"

    msg="Revert branch '$target' completed. New branch: \`$branch_name\`"
    echo "$msg"

    # Push the newly created branch to the remote origin
    wsd_exe_cmd git push origin "$branch_name"
    echo "🍺 Branch $branch_name pushed to origin."
    send_telegram_git_activity "$msg"
}
alias gitrevertbranch="git_revert_branch"

# git_commit_with_format function
# Simplifies the process of creating well-formatted and standardized Git commit messages with emoji icons.

# Usage:
#   git_commit_with_format
#
# Description:
#   The 'git_commit_with_format' function guides the user in creating a Git commit with a standardized format.
#   It prompts the user to select a commit type (e.g., feat, fix, chore) and enter a concise commit description.
#   Additionally, the user can optionally provide an issue number associated with the commit.
#   The function constructs a commit message with an emoji icon representing the commit type, the commit description,
#   and the issue number (if provided). The user is then prompted for confirmation to commit the changes.
#
# Example:
#   git_commit_with_format
#
# Recommendations:
#   - Use this function to ensure consistent and meaningful commit messages.
#   - The commit types and corresponding emoji icons provide visual categorization of commit purposes.
#   - Emoji icons help convey the nature of the change quickly.
function git_commit_with_format() {
    # Checking stages
    # list_stage_interactive
    # Define emoji icons for different commit types
    emoji_icons=(
        ":sparkles:"                 # feat
        ":bug:"                      # fix
        ":wrench:"                   # chore
        ":books:"                    # docs
        ":art:"                      # style
        ":recycle:"                  # refactor
        ":white_check_mark:"         # test
        ":chart_with_upwards_trend:" # perf
        ":construction:"             # WIP
        ":zap:"                      # improvement
        ":rewind:"                   # revert
        ":lock:"                     # security
        ":fire:"                     # remove
        ":tada:"                     # initial source
        ":loud_sound:"               # logs
        ":gear:"                     # config
        ":hammer:"                   # build
        ":package:"                  # dependency
        ":rocket:"                   # deployment
        ":earth_americas:"           # localization
        ":mag:"                      # search
        ":alien:"                    # experimental
        ":bookmark:"                 # version tag
        ":mute:"                     # silent changes
        ":warning:"                  # deprecation
        ":gem:"                      # release
    )
    # Prompt for commit type
    echo "Select commit type:"
    select commit_type in "feat" "fix" "chore" "docs" "style" "refactor" "test" "perf" "WIP" "improvement" "revert" "security" "remove" "initial source" "logs" "config" "build" "dependency" "deployment" "localization" "search" "experimental" "version tag" "silent changes" "deprecation" "release"; do
        break
    done

    # Prompt for commit description
    local commit_description=""
    while [ -z "$commit_description" ]; do
        echo -n "Enter a concise and clear commit desc: "
        read commit_description
        if [ -z "$commit_description" ]; then
            echo "❌ Invalid commit desc. Please try again."
        fi
    done

    # Prompt for issue number
    local issue_number=""
    while [ -z "$issue_number" ]; do
        echo -n "Enter issue number (e.g. #1): "
        read issue_number
        if [ -z "$issue_number" ]; then
            echo "❌ Invalid issue number. Please try again."
        fi
    done

    # Issue number binding
    local issue_info=""
    if [[ ! -z "$issue_number" ]]; then
        issue_info=" $issue_number"
    fi

    # Construct the commit message
    emoji_icon=${emoji_icons[$REPLY]}
    commit_message="$emoji_icon $commit_type: $commit_description$issue_info"

    # Display the constructed commit message
    echo "🚀 Commit message:"
    echo -e "$commit_message"

    # Ask for confirmation
    echo "❓ Wanna to commit this message? (y/n): "
    read confirm

    #   The user input is checked to be a valid confirmation response (y/yes/Yes/YES or n/no/No/NO).
    #   If an invalid response is entered, the prompt will be repeated until a valid response is received.
    while [[ ! "$confirm" =~ ^(y|yes|Yes|YES|n|no|No|NO)$ ]]; do
        echo "❌ Invalid input. Please enter a valid response(y/n): "
        read confirm
    done

    if [[ "$confirm" =~ ^(y|yes|Yes|YES)$ ]]; then
        wsd_exe_cmd git commit -m "$commit_message"
        send_telegram_git_activity "\`$commit_message\`"
        wsd_exe_cmd git push -f
        echo "🍺 The commit pushed successfully to origin."
    else
        echo "🍌 Commit aborted."
    fi
}
alias gitcommitwithformat="git_commit_with_format"

# git_revert_branch_current function
# Creates a new branch and reverts the current branch to its state, creating a clean slate for further development.

# Usage:
#   git_revert_branch_current

# Description:
#   The 'git_revert_branch_current' function creates a new branch with a timestamp in its name and reverts the current branch to its state.
#   This operation is useful when you want to start fresh with a clean slate on your current development branch.
#   The newly created branch can be used for experimental changes or isolating specific features.

# Example:
#   git_revert_branch_current

# Recommendations:
#   - Use this function when you want to create a clean branch for experimental changes or isolating specific features.
#   - The new branch name includes a timestamp and the name of the current branch, providing a unique identifier.
function git_revert_branch_current() {
    local current_branch=$(git rev-parse --abbrev-ref HEAD)

    # Check if the current branch is a valid commit hash or branch name
    if ! git rev-parse --verify "$current_branch" >/dev/null 2>&1; then
        echo "❌ Invalid commit/branch: $current_branch"
        return 1
    fi

    timestamp=$(date +"%Y%m%d.%H%M%S")
    echo "🍉 Pre. newly branch: $timestamp"
    branch_name="rev/$timestamp"."$current_branch"

    echo "🚀 Reverting to <commit/branch> $current_branch..."

    # Perform the revert operation
    wsd_exe_cmd git checkout -b "$branch_name"
    wsd_exe_cmd git reset --hard "$current_branch"

    msg="Revert branch '$current_branch' completed. New branch: \`$branch_name\`"
    echo "$msg"
    # Push the newly created branch to the remote origin
    wsd_exe_cmd git push origin "$branch_name"
    echo "🍺 Branch $branch_name pushed to origin."
    send_telegram_git_activity "$msg"
}
alias gitrevertbranchcurrent="git_revert_branch_current"

# git_backup_branch function
# Creates a backup branch by creating a new branch and checking out a specific commit or branch.
#
# Usage:
#   git_backup_branch <commit/branch>
#
# Parameters:
#   <commit/branch>: The commit hash or branch name to create a backup from.
#
# Description:
#   The 'git_backup_branch' function creates a backup branch by checking out a specific commit or branch.
#   This is useful when you want to create a backup of the current state before making significant changes.
#   The newly created backup branch includes a timestamp in its name for easy identification.

# Example:
#   git_backup_branch main
#
# Recommendations:
#   - Use this function when you want to create a backup of a specific commit or branch before making significant changes.
#   - The backup branch name includes a timestamp and the name of the target commit or branch, providing a unique identifier.
function git_backup_branch() {
    if [ $# -lt 1 ]; then
        echo "Usage: git_backup_branch <commit/branch>"
        return 1
    fi

    local target="$1"

    # Check if the target is a valid commit hash or branch name
    if ! git rev-parse --verify "$target" >/dev/null 2>&1; then
        echo "❌ Invalid commit/branch: $target"
        return 1
    fi

    timestamp=$(date +"%Y%m%d.%H%M%S")
    local current_branch=$(git rev-parse --abbrev-ref HEAD)
    echo "🍉 Pre. newly branch: $timestamp"
    branch_name="backup/$timestamp"."$target"

    echo "🚀 Backup to <commit/branch> $target..."

    # Perform the backup operation
    wsd_exe_cmd git checkout -b "$branch_name"

    msg="Backup branch '$target' completed. New branch: \`$branch_name\`"
    echo "$msg"

    # Push the newly created branch to the remote origin
    wsd_exe_cmd git push origin "$branch_name"
    echo "🍺 Branch $branch_name pushed to origin."
    wsd_exe_cmd git checkout "$current_branch"
    send_telegram_git_activity "$msg"
}
alias gitbackupbranch="git_backup_branch"

function git_backup_branch_current() {
    local current_branch=$(git rev-parse --abbrev-ref HEAD)
    git_backup_branch "$current_branch"
}
alias gitbackupbranchcurrent="git_backup_branch_current"

# git_revert_branch_local function
# Reverts to a specific commit or branch by creating a new branch and checking out the target commit or branch on the local repository.
#
# Usage:
#   git_revert_branch_local <commit/branch>
#
# Parameters:
#   <commit/branch>: The commit hash or branch name to revert to.
#
# Description:
#   The 'git_revert_branch_local' function creates a new branch and checks out a specific commit or branch,
#   effectively reverting the local repository to the specified state.
#   The newly created branch includes a timestamp in its name for easy identification.
#
# Example:
#   git_revert_branch_local main
#
# Recommendations:
#   - Use this function when you want to revert the local repository to a specific commit or branch.
#   - The revert operation is performed by creating a new branch, leaving the current branch unchanged.
function git_revert_branch_local() {
    if [ $# -lt 1 ]; then
        echo "Usage: git_revert_branch_local <commit/branch>"
        return 1
    fi

    local target="$1"

    # Check if the target is a valid commit hash or branch name
    if ! git rev-parse --verify "$target" >/dev/null 2>&1; then
        echo "❌ Invalid commit/branch: $target"
        return 1
    fi

    timestamp=$(date +"%Y%m%d.%H%M%S")
    echo "🍉 Pre. newly branch: $timestamp"
    branch_name="rev/$timestamp"."$target"

    echo "🚀 Reverting to <commit/branch> $target..."

    # Perform the revert operation
    wsd_exe_cmd git checkout -b "$branch_name"
    wsd_exe_cmd git reset --hard "$target"

    msg="Revert branch '$target' completed on local. New branch: \`$branch_name\`"
    echo "$msg"
    send_telegram_git_activity "$msg"
}
alias gitrevertbranchlocal="git_revert_branch_local"

function git_revert_branch_local_current() {
    local current_branch=$(git rev-parse --abbrev-ref HEAD)
    git_revert_branch_local "$current_branch"
}
alias gitrevertbranchlocalcurrent="git_revert_branch_local_current"

# git_backup_branch_local function
# Creates a backup of a specific commit or branch by creating a new branch and checking out the target commit or branch on the local repository.
#
# Usage:
#   git_backup_branch_local <commit/branch>
#
# Parameters:
#   <commit/branch>: The commit hash or branch name to create a backup of.
#
# Description:
#   The 'git_backup_branch_local' function creates a new branch and checks out a specific commit or branch,
#   effectively creating a backup of the local repository at the specified state.
#   The newly created branch includes a timestamp in its name for easy identification.
#
# Example:
#   git_backup_branch_local feature-branch
#
# Recommendations:
#   - Use this function when you want to create a backup of the local repository at a specific commit or branch.
#   - The backup operation is performed by creating a new branch, leaving the current branch unchanged.
function git_backup_branch_local() {
    if [ $# -lt 1 ]; then
        echo "Usage: git_backup_branch_local <commit/branch>"
        return 1
    fi

    local target="$1"

    # Check if the target is a valid commit hash or branch name
    if ! git rev-parse --verify "$target" >/dev/null 2>&1; then
        echo "❌ Invalid commit/branch: $target"
        return 1
    fi

    timestamp=$(date +"%Y%m%d.%H%M%S")
    local current_branch=$(git rev-parse --abbrev-ref HEAD)
    echo "🍉 Pre. newly branch: $timestamp"
    branch_name="backup/$timestamp"."$target"

    echo "🚀 Backup to <commit/branch> $target..."

    # Perform the backup operation
    wsd_exe_cmd git checkout -b "$branch_name"

    msg="Backup branch '$target' completed on local. New branch: \`$branch_name\`"
    echo "$msg"

    wsd_exe_cmd git checkout "$current_branch"
    send_telegram_git_activity "$msg"
}
alias gitbackupbranchlocal="git_backup_branch_local"

function git_backup_branch_local_current() {
    local current_branch=$(git rev-parse --abbrev-ref HEAD)
    git_backup_branch_local "$current_branch"
}
alias gitbackupbranchlocalcurrent="git_backup_branch_local_current"

# git_remove_branch_local function
# Removes a local branch from the Git repository.
#
# Usage:
#   git_remove_branch_local <branch_name>
#
# Parameters:
#   <branch_name>: The name of the local branch to be removed.
#
# Description:
#   The 'git_remove_branch_local' function deletes the specified local branch from the Git repository.
#   It uses the '-D' option, which forces the deletion of the branch, even if changes are not merged.
#   Use this function carefully, as it permanently deletes the local branch and its history.
#
# Example:
#   git_remove_branch_local feature-branch
#
# Recommendations:
#   - Before removing a branch, ensure that you don't have any unmerged changes that you want to keep.
#   - Use this function when you want to clean up your local repository by removing obsolete branches.
function git_remove_branch_local() {
    echo "🚀 Removing branch $1 locally..."
    wsd_exe_cmd git branch -D "$1"
}
alias gitremovebranchlocal="git_remove_branch_local"

# git_rename_branch function
# Renames a local Git branch and updates the remote repository accordingly.
#
# Usage:
#   git_rename_branch <old_name> <new_name>
#
# Parameters:
#   <old_name>: The current name of the local branch.
#   <new_name>: The desired new name for the local branch.
#
# Description:
#   The 'git_rename_branch' function renames a local Git branch and synchronizes the changes
#   with the remote repository. It first renames the branch locally and then pushes the changes
#   to the remote repository, updating the branch name remotely.
#
# Example:
#   git_rename_branch feature-branch new-feature-branch
#
# Recommendations:
#   - Ensure that you are on the branch you want to rename.
#   - Provide meaningful and consistent branch names.
#   - Be cautious when renaming branches that are shared with others.
function git_rename_branch() {
    if [ $# -lt 2 ]; then
        echo "Usage: git_rename_branch <old_name> <new_name>"
        return 1
    fi

    local current_branch=$(git rev-parse --abbrev-ref HEAD)
    local old_name="$1"
    local new_name="$2"

    # Rename the branch locally
    if git branch -m "$old_name" "$new_name"; then
        echo "🍺 Local branch '$old_name' renamed to '$new_name'."
    else
        echo "❌ Error: Failed to rename local branch '$old_name'. Aborting."
        return 1
    fi

    # Push the new branch name to the remote repository
    if git push origin -u "$new_name"; then
        echo "🍺 Pushed renamed branch '$new_name' to the remote repository."
    else
        echo "❌ Error: Failed to push renamed branch '$new_name' to the remote repository. Aborting."
        return 1
    fi

    # Delete the old branch on the remote repository
    if git push origin --delete "$old_name"; then
        echo "🍺 Deleted old branch '$old_name' on the remote repository."
    else
        echo "❌ Error: Failed to delete old branch '$old_name' on the remote repository."
    fi

    msg="Branch '$old_name' renamed to \`$new_name\` both locally and remotely."
    echo "$msg"
    wsd_exe_cmd git checkout "$current_branch"
    send_telegram_git_activity "$msg"
}
alias gitrenamebranch="git_rename_branch"

# git_all_branch function
# Lists all local and remote Git branches.
#
# Usage:
#   git_all_branch
#
# Parameters:
#   None.
#
# Description:
#   The 'git_all_branch' function lists all local and remote Git branches.
#   It displays both local branches and remote branches from the origin repository.
#
# Example:
#   git_all_branch
#
# Recommendations:
#   - Use this function to quickly view the available branches in your Git repository.
#   - It provides an overview of both local and remote branches.
function git_all_branch() {
    echo "✅ Local branches:"
    git for-each-ref --format='%(refname:short)' refs/heads |
        while read local_branch; do
            echo "🔁 $local_branch"
        done

    echo "✅ Remote branches:"
    git for-each-ref --format='%(refname:short)' refs/remotes/origin |
        while read remote_branch; do
            echo "🔅 $remote_branch"
        done
}
alias gitallbranch="git_all_branch"

function calculate_time_diff() {
    local timestamp="$1"
    local current_time=$(date +%s)
    local time_diff=$((current_time - timestamp))

    if [ $time_diff -lt 60 ]; then
        echo "just now"
    elif [ $time_diff -lt 3600 ]; then
        echo "$((time_diff / 60)) minutes ago"
    elif [ $time_diff -lt 86400 ]; then
        echo "$((time_diff / 3600)) hours ago"
    else
        echo "$((time_diff / 86400)) days ago"
    fi
}

# git_all_branch_tz function
# Lists all local and remote Git branches with modified timestamps.
#
# Usage:
#   git_all_branch_tz
#
# Parameters:
#   None.
#
# Description:
#   The 'git_all_branch_tz' function lists all local and remote Git branches
#   along with their last modified timestamps. It uses a custom time format
#   to display the time difference between the current time and the last modification.
#
# Example:
#   git_all_branch_tz
#
# Recommendations:
#   - Use this function to view branches along with their last modification timestamps.
#   - The modified timestamp is presented in a human-readable format.
function git_all_branch_tz() {
    echo "✅ Local branches:"
    git for-each-ref --format='%(refname:short)' refs/heads |
        while read local_branch; do
            branch_date=$(git log -n 1 --format=%cd --date=format:'%s' "$local_branch")
            echo "🔁 $local_branch (🔸 modified_at: $(calculate_time_diff $branch_date))"
        done

    echo "✅ Remote branches:"
    git for-each-ref --format='%(refname:short)' refs/remotes/origin |
        while read remote_branch; do
            branch_date=$(git log -n 1 --format=%cd --date=format:'%s' "$remote_branch")
            echo "🔅 $remote_branch (🔸 modified_at: $(calculate_time_diff $branch_date))"
        done
}
alias gitallbranchtz="git_all_branch_tz"

# git_remove_branches function
# Removes specified Git branches both locally and on the remote repository.
#
# Usage:
#   git_remove_branches <branch_name1> [<branch_name2> ...]
#
# Parameters:
#   <branch_name1>, [<branch_name2>, ...]: Names of the branches to be removed.
#
# Description:
#   The 'git_remove_branches' function deletes the specified branches both
#   locally and on the remote repository. It uses 'git branch -D' to force
#   delete the branches locally and 'git push origin --delete' to delete
#   the branches on the remote repository.
#
# Example:
#   git_remove_branches feature-branch bug-fix
#
# Recommendations:
#   - Use this function to remove one or more branches conveniently.
#   - Be cautious when using this function, as it permanently deletes branches.
function git_remove_branches() {
    if [ $# -eq 0 ]; then
        echo "❌ Error: No branch names provided."
        return 1
    fi

    local current_branch=$(git rev-parse --abbrev-ref HEAD)
    for branch in "$@"; do
        echo "🚀 Removing branch $branch locally..."
        wsd_exe_cmd git branch -D "$branch"

        echo "🚀 Removing branch $branch on remote..."
        wsd_exe_cmd git push origin --delete "$branch"
    done

    wsd_exe_cmd git checkout "$current_branch"
}
alias gitremovebranches="git_remove_branches"

# git_create_branches function
# Creates and switches to new Git branches, and pushes them to the remote repository.
#
# Usage:
#   git_create_branches <branch_name1> [<branch_name2> ...]
#
# Parameters:
#   <branch_name1>, [<branch_name2>, ...]: Names of the branches to be created.
#
# Description:
#   The 'git_create_branches' function creates new branches with the specified names
#   and switches to each of them. It then pushes the newly created branches to the
#   remote repository using 'git checkout -b' and 'git push -u origin'.
#
# Example:
#   git_create_branches feature-branch bug-fix
#
# Recommendations:
#   - Use this function to conveniently create and switch to multiple branches.
#   - Ensure that branch names adhere to Git naming conventions.
#   - Regularly push branches to the remote repository to make them accessible to others.
function git_create_branches() {
    if [ $# -eq 0 ]; then
        echo "❌ Error: No branch names provided."
        return 1
    fi
    local current_branch=$(git rev-parse --abbrev-ref HEAD)
    for branch in "$@"; do
        if ! [[ "$branch" =~ ^[a-zA-Z0-9_-]+$ ]]; then
            echo "❌ Error: Invalid branch name '$branch'. Branch names can only contain letters, numbers, hyphens, and underscores."
            continue
        fi
        echo "🚀 Creating and switching to branch $branch..."
        wsd_exe_cmd git checkout -b "$branch"
        echo "🚀 Pushing branch $branch to remote..."
        wsd_exe_cmd git push -u origin "$branch"
    done
    wsd_exe_cmd git checkout "$current_branch"
}
alias gitcreatebranches="git_create_branches"

# git_fetch_branches function
# Checks out and fetches specified Git branches from the remote repository.
#
# Usage:
#   git_fetch_branches <branch_name1> [<branch_name2> ...]
#
# Parameters:
#   <branch_name1>, [<branch_name2>, ...]: Names of the branches to be fetched.
#
# Description:
#   The 'git_fetch_branches' function checks out each specified branch and fetches
#   it from the remote repository using 'git checkout', 'git fetch --all --tags', and 'git pull -f'.
#
# Example:
#   git_fetch_branches feature-branch bug-fix
#
# Recommendations:
#   - Use this function to efficiently check out and fetch multiple branches.
#   - Ensure that the branches you want to fetch already exist on the remote repository.
#   - Regularly fetch branches to keep the local repository up-to-date.
function git_fetch_branches() {
    if [ $# -eq 0 ]; then
        echo "❌ Error: No branch names provided."
        return 1
    fi
    local current_branch=$(git rev-parse --abbrev-ref HEAD)
    for branch in "$@"; do
        if ! git show-ref --verify --quiet "refs/heads/$branch"; then
            echo "❌ Error: Branch '$branch' does not exist."
            continue
        fi
        echo "🚀 Checking out branch $branch"
        wsd_exe_cmd git fetch --all --tags
        echo "🚀 Fetching branch $branch from remote..."
        wsd_exe_cmd git fetch origin "$branch":"$branch"
        wsd_exe_cmd git checkout "$branch"
        wsd_exe_cmd git pull -f
    done
    wsd_exe_cmd git checkout "$current_branch"
}
alias gitfetchbranches="git_fetch_branches"

# git_files_changed function
# Displays a list of files that have been changed in the Git repository.
#
# Usage:
#   git_files_changed
#
# Parameters:
#   None.
#
# Description:
#   The 'git_files_changed' function uses 'git status --porcelain' to retrieve
#   a list of files with their status indicating whether they have been modified,
#   added, deleted, or have other changes in the working directory.
#
# Example:
#   git_files_changed
#
# Recommendations:
#   - Use this function to quickly identify files with changes in the Git repository.
#   - Check the status of files before committing to ensure you are including the intended changes.
function git_files_changed() {
    wsd_exe_cmd git status --porcelain | awk '{print $2}'
}
alias gitfileschanged="git_files_changed"

# git_files_stage function
# Stages changed files for commit in the Git repository.
#
# Usage:
#   git_files_stage
#
# Parameters:
#   None.
#
# Description:
#   The 'git_files_stage' function iterates over the files that have changes in
#   the working directory (using the 'git_files_changed' function) and prompts the
#   user to stage each file for the next commit. The user can choose to stage or
#   skip each file.
#
# Example:
#   git_files_stage
#
# Recommendations:
#   - Use this function to interactively stage files before committing changes.
#   - Allows fine-grained control over the files to be included in the next commit.
#
# Dependencies:
#   - Requires the 'git_files_changed' function.
function git_files_stage() {
    for file in $(git_files_changed); do
        echo -n "📌 Stage '$file' for commit? (y/n): "
        read answer

        if [[ "$answer" == "y" ]]; then
            wsd_exe_cmd git add "$file"
            echo "✅ '$file' staged."
        elif [[ "$answer" == "n" ]]; then
            echo "🔅 '$file' skipped."
        else
            echo "❌ Invalid input. Skipping '$file'."
        fi
    done
}
alias gitfilesstage="git_files_stage"

# git_latest_tag function
# Displays the latest released tag in the Git repository.
#
# Usage:
#   git_latest_tag
#
# Parameters:
#   None.
#
# Description:
#   The 'git_latest_tag' function retrieves and displays the latest released tag
#   in the repository. It sorts the tags by creation date and selects the top one.
#
# Example:
#   git_latest_tag
#
# Recommendations:
#   - Use this function to quickly find the latest released tag in the repository.
function git_latest_tag() {
    latest_tag=$(wsd_exe_cmd git for-each-ref --sort=-creatordate --format='%(tag)' refs/tags | head -n 1)
    echo "🍺 $latest_tag"
}
alias gitlatesttag="git_latest_tag"

# git_remove_all_tags function
# Removes all local and remote tags in the Git repository.
#
# Usage:
#   git_remove_all_tags
#
# Parameters:
#   None.
#
# Description:
#   The 'git_remove_all_tags' function removes all local and remote tags in the
#   repository. It iterates through the existing tags, deletes them locally,
#   and then removes them from the remote repository.
#
# Example:
#   git_remove_all_tags
#
# Recommendations:
#   - Use this function cautiously as it permanently deletes all tags.
function git_remove_all_tags() {
    # Remove all local tags
    for tag in $(git tag); do
        echo "🚀 Removing local tag $tag..."
        wsd_exe_cmd git tag -d "$tag"
    done
    # Remove all remote tags
    for tag in $(git ls-remote --tags origin | awk -F '/' '{print $3}'); do
        msg="🚀 Removing remote tag $tag..."
        echo "$msg"
        wsd_exe_cmd git push origin :refs/tags/"$tag"
        send_telegram_git_activity "$msg"
    done
}
alias gitremovealltags="git_remove_all_tags"

# git_commit_tempory function
# Creates a temporary commit with a predefined message for pinning the 'committion' tool.
#
# Usage:
#   git_commit_tempory
#
# Parameters:
#   None.
#
# Description:
#   The 'git_commit_tempory' function creates a temporary commit with the
#   message ":ok_hand: chore: pin committion tempory". This commit can be
#   useful when pinning a specific version of the 'committion' tool in the repository.
#
# Example:
#   git_commit_tempory
#
# Recommendations:
#   - Use this function for creating a temporary commit to pin 'committion' or
#     when a temporary commit is needed for other purposes.
function git_commit_tempory() {
    wsd_exe_cmd git commit -m ":ok_hand: chore: pin committion tempory"
}
alias gitcommittempory="git_commit_tempory"

# git_remove_except_local_and_remote_branches function
# Removes local and remote branches except the specified ones.
#
# Usage:
#   git_remove_except_local_and_remote_branches <branch_names...>
#
# Parameters:
#   <branch_names...>: List of branch names to keep. All other branches will be removed.
#
# Description:
#   The 'git_remove_except_local_and_remote_branches' function removes local branches
#   and their corresponding remote branches, except for the branches specified in the
#   parameter list. It is useful for cleaning up branches that are no longer needed.
#
# Example:
#   git_remove_except_local_and_remote_branches main develop feature/cool-feature
#
# Recommendations:
#   - Use this function to clean up branches that are no longer required in both local
#     and remote repositories.
#   - Provide the list of branches you want to keep as parameters to the function.
function git_remove_except_local_and_remote_branches() {
    if [ $# -eq 0 ]; then
        echo "❌ Error: No branch names provided."
        return 1
    fi
    local current_branch=$(git rev-parse --abbrev-ref HEAD)
    # Create an array of branches to keep
    local branches_to_keep=("$@")
    # Loop through all local branches
    for branch in $(git for-each-ref --format '%(refname:short)' refs/heads/); do
        # Check if the current branch is in the list of branches to keep
        if [[ ! " ${branches_to_keep[@]} " =~ " $branch " ]]; then
            # If not, remove the branch locally
            echo "🚀 Removing branch $branch locally..."
            wsd_exe_cmd git branch -D "$branch"

            # Remove the branch on remote
            echo "🚀 Removing branch $branch on remote..."
            wsd_exe_cmd git push origin --delete "$branch"
        fi
    done
    # Switch back to the original branch
    wsd_exe_cmd git checkout "$current_branch"
}
alias gitremoveexceptlocalandremotebranches="git_remove_except_local_and_remote_branches"

# git_fetch_repository function
# Clones a Git repository with the specified URI into a local folder.
#
# Usage:
#   git_fetch_repository <repo_URI> <folder_name>
#
# Parameters:
#   <repo_URI>: The URI of the Git repository to clone.
#   <folder_name>: The name of the local folder to clone the repository into.
#
# Description:
#   The 'git_fetch_repository' function clones a Git repository with the specified URI
#   into a local folder. It uses the 'git clone' command with the '--depth 1' option for
#   a shallow clone, fetching only the latest commit.
#
# Example:
#   git_fetch_repository https://github.com/example/repo.git my_local_repo
#
# Recommendations:
#   - Provide the URI of the Git repository as the first parameter.
#   - Specify the desired local folder name as the second parameter.
#   - Use this function for quickly fetching a Git repository with a shallow clone.
#
# Dependencies:
#   - Git must be installed on the system.
function git_fetch_repository() {
    if [ -z "$1" ] || [ -z "$2" ]; then
        echo "Usage: git_fetch_repository <repo_URI> <folder_name>"
    else
        wsd_exe_cmd git clone --depth 1 "$1" "$2"
    fi
}
alias gitfetchrepository="git_fetch_repository"

# git_push_force function
function git_push_force() {
    wsd_exe_cmd git push -f
}
alias gpf="git_push_force"
alias gitpushforce="git_push_force"

# git_remove_remote_branches_except function
# Removes remote branches except those specified to keep.
#
# Usage:
#   git_remove_remote_branches_except <branch_name1> [<branch_name2> ...]
#
# Parameters:
#   <branch_name1>, <branch_name2>, ...: Names of branches to keep. Other branches will be removed.
#
# Description:
#   The 'git_remove_remote_branches_except' function removes remote branches except for the ones specified
#   to be kept. It fetches all remote branches, identifies the local branch name, and deletes branches
#   that are not in the list of branches to keep.
#
# Example:
#   git_remove_remote_branches_except feature-1 hotfix-2
#
# Recommendations:
#   - Provide the names of the branches to keep as parameters.
#   - Use this function when you want to clean up remote branches, keeping only specific branches.
#
# Dependencies:
#   - Git must be installed on the system.
#
# Note:
#   - The function fetches all remote branches before processing.
function git_remove_remote_branches_except() {
    if [ $# -eq 0 ]; then
        echo "❌ Error: No branch names provided."
        return 1
    fi
    # Create an array of branches to keep
    local branches_to_keep=("$@")
    # Fetch all remote branches
    wsd_exe_cmd git fetch --all
    # Loop through all remote branches
    for remote_branch in $(git branch -r | grep -vE "HEAD|master" | sed 's/origin\///'); do
        # Extract the branch name
        local_branch=$(echo "$remote_branch" | sed 's#origin/##')
        # Check if the branch should be kept
        if [[ ! " ${branches_to_keep[@]} " =~ " $local_branch " ]]; then
            # Remove the branch on remote
            echo "🚀 Removing remote branch $remote_branch..."
            wsd_exe_cmd git push origin --delete "$local_branch"
        fi
    done
}
alias gitremoveremotebranchesexcept="git_remove_remote_branches_except"

# git_count_remote_branch function
# Counts the number of remote branches in the Git repository.
#
# Usage:
#   git_count_remote_branch
#
# Description:
#   The 'git_count_remote_branch' function counts the number of remote branches in the Git repository.
#   It uses the 'git for-each-ref' command to retrieve the list of remote branches and counts the total.
#
# Example:
#   git_count_remote_branch
#
# Recommendations:
#   - Execute the function when you want to know the number of remote branches in the Git repository.
#   - It can be useful for monitoring and reporting purposes.
function git_count_remote_branch() {
    repository_path=$(wsd_exe_cmd git rev-parse --show-toplevel)
    current_repository=$(basename "$repository_path")
    num_remote_branches=$(wsd_exe_cmd git for-each-ref --format='%(refname:short)' refs/remotes/origin | wc -l)
    msg="🍺 Repository: \`$current_repository\`, no. remote branches: $num_remote_branches"
    echo "$msg"
    send_telegram_git_activity "$msg"
}
alias gitcountremotebranch="git_count_remote_branch"

# git_config_enabled_push_auto_setup_remote function
# Enable the 'push.autoSetupRemote' configuration globally in Git.
#
# Usage:
#   git_config_enabled_push_auto_setup_remote
#
# Description:
#   The 'git_config_enabled_push_auto_setup_remote' function enables the 'push.autoSetupRemote'
#   configuration globally in Git. When this configuration is set to 'true', Git automatically
#   configures remote tracking during the creation of a new branch.
function git_config_enabled_push_auto_setup_remote() {
    wsd_exe_cmd git config --global --add --bool push.autoSetupRemote true
}
alias gitconfigenabledpushautosetupremote="git_config_enabled_push_auto_setup_remote"

# git_config_disabled_push_auto_setup_remote function
# Disable the 'push.autoSetupRemote' configuration globally in Git.
#
# Usage:
#   git_config_disabled_push_auto_setup_remote
#
# Description:
#   The 'git_config_disabled_push_auto_setup_remote' function disables the 'push.autoSetupRemote'
#   configuration globally in Git. When this configuration is set to 'false', Git does not
#   automatically configure remote tracking during the creation of a new branch.
function git_config_disabled_push_auto_setup_remote() {
    wsd_exe_cmd git config --global --add --bool push.autoSetupRemote false
}
alias gitconfigdisabledpushautosetupremote="git_config_disabled_push_auto_setup_remote"

# git_log_graph_timestamp function
# Display a decorated Git log with a graph, commit information, and timestamp.
#
# Usage:
#   git_log_graph_timestamp
#
# Description:
#   The 'git_log_graph_timestamp' function displays a Git log with a graph representing commit history,
#   commit hash, branch information, commit message, timestamp, and author information.
function git_log_graph_timestamp() {
    local options="$@"
    wsd_exe_cmd git log --graph --pretty='%Cred%h%Creset -%C(auto)%d%Creset %s %Cgreen(%ar) %C(bold blue)<%an>%Creset' $options
}
alias gitloggraphtimestamp="git_log_graph_timestamp"

# git_log_graph_timestamp_remote function
# Display a graph of the commit history with timestamps, including remote branches.
#
# Usage:
#   git_log_graph_timestamp_remote
#
# Description:
#   The 'git_log_graph_timestamp_remote' function displays a concise graph of the commit history
#   using the 'git log' command. It includes commit timestamps, decorations for branches,
#   and highlights remote branches in the graph.
#
# Options:
#   None
#
# Example usage:
#   Run the 'git_log_graph_timestamp_remote' function to display a graph of the commit history with timestamps.
#
# Instructions:
#   1. Execute the 'git_log_graph_timestamp_remote' function to visualize the commit history graph.
#   2. The output includes commit timestamps, branch decorations, and highlights for remote branches.
#
# Notes:
#   - This function enhances the 'git log' output with timestamps, making it more informative.
#   - Remote branches are highlighted in the graph for better visibility.
function git_log_graph_timestamp_remote() {
    local options="$@"
    wsd_exe_cmd git log --oneline --graph --pretty='%Cred%h%Creset -%C(auto)%d%Creset %s %Cgreen(%ar) %C(bold blue)<%an>%Creset' $options
}
alias gitloggraphtimestampremote="git_log_graph_timestamp_remote"

# git_log_graph_stat function
# Display a decorated Git log with a graph, commit information, timestamp, and file statistics.
#
# Usage:
#   git_log_graph_stat
#
# Description:
#   The 'git_log_graph_stat' function displays a Git log with a graph representing commit history,
#   commit hash, branch information, commit message, timestamp, author information, and file statistics.
function git_log_graph_stat() {
    local options="$@"
    wsd_exe_cmd git log --graph --pretty='%Cred%h%Creset -%C(auto)%d%Creset %s %Cgreen(%ar) %C(bold blue)<%an>%Creset' --stat $options
}
alias gitloggraphstat="git_log_graph_stat"

# git_log_graph_stat_remote function
# Display a graph of the commit history with timestamps, including remote branches, and show file stats.
#
# Usage:
#   git_log_graph_stat_remote
#
# Description:
#   The 'git_log_graph_stat_remote' function displays a concise graph of the commit history
#   using the 'git log' command. It includes commit timestamps, decorations for branches,
#   and highlights remote branches in the graph. Additionally, file statistics are shown for each commit.
#
# Options:
#   None
#
# Example usage:
#   Run the 'git_log_graph_stat_remote' function to display a graph of the commit history with timestamps and file stats.
#
# Instructions:
#   1. Execute the 'git_log_graph_stat_remote' function to visualize the commit history graph.
#   2. The output includes commit timestamps, branch decorations, highlights for remote branches, and file statistics.
#
# Notes:
#   - This function enhances the 'git log' output with timestamps, making it more informative.
#   - Remote branches are highlighted in the graph for better visibility.
#   - File statistics are displayed to show changes in each commit.
function git_log_graph_stat_remote() {
    local options="$@"
    wsd_exe_cmd git log --oneline --graph --pretty='%Cred%h%Creset -%C(auto)%d%Creset %s %Cgreen(%ar) %C(bold blue)<%an>%Creset' --stat $options
}
alias gitloggraphstatremote="git_log_graph_stat_remote"

# git_add_all function
# Add all changes to the Git staging area using 'git add .' command.
#
# Usage:
#   git_add_all
#
# Description:
#   The 'git_add_all' function adds all changes in the working directory to the Git staging area.
#   It is a convenient shortcut for 'git add .' to stage all modifications, additions, and deletions.
#
# Options:
#   None
#
# Example usage:
#   git_add_all
#
# Instructions:
#   1. Run the 'git_add_all' function to stage all changes in the working directory.
#
# Notes:
#   - This function simplifies the process of staging changes before committing.
#   - Ensure you have the necessary permissions and are in a valid Git repository.
#
# Dependencies:
#   - Git must be installed and initialized in the current working directory.
function git_add_all() {
    wsd_exe_cmd git add .
}
alias gitaddall="git_add_all"
alias gitstageall="git_add_all"
alias gaa="git_add_all"
alias ga="git_add_all"

# git_remote_set_url function
# Set the URL of the remote repository for the current Git repository.
#
# Usage:
#   git_remote_set_url <url>
#
# Parameters:
#   - <url>: The new URL to set for the remote repository.
#
# Description:
#   The 'git_remote_set_url' function updates the URL of the remote repository associated
#   with the current Git repository. It uses the 'git remote set-url' command for this purpose.
#
# Options:
#   - <url>: The new URL to set for the remote repository.
#
# Example usage:
#   git_remote_set_url https://github.com/example/repo.git
#
# Instructions:
#   1. Execute 'git_remote_set_url' with the new URL as a parameter to update the remote repository URL.
#
# Notes:
#   - This function is useful when you need to change the remote repository URL for a Git repository.
function git_remote_set_url() {
    if [ $# -lt 1 ]; then
        echo "Usage: git_remote_set_url <url>"
        return 1
    fi
    wsd_exe_cmd git remote set-url "$1"
}
alias gitremoteseturl="git_remote_set_url"

function git_whatchanged() {
    wsd_exe_cmd git whatchanged -p --abbrev-commit --pretty=medium
}
# Aliases
# (sorted alphabetically)
# https://gist.github.com/mkczyk/646b69f85f0214f813d3a3da951d7df2
alias gs="git status"
alias gsb='git status -sb'
alias gss='git status -s'
alias gwch="git_whatchanged"
alias gitwhatchangedmedium="gwch"
alias grba='git rebase --abort'
alias gitrebaseabort="grba"
alias grbc='git rebase --continue'
alias gitrebasecontinue="grbc"
alias grv='git remote -v'
alias gitremoteversion="grv"
alias ggsup='git branch --set-upstream-to=origin/$(git_current_branch)'
alias gitbranchsetupstreamorgincurrent="ggsup"
alias gpsup='git push --set-upstream origin $(git_current_branch)'
alias gitpushsetupstreamorigincurrent="gpsup"
alias ggpull='git pull origin "$(git_current_branch)"'
alias gitpullorigincurrent="ggpull"
alias ggpush='git push origin "$(git_current_branch)"'
alias gitpushorigincurrent="ggpush"
alias gcp='git cherry-pick'
alias gitcherrypick="gcp"
alias gcpa='git cherry-pick --abort'
alias gitcherrypickabort="gcpa"
alias gcpc='git cherry-pick --continue'
alias gitcherrypickcontinue="gcpc"
alias gcam="git commit -a -m $@" # Add all new files and commit changes with message description.
alias gitcommitmessage="gcam"

# git_select_cherry_pick_local function
# Select and cherry-pick commits from the Git history.
#
# Usage:
#   git_select_cherry_pick_local
#
# Description:
#   The 'git_select_cherry_pick_local' function allows interactive selection of commits from the Git history
#   using 'fzf'. Selected commits are then cherry-picked into the current branch.
#
# Instructions:
#   1. Run 'git_select_cherry_pick_local'.
#   2. Use 'fzf' to select one or more commits from the Git history.
#   3. The selected commits will be cherry-picked into the current branch.
#
# Notes:
#   - Ensure that 'fzf' is installed for proper functionality.
#   - Uncomment the 'wsd_exe_cmd git cherry-pick $commit' line within the loop to actually cherry-pick the selected commits.
function git_select_cherry_pick_local() {
    local commits=$(git log --graph --decorate --format=format:'%C(bold blue)%H%C(reset) - %C(bold green)(%ar)%C(reset) %C(white)%an%C(reset)%C(bold yellow)%d%C(reset) %C(dim white)- %s%C(reset)' | fzf -m --reverse)
    if [ -n "$commits" ]; then
        local commit_hashes=$(echo "$commits" | awk '{print $2}')
        for commit in $commit_hashes; do
            echo "$commit"
            wsd_exe_cmd git cherry-pick $commit
        done
    fi
}
alias gscplc="git_select_cherry_pick_local"
alias gitselectcherrypicklocal="git_select_cherry_pick_local"

function git_select_cherry_pick_remote() {
    local commits=$(git log --oneline --graph --decorate --format=format:'%C(bold blue)%H%C(reset) - %C(bold green)(%ar)%C(reset) %C(white)%an%C(reset)%C(bold yellow)%d%C(reset) %C(dim white)- %s%C(reset)' | fzf -m --reverse)
    if [ -n "$commits" ]; then
        local commit_hashes=$(echo "$commits" | awk '{print $2}')
        for commit in $commit_hashes; do
            echo "$commit"
            wsd_exe_cmd git cherry-pick $commit
        done
    fi
}
alias gscpr="git_select_cherry_pick_remote"
alias gitselectcherrypickremote="git_select_cherry_pick_remote"
