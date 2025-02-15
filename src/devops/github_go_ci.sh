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
    download_file ".github/workflows/ci.yml" "https://raw.githubusercontent.com/pnguyen215/wsdkit.keys/master/devops/github_workflow/go/go_ci.yml"
    download_file ".github/workflows/ci_notify.yml" "https://raw.githubusercontent.com/pnguyen215/wsdkit.keys/master/devops/github_workflow/ci_notify.yml"
    download_file "sh/git_changelog.sh" "https://raw.githubusercontent.com/pnguyen215/wsdkit.keys/master/sh/git_changelog.sh"
    download_file "sh/go_deps.sh" "https://raw.githubusercontent.com/pnguyen215/wsdkit.keys/master/sh/go/go_deps.sh"
    download_file "docs/RELEASE.md" "https://raw.githubusercontent.com/pnguyen215/wsdkit.keys/master/docs/RELEASE.md"
    download_file "Makefile" "https://raw.githubusercontent.com/pnguyen215/wsdkit.keys/master/cmd/go/Makefile"
}
alias githubaddgoci="github_add_go_ci"
