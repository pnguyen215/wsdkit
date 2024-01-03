# is_nvm_installed function
# Check if Node Version Manager (NVM) is installed and configured.
#
# Usage:
#   is_nvm_installed
#
# Description:
#   The 'is_nvm_installed' function checks if Node Version Manager (NVM) is installed and properly configured.
#   It verifies the presence of the NVM directory and the 'nvm.sh' script within it.
#
# Example usage:
#   is_nvm_installed
#
# Instructions:
#   1. Run 'is_nvm_installed' to check if NVM is installed and configured.
#   2. The function returns 0 if NVM is installed and configured, and 1 otherwise.
#
# Notes:
#   - Make sure that the 'NVM_DIR' environment variable is set, indicating the NVM directory.
#   - The function checks for the existence and non-empty status of the 'nvm.sh' script.
#   - NVM (Node Version Manager) is a tool for managing multiple Node.js versions.
# function is_nvm_installed() {
#     command -v nvm >/dev/null 2>&1
# }
function is_nvm_installed() {
    if [ -z "${NVM_DIR}" ]; then
        return 1
    elif [ ! -s "${NVM_DIR}/nvm.sh" ]; then
        return 1
    else
        return 0
    fi
}

# install_nvm function
# Install Node Version Manager (NVM) on the system.
#
# Usage:
#   install_nvm
#
# Description:
#   The 'install_nvm' function downloads and installs Node Version Manager (NVM) on the system.
#   It fetches the installation script from the official NVM repository and executes it using bash.
#   After installation, it sources the 'nvm.sh' script to make NVM available in the current session.
#
# Options:
#   None
#
# Example usage:
#   install_nvm
#
# Instructions:
#   1. Run 'install_nvm' to install Node Version Manager (NVM).
#   2. The function downloads and executes the NVM installation script.
#   3. After installation, the 'nvm.sh' script is sourced to make NVM available in the current session.
#
# Notes:
#   - Ensure that 'curl' is installed on the system for fetching the NVM installation script.
#   - NVM (Node Version Manager) is a tool for managing multiple Node.js versions.
function install_nvm() {
    wsd_exe_cmd curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.1/install.sh | bash
    wsd_exe_cmd source "$HOME/.nvm/nvm.sh"
}

# uninstall_nvm_if_needed function
# Uninstall Node Version Manager (NVM) if it is already installed on the system.
#
# Usage:
#   uninstall_nvm_if_needed
#
# Description:
#   The 'uninstall_nvm_if_needed' function checks if NVM is installed by calling the 'is_nvm_installed' function.
#   If NVM is installed, it proceeds to uninstall it by removing the '.nvm' directory and cleaning up the shell
#   configuration files ('.bashrc' and '.zshrc') of any NVM-related configurations.
#
# Options:
#   None
#
# Example usage:
#   uninstall_nvm_if_needed
#
# Instructions:
#   1. Run 'uninstall_nvm_if_needed' to uninstall Node Version Manager (NVM) if it is already installed.
#   2. The function checks for NVM installation using the 'is_nvm_installed' function.
#   3. If NVM is installed, it removes the '.nvm' directory and cleans up shell configuration files.
#
# Notes:
#   - Ensure that 'sudo' permissions are available for removing directories and updating configuration files.
#   - This function is useful for cleanup before reinstallation or when switching to a different Node.js version manager.
function uninstall_nvm_if_needed() {
    if is_nvm_installed; then
        echo "🚀 Uninstalling nvm..."
        wsd_exe_cmd sudo rm -rf "$HOME/.nvm"
        sed -i.bak '/export NVM_DIR/d' "$HOME/.bashrc"
        sed -i.bak '/export NVM_DIR/d' "$HOME/.zshrc"
        sed -i.bak '/# Homebrew Utility Functions/d' "$HOME/.zprofile"
        echo "🍺 nvm uninstalled successfully!"
    else
        echo "🍺 nvm is not installed. Nothing to uninstall."
    fi
}

# install_nvm_if_needed function
# Install Node Version Manager (NVM) if it is not already installed on the system.
#
# Usage:
#   install_nvm_if_needed
#
# Description:
#   The 'install_nvm_if_needed' function checks if NVM is installed by calling the 'is_nvm_installed' function.
#   If NVM is not installed, it proceeds to install it using the 'install_nvm' function.
#
# Options:
#   None
#
# Example usage:
#   install_nvm_if_needed
#
# Instructions:
#   1. Run 'install_nvm_if_needed' to install Node Version Manager (NVM) if it is not already installed.
#   2. The function checks for NVM installation using the 'is_nvm_installed' function.
#   3. If NVM is not installed, it calls the 'install_nvm' function to perform the installation.
#
# Notes:
#   - The 'install_nvm' function is used internally to fetch and install NVM.
#   - This function is useful for ensuring that NVM is available on the system before using it for managing Node.js versions.
function install_nvm_if_needed() {
    if ! is_nvm_installed; then
        echo "🚀 Installing nvm..."
        install_nvm
        echo "🍺 nvm installed successfully! $(echo $NVM_DIR)"
    else
        echo "🍺 nvm already installed successfully! $(echo $NVM_DIR)"
    fi
}

# nvm_node_versions function
# List available Node.js versions using Node Version Manager (NVM).
#
# Usage:
#   nvm_node_versions
#
# Description:
#   The 'nvm_node_versions' function checks if NVM is installed by calling the 'is_nvm_installed' function.
#   If NVM is installed, it fetches and lists the remote Node.js versions using the 'nvm ls-remote' command.
#   If NVM is not installed, it displays an error message prompting the user to install NVM first.
#
# Example usage:
#   nvm_node_versions
#
# Instructions:
#   1. Run 'nvm_node_versions' to list available Node.js versions using NVM.
#   2. Ensure that NVM is installed by calling 'install_nvm_if_needed' if necessary.
#   3. The function fetches and displays the remote Node.js versions available for installation.
#
# Notes:
#   - This function requires NVM to be installed on the system.
#   - It provides a convenient way to view available Node.js versions before installing or switching versions.
function nvm_node_versions() {
    if is_nvm_installed; then
        echo "🚀 Fetching remote Node.js versions..."
        wsd_exe_cmd nvm ls-remote
    else
        echo "❌ nvm is not installed. Please install nvm first."
    fi
}
