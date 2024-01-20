# github_add_go_ci function
# Add GitHub Actions workflow and changelog script for Go projects.

# Usage:
#   github_add_go_ci

# Description:
#   The 'github_add_go_ci' function downloads a GitHub Actions workflow file (ci.yml) and a Git changelog script,
#   specifically designed for Go projects. It saves these files to the specified locations.

# Options:
#   None

# Example usage:
#   github_add_go_ci

# Instructions:
#   1. Run 'github_add_go_ci' to download the GitHub Actions workflow file and Git changelog script.
#   2. The workflow file (ci.yml) will be saved to the '$github_workflow_conf' directory.
#   3. The changelog script will be saved to the current directory.

# Notes:
#   - Ensure that 'curl' is installed for proper functionality.
#   - The URLs point to specific files in the 'wsdkit.keys' repository on GitHub.
function github_add_go_ci() {
    download_file ".github/workflows/ci.yml" "https://raw.githubusercontent.com/pnguyen215/wsdkit.keys/master/devops/github_workflow/ci.yml"
    download_file "git_changelog.sh" "https://raw.githubusercontent.com/pnguyen215/wsdkit.keys/master/sh/git_changelog.sh"
}
alias githubaddgoci="github_add_go_ci"
