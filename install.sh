#!/bin/bash
echo "🚀 Installing wsdkit..."

# Specify the GitHub repository owner and name
owner="pnguyen215"
repository="wsdkit"
mark="$repository-master"

# Try fetching the latest release information using GitHub API
release_info=$(curl -s "https://api.github.com/repos/$owner/$repository/releases/latest")

# Extract the download URL for the source code zip file
zip_url=$(echo "$release_info" | grep -o '"browser_download_url": ".*wsdkit.*.zip"' | cut -d'"' -f4)

if [ -z "$zip_url" ]; then
    echo "🚨 Latest release not found. Downloading from the master branch."
    zip_url="https://github.com/$owner/$repository/archive/master.zip"
fi

# Specify the installation directory
install_dir="$HOME/wsdkit"

# Download the repository as a zip file
curl -LJO "$zip_url"

# Extract the contents of the zip file directly into the install directory
unzip -o "$mark.zip" -d "$install_dir"

# Adjusted the directory structure to avoid nested wsdkit directory
mv "$install_dir/$mark"/* "$install_dir/"

# Remove the unnecessary nested wsdkit directory
rmdir "$install_dir/$mark"

# Add command to .zshrc if not already present
line="source $install_dir/src/wsdkit.sh"
zshrc="$HOME/.zshrc"

if ! grep -q "$line" "$zshrc"; then
    echo "✅ wsdkit added to .zshrc"
    echo "$line" >>"$zshrc"
else
    echo "🚨 wsdkit already exists in .zshrc"
fi

# Clean up: remove the downloaded zip file
rm "$mark.zip"

# Adjust paths in wsdkit.sh for the moved files
# sed -i "" "s|source src/brew.sh|source $install_dir/src/brew.sh|" "$install_dir/src/wsdkit.sh"
# sed -i "" "s|source src/plugins.sh|source $install_dir/src/plugins.sh|" "$install_dir/src/wsdkit.sh"

echo "🍺 wsdkit has been successfully installed. Please restart your terminal or run 'source ~/.zshrc' to apply changes."
