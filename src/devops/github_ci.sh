# github_add_ci function
# Add GitHub Actions workflow for CI.
#
# Usage:
#   github_add_ci
#
# Description:
#   The 'github_add_ci' function downloads a GitHub Actions workflow file (ci.yml) and saves it to the specified location.
#
# Example usage:
#   github_add_ci
#
# Instructions:
#   1. Run 'github_add_ci' to download the GitHub Actions workflow file for CI.
#   2. The workflow file (ci.yml) will be saved to the '.github/workflows/' directory.
#
# Notes:
#   - Ensure that 'curl' is installed for proper functionality.
#   - The URL points to the specific 'ci.yml' file in the 'wsdkit.keys' repository on GitHub.
function github_add_ci() {
    download_file ".github/workflows/ci.yml" "https://raw.githubusercontent.com/pnguyen215/wsdkit.keys/master/devops/github_workflow/ci.yml"
}
alias githubaddci="github_add_ci"

# github_add_ci_notify function
# Add GitHub Actions workflow for CI with notifications.
#
# Usage:
#   github_add_ci_notify
#
# Description:
#   The 'github_add_ci_notify' function downloads a GitHub Actions workflow file (ci_notify.yml) with notifications
#   and saves it to the specified location.
#
# Options:
#   None
#
# Example usage:
#   github_add_ci_notify
#
# Instructions:
#   1. Run 'github_add_ci_notify' to download the GitHub Actions workflow file for CI with notifications.
#   2. The workflow file (ci_notify.yml) will be saved to the '.github/workflows/' directory.
#
# Notes:
#   - Ensure that 'curl' is installed for proper functionality.
#   - The URL points to the specific 'ci_notify.yml' file in the 'wsdkit.keys' repository on GitHub.
function github_add_ci_notify() {
    download_file ".github/workflows/ci_notify.yml" "https://raw.githubusercontent.com/pnguyen215/wsdkit.keys/master/devops/github_workflow/ci_notify.yaml"
}
alias githubaddcinotify="github_add_ci_notify"
