echo "🚀 Upgrading wsdkit..."
sudo rm -rf wsdkit
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/pnguyen215/wsdkit/master/install.sh)"
source ~/.zshrc
