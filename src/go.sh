# go_privates function
# Display the GOPRIVATE setting for Go modules.
#
# Usage:
#   go_privates
#
# Parameters:
#   None
#
# Description:
#   The 'go_privates' function prints the current value of the GOPRIVATE environment variable,
#   which is used to specify a comma-separated list of modules that should be considered private.
#   This setting influences how Go commands interact with version control systems when downloading dependencies.
#
# Options:
#   None
#
# Example usage:
#   go_privates
#
# Instructions:
#   1. Run 'go_privates' to display the current GOPRIVATE setting.
#
# Notes:
#   - The GOPRIVATE environment variable is used by Go tools to determine whether to use authenticated
#     access when downloading certain modules.
function go_privates() {
    local p=$(go env GOPRIVATE)
    echo "$p"
}
alias goprivates="go_privates"

# go_set_private function
# Set the GOPRIVATE environment variable for Go modules.
#
# Usage:
#   go_set_private <repository1> [repository2] [repository3] ...
#
# Parameters:
#   - <repository1>: The first repository to add to GOPRIVATE.
#   - [repository2] [repository3] ...: Additional repositories to add to GOPRIVATE.
#
# Description:
#   The 'go_set_private' function sets the GOPRIVATE environment variable, which is used to specify
#   a comma-separated list of modules that should be considered private. This setting influences how Go
#   commands interact with version control systems when downloading dependencies.
#
# Options:
#   None
#
# Example usage:
#   go_set_private example.com/private1 example.com/private2
#
# Instructions:
#   1. Run 'go_set_private' with the repositories you want to mark as private.
#   2. The function will set the GOPRIVATE environment variable for the specified repositories.
#
# Notes:
#   - The GOPRIVATE environment variable is used by Go tools to determine whether to use authenticated
#     access when downloading certain modules.
function go_set_private() {
    if [ $# -lt 1 ]; then
        echo "Usage: go_set_private <repository1> [repository2] [repository3] ..."
        return 1
    fi

    local repositories=("$@")
    local repositories_by_comma=$(
        IFS=,
        echo "${repositories[*]}"
    )
    local command="go env -w GOPRIVATE=$repositories_by_comma"

    eval "$command"
}
alias gosetprivate="go_set_private"

# go_gen_app function
# Generate a new Go application using the specified name or GitHub URL.
#
# Usage:
#   go_gen_app <name/github_url>
#
# Parameters:
#   - <name/github_url>: The name of the new Go application or the GitHub URL to clone.
#
# Description:
#   The 'go_gen_app' function creates a new Go application by initializing a Go module with the
#   specified name or GitHub URL. It uses 'go mod init' to initialize the module and 'go mod tidy'
#   to clean up any dependencies.
#
# Options:
#   None
#
# Example usage:
#   go_gen_app myapp
#   go_gen_app github.com/example/myapp
#
# Instructions:
#   1. Run 'go_gen_app' with the desired name or GitHub URL.
#   2. The function will create a new Go module and tidy up the dependencies.
#
# Notes:
#   - If a GitHub URL is provided, the function removes "http://" or "https://" and trailing slashes.
#   - The 'go mod init' command initializes a new Go module, and 'go mod tidy' cleans up dependencies.
function go_gen_app() {
    if [ $# -eq 0 ]; then
        echo "Usage: go_gen_app <name/github_url>"
        return 1
    fi
    local app_name="$1"
    # Check if the input contains "github.com"
    if [[ $app_name == *github.com* ]]; then
        # Remove "http://" or "https://" from the GitHub URL if present
        app_name="${app_name#http://}"
        app_name="${app_name#https://}"
        # Remove trailing slashes
        app_name="${app_name%/}"
    fi

    # Create a new Go module
    wsd_exe_cmd go mod init $app_name
    wsd_exe_cmd touch ".gitignore"
    create_file_if_not_exists ".github/workflows/.gitkeep"
    create_file_if_not_exists ".github/workflows/ci.yml"
    allow_execute_perm ".github/workflows/ci.yml"
    gitignore_go_gen
    github_add_go_ci
    echo "Go application $app_name created with go mod tidy!"
}
alias gogenapp="go_gen_app"

# go_make_boilerplate function
# Download and extract a Go project boilerplate from a predefined GitHub repository.
#
# Usage:
#   go_make_boilerplate <app_name>
#
# Parameters:
#   - <app_name>: The name of the new Go application.
#
# Description:
#   The 'go_make_boilerplate' function downloads a predefined Go project boilerplate from a
#   GitHub repository and extracts it to the specified directory. It utilizes 'curl' to download
#   the boilerplate zip file, 'unzip' to extract it, and 'code .' to open the project in Visual Studio Code.
#
# Options:
#   None
#
# Example usage:
#   go_make_boilerplate myapp
#
# Instructions:
#   1. Run 'go_make_boilerplate' with the desired app_name.
#   2. The function will download the Go project boilerplate, extract it, and open it in Visual Studio Code.
#
# Notes:
#   - The boilerplate is downloaded from a predefined GitHub repository.
function go_make_boilerplate() {
    if [ -z "$1" ]; then
        echo "Usage: go_make_boilerplate <app_name>"
        return 1
    fi

    local app_name="$1"
    local zip_url="$github_golang_template_repository"
    local zip_file="${app_name}_gocell.zip"
    local temp_dir=$(mktemp -d)

    echo "🚀 Downloading $app_name from $zip_url..."
    wsd_exe_cmd curl -L -o "$zip_file" "$zip_url"

    echo "🚀 Extracting $zip_file to $temp_dir..."
    wsd_exe_cmd unzip "$zip_file" -d "$temp_dir"

    local target_dir="$(pwd)/$app_name"
    wsd_exe_cmd mv "$temp_dir/gocell-master" "$target_dir"

    echo "🚀 Cleaning up..."
    wsd_exe_cmd rm "$zip_file"
    wsd_exe_cmd rmdir "$temp_dir"

    echo "🍺 Downloaded $app_name to $target_dir"
    wsd_exe_cmd cd "$target_dir"
    wsd_exe_cmd code .
}
alias gomakeboilerplate="go_make_boilerplate"
