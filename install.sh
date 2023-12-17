#!/bin/bash
echo "🚀 Installing wsdkit..."

# Specify the GitHub repository owner and name
owner="pnguyen215"
repo="wsdkit"

# Try fetching the latest release information using GitHub API
release_info=$(curl -s "https://api.github.com/repos/$owner/$repo/releases/latest")

# Extract the download URL for the source code zip file
zip_url=$(echo "$release_info" | grep -o '"browser_download_url": ".*wsdkit.*.zip"' | cut -d'"' -f4)

if [ -z "$zip_url" ]; then
    echo "🚨 Latest release not found. Downloading from the master branch."
    zip_url="https://github.com/$owner/$repo/archive/master.zip"
fi

# Specify the installation directory
install_dir="$HOME/wsdkit"

# Download the repository as a zip file
curl -LJO "$zip_url"

# Extract the contents of the zip file
unzip -o "wsdkit-master.zip" -d "$install_dir"

# Add command to .zshrc if not already present
command_to_add="source $install_dir/src/wsdkit.sh"
zshrc="$HOME/.zshrc"

if ! grep -q "$command_to_add" "$zshrc"; then
    echo "✅ Command added to .zshrc"
    echo "$command_to_add" >>"$zshrc"
else
    echo "🚨 Command already exists in .zshrc"
fi

# Clean up: remove the downloaded zip file
rm "wsdkit-master.zip"

echo "🍺 wsdkit has been successfully installed. Please restart your terminal or run 'source ~/.zshrc' to apply changes."
