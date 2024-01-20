# add_github_go_ci function
# Add GitHub Actions workflow and changelog script for Go projects.

# Usage:
#   add_github_go_ci

# Description:
#   The 'add_github_go_ci' function downloads a GitHub Actions workflow file (ci.yml) and a Git changelog script,
#   specifically designed for Go projects. It saves these files to the specified locations.

# Options:
#   None

# Example usage:
#   add_github_go_ci

# Instructions:
#   1. Run 'add_github_go_ci' to download the GitHub Actions workflow file and Git changelog script.
#   2. The workflow file (ci.yml) will be saved to the '$github_workflow_conf' directory.
#   3. The changelog script will be saved to the current directory.

# Notes:
#   - Ensure that 'curl' is installed for proper functionality.
#   - The URLs point to specific files in the 'wsdkit.keys' repository on GitHub.
function add_github_go_ci() {
    local filename_ci="$github_workflow_conf/ci.yml"
    local filename_changelog="git_changelog.sh"
    download_file "$filename_ci" https://raw.githubusercontent.com/pnguyen215/wsdkit.keys/master/devops/github_go_workflow.yml
    download_file "$filename_changelog" "https://raw.githubusercontent.com/pnguyen215/wsdkit.keys/master/sh/git_changelog.sh"
}
alias addgithubgoci="add_github_go_ci"
