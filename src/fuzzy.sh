# fzf_git_add function
# Interactively select and add modified or untracked files to the Git staging area using fzf.
#
# Usage:
#   fzf_git_add
#
# Description:
#   The 'fzf_git_add' function leverages fzf, a command-line fuzzy finder, to interactively select files that have been modified or are untracked in the Git repository.
#   This function lists the modified and untracked files using 'git ls-files -m -o --exclude-standard' and allows the user to select files using an fzf interface.
#   It provides a preview of the file differences for modified files using 'git diff' and a preview of the file content for untracked files using 'bat'.
#   Once selections are made, the function stages the selected files using 'git add'.
#
# Parameters:
#   - None
#
# Example:
#   fzf_git_add
#
# Recommendations:
#   - Ensure you have 'fzf' and 'bat' installed for the best experience.
#   - Use this function to efficiently stage specific changes interactively.
#
# Dependencies:
#   - fzf: Command-line fuzzy finder.
#   - bat: A cat clone with syntax highlighting (optional, but provides better previews).
#   - git: Distributed version control system.
fzf_git_add() {
    local selections=$(
        git ls-files -m -o --exclude-standard |
            fzf --ansi \
                --preview 'if (git ls-files --error-unmatch {1} &>/dev/null); then
                           git diff --color=always {1}
                       else
                           bat --color=always --line-range :500 {1}
                       fi'
    )
    if [[ -n $selections ]]; then
        git add --verbose $selections
    fi
}
alias gadd='fzf_git_add'

# fzf_git_log function
# Interactively browse and view detailed information about Git commits using fzf.
#
# Usage:
#   fzf_git_log
#
# Description:
#   The 'fzf_git_log' function utilizes fzf to provide an interactive interface for browsing the Git commit history.
#   It displays the commit log graph with commit hashes, refs, relative dates, commit messages, and authors using 'git log'.
#   The commits are listed with color formatting to enhance readability.
#   The function allows the user to select a commit interactively and view its detailed information using 'git show'.
#   The selected commit is identified and its details are displayed in the terminal.
#
# Parameters:
#   - None
#
# Example:
#   fzf_git_log
#
# Recommendations:
#   - Ensure you have 'fzf' installed for the interactive selection.
#   - Use this function to quickly navigate and inspect specific commits in the Git history.
#
# Dependencies:
#   - fzf: Command-line fuzzy finder.
#   - git: Distributed version control system.
fzf_git_log() {
    local selection=$(
        git log --graph --format="%C(yellow)%h%C(red)%d%C(reset) - %C(bold green)(%ar)%C(reset) %s %C(blue)<%an>%C(reset)" --color=always "$@" |
            fzf --no-multi --ansi --no-sort --no-height \
                --preview "echo {} | grep -o '[a-f0-9]\{7\}' | head -1 |
                       xargs -I@ sh -c 'git show --color=always @'"
    )
    if [[ -n $selection ]]; then
        local commit=$(echo "$selection" | sed 's/^[* |]*//' | awk '{print $1}' | tr -d '\n')
        git show $commit
    fi
}
alias gll='fzf_git_log'

# fzf_git_reflog function
# Interactively browse and view detailed information about Git reflog entries using fzf.
#
# Usage:
#   fzf_git_reflog
#
# Description:
#   The 'fzf_git_reflog' function utilizes fzf to provide an interactive interface for browsing the Git reflog.
#   It displays the reflog entries with color formatting to enhance readability using 'git reflog'.
#   The function allows the user to select a reflog entry interactively and view its detailed information using 'git show'.
#   The selected reflog entry is identified and its details are displayed in the terminal.
#
# Parameters:
#   - None
#
# Example:
#   fzf_git_reflog
#
# Recommendations:
#   - Ensure you have 'fzf' installed for the interactive selection.
#   - Use this function to quickly navigate and inspect specific reflog entries to understand recent changes in the repository.
#
# Dependencies:
#   - fzf: Command-line fuzzy finder.
#   - git: Distributed version control system.
fzf_git_reflog() {
    local selection=$(
        git reflog --color=always "$@" |
            fzf --no-multi --ansi --no-sort --no-height \
                --preview "git show --color=always {1}"
    )
    if [[ -n $selection ]]; then
        git show $(echo $selection | awk '{print $1}')
    fi
}
alias grl='fzf_git_reflog'

# fzf_kill_ssh function
# Interactively select and kill SSH tunnel forwarding processes using fzf.
#
# Usage:
#   fzf_kill_ssh
#
# Description:
#   The 'fzf_kill_ssh' function leverages fzf, a command-line fuzzy finder, to interactively select SSH tunnel forwarding processes to kill.
#   It lists the active SSH processes with port forwarding options using 'ps aux', filters them, and allows the user to select a process using fzf.
#   The selected process ID (PID) is then terminated using the 'kill' command.
#
# Parameters:
#   - None
#
# Example:
#   fzf_kill_ssh
#
# Recommendations:
#   - Ensure you have 'fzf' installed for the interactive selection.
#   - Use this function to efficiently terminate specific SSH tunnel forwarding sessions.
#
# Dependencies:
#   - fzf: Command-line fuzzy finder.
function fzf_kill_ssh() {
    local selection=$(
        ps aux | grep ssh | grep -v grep | grep -E '\-L|\-R|\-D' |
            fzf --no-multi --ansi --no-sort --no-height \
                --preview 'echo {} | awk "{print \$2, \$11, \$12, \$13, \$14}"'
    )
    if [[ -n $selection ]]; then
        local pid=$(echo "$selection" | awk '{print $2}')
        kill -9 $pid
        echo "Killed SSH process with PID: $pid"
    fi
}
alias kssh="fzf_kill_ssh"
