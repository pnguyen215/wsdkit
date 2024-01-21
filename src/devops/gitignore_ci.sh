# gitignore_go_gen function
# Generate a .gitignore file tailored for Go projects.
#
# Usage:
#   gitignore_go_gen
#
# Description:
#   The 'gitignore_go_gen' function downloads a .gitignore file specifically designed for Go projects
#   and saves it to the specified location.
#
# Options:
#   None
#
# Example usage:
#   gitignore_go_gen
#
# Instructions:
#   1. Run 'gitignore_go_gen' to download the .gitignore file tailored for Go projects.
#   2. The .gitignore file will be saved as '.gitignore' in the project root directory.
#
# Notes:
#   - Ensure that 'curl' is installed for proper functionality.
#   - The URL points to the specific 'go_gitignore.txt' file in the 'wsdkit.keys' repository on GitHub.
function gitignore_go_gen() {
    download_file ".gitignore" "https://raw.githubusercontent.com/pnguyen215/wsdkit.keys/master/gitignores/go_gitignore.txt"
}
alias gitignoregogen="gitignore_go_gen"
