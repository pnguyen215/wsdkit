# Main function to set up zshrc
setup_zshrc() {
    echo "Setting up zshrc..."

    # Check if zsh is already installed
    if [ -z "$(command -v zsh)" ]; then
        echo "Zsh not found. Installing..."
        # # Check the OS and call the appropriate function
        if [ "$(uname)" == "Darwin" ]; then
            # install_zsh_macos
            echo "Core MacOS"
        elif [ "$(expr substr $(uname -s) 1 5)" == "Linux" ]; then
            # install_zsh_ubuntu
            echo "Core Linux"
        else
            echo "Unsupported operating system. Please install zsh manually."
            exit 1
        fi
    else
        echo "Zsh is already installed."
    fi

    # Check if oh-my-zsh is already installed
    # if [ ! -d "$HOME/.oh-my-zsh" ]; then
    #     echo "Oh-my-zsh not found. Installing..."
    #     sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
    # else
    #     echo "Oh-my-zsh is already installed."
    # fi

    # Copy the custom zshrc file to the home directory
    # cp zshrc_custom.zshrc "$HOME/.zshrc"

    echo "zshrc setup complete!"
}

# Call the main setup function
setup_zshrc