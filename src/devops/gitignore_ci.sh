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

# gitignore_java_gen function
# Generate a .gitignore file tailored for Java projects.
#
# Usage:
#   gitignore_java_gen
#
# Description:
#   The 'gitignore_java_gen' function downloads a .gitignore file specifically designed for Java projects
#   and saves it to the specified location.
#
# Options:
#   None
#
# Example usage:
#   gitignore_java_gen
#
# Instructions:
#   1. Run 'gitignore_java_gen' to download the .gitignore file tailored for Java projects.
#   2. The .gitignore file will be saved as '.gitignore' in the project root directory.
#
# Notes:
#   - Ensure that 'curl' is installed for proper functionality.
#   - The URL points to the specific 'java_gitignore.txt' file in the 'wsdkit.keys' repository on GitHub.
function gitignore_java_gen() {
    download_file ".gitignore" "https://raw.githubusercontent.com/pnguyen215/wsdkit.keys/master/gitignores/java_gitignore.txt"
}
alias gitignorejavagen="gitignore_java_gen"

# gitignore_angular_gen function
# Generate a .gitignore file tailored for Angular projects.
#
# Usage:
#   gitignore_angular_gen
#
# Description:
#   The 'gitignore_angular_gen' function downloads a .gitignore file specifically designed for Angular projects
#   and saves it to the specified location.
#
# Options:
#   None
#
# Example usage:
#   gitignore_angular_gen
#
# Instructions:
#   1. Run 'gitignore_angular_gen' to download the .gitignore file tailored for Angular projects.
#   2. The .gitignore file will be saved as '.gitignore' in the project root directory.
#
# Notes:
#   - Ensure that 'curl' is installed for proper functionality.
#   - The URL points to the specific 'angular_gitignore.txt' file in the 'wsdkit.keys' repository on GitHub.
function gitignore_angular_gen() {
    download_file ".gitignore" "https://raw.githubusercontent.com/pnguyen215/wsdkit.keys/master/gitignores/angular_gitignore.txt"
}
alias gitignoreangulargen="gitignore_angular_gen"

# gitignore_nodejs_gen function
# Generate a .gitignore file tailored for Node.js projects.
#
# Usage:
#   gitignore_nodejs_gen
#
# Description:
#   The 'gitignore_nodejs_gen' function downloads a .gitignore file specifically designed for Node.js projects
#   and saves it to the specified location.
#
# Options:
#   None
#
# Example usage:
#   gitignore_nodejs_gen
#
# Instructions:
#   1. Run 'gitignore_nodejs_gen' to download the .gitignore file tailored for Node.js projects.
#   2. The .gitignore file will be saved as '.gitignore' in the project root directory.
#
# Notes:
#   - Ensure that 'curl' is installed for proper functionality.
#   - The URL points to the specific 'node.js_gitignore.txt' file in the 'wsdkit.keys' repository on GitHub.
function gitignore_nodejs_gen() {
    download_file ".gitignore" "https://raw.githubusercontent.com/pnguyen215/wsdkit.keys/master/gitignores/node.js_gitignore.txt"
}
alias gitignorenodejsgen="gitignore_nodejs_gen"

# gitignore_python_gen function
# Generate a .gitignore file for Python projects.
#
# Usage:
#   gitignore_python_gen
#
# Description:
#   The 'gitignore_python_gen' function downloads a .gitignore template specifically tailored for Python projects.
# Instructions:
#   - Run the 'gitignore_python_gen' function.
#   - It automatically downloads the Python-specific .gitignore file.
#   - The generated .gitignore file will be placed in the current directory.
#
# Dependencies:
#   - 'curl' command-line tool for downloading files.
#
# Notes:
#   - Ensure you have write permissions in the current directory.
#   - The generated .gitignore file is suitable for Python projects.
function gitignore_python_gen() {
    download_file ".gitignore" "https://raw.githubusercontent.com/pnguyen215/wsdkit.keys/master/gitignores/python3_gitignore.txt"
}
alias gitignorepythongen="gitignore_python_gen"
