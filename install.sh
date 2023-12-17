#!/bin/bash
echo "🚀 Installing wsdkit..."

# Specify the GitHub repository owner and name
owner="pnguyen215"
wsdkit_repository="wsdkit"
wsdkit_mark="$wsdkit_repository-master"

# Try fetching the latest release information using GitHub API
wsdkit_release_url=$(curl -s "https://api.github.com/repos/$owner/$wsdkit_repository/releases/latest")

# Extract the download URL for the source code zip file
wsdkit_zip_url=$(echo "$wsdkit_release_url" | grep -o '"browser_download_url": ".*wsdkit.*.zip"' | cut -d'"' -f4)

if [ -z "$wsdkit_zip_url" ]; then
    echo "🚨 Latest release not found. Downloading from the master branch."
    wsdkit_zip_url="https://github.com/$owner/$wsdkit_repository/archive/master.zip"
fi

# Specify the installation directory
wsdkit_wrk="$HOME/wsdkit"

# Download the repository as a zip file
curl -LJO "$wsdkit_zip_url"

# Extract the contents of the zip file directly into the install directory
unzip -o "$wsdkit_mark.zip" -d "$wsdkit_wrk"

# Adjusted the directory structure to avoid nested wsdkit directory
mv "$wsdkit_wrk/$wsdkit_mark"/* "$wsdkit_wrk/"

# Remove the unnecessary nested wsdkit directory
rmdir "$wsdkit_wrk/$wsdkit_mark"

# Add command to .zshrc if not already present
line="source $wsdkit_wrk/src/wsdkit.sh"
zshrc="$HOME/.zshrc"

if ! grep -q "$line" "$zshrc"; then
    echo "✅ wsdkit added to .zshrc"
    echo "$line" >>"$zshrc"
else
    echo "🚨 wsdkit already exists in .zshrc"
fi

# Clean up: remove the downloaded zip file
rm "$wsdkit_mark.zip"

echo "🍺 wsdkit has been successfully installed. Please restart your terminal or run 'source ~/.zshrc' to apply changes."
