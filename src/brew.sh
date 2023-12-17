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
