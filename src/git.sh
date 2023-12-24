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
alias gituser="git_user_info_setting"

function git_info_global_setting() {
    wsd_exe_cmd git config --global --list
}
alias gitglobalsettings="git_info_global_setting"

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
    # Use 'git log' with options for graphical and decorated output
    wsd_exe_cmd git log --graph --decorate --format=format:'%C(bold blue)%h%C(reset) - %C(bold green)(%ar)%C(reset) %C(white)%an%C(reset)%C(bold yellow)%d%C(reset) %C(dim white)- %s%C(reset)' --all $options
}
alias gitloggraph="git_log_graph"

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
