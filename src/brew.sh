# Homebrew Utility Functions
# These functions provide utility for checking and installing Homebrew and managing Homebrew packages.

# Check if Homebrew is installed
function is_homebrew_installed() {
  command -v brew >/dev/null 2>&1
}

# Check if a package is installed with Homebrew
function is_homebrew_pkg_installed() {
  if [ $# -lt 1 ]; then
    echo "Usage: is_homebrew_pkg_installed <package_name>"
    return 1
  fi
  local pkg="$1"
  brew list "$pkg" >/dev/null 2>&1
  return $?
}

# Install Homebrew
function install_homebrew() {
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
}

# Install a package with Homebrew
function install_homebrew_pkg() {
  if [ $# -lt 1 ]; then
    echo "Usage: install_homebrew_pkg <package_name>"
    return 1
  fi
  local pkg="$1"
  brew install "$pkg"
}

# Example usages:
# Check if Homebrew is installed
# if is_homebrew_installed; then
#     echo "Homebrew is installed."
# else
#     echo "Homebrew is not installed."
#     # Uncomment the line below to install Homebrew if not already installed
#     # install_homebrew
# fi

# Check if a specific Homebrew package is installed
# if is_homebrew_pkg_installed "package_name"; then
#     echo "The package is installed."
# else
#     echo "The package is not installed."
#     # Uncomment the line below to install the package if not already installed
#     # install_homebrew_pkg "package_name"
# fi
