echo "🚀 Upgrading wsdkit..."
sudo rm -rf wsdkit
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/pnguyen215/wsdkit/master/install.sh)"
echo "🍺 wsdkit has been successfully upgraded. Please restart your terminal or run 'source ~/.zshrc' to apply changes."
