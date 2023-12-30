# Show PIDs by SSH tunnel forwarding
function ssh_list_forwarding() {
    echo "🍺 SSH tunnels forwarding:"
    # ps aux | grep ssh | grep -v grep | grep -E '\-L|\-R|\-D' | awk '{printf "%-10s %-10s %-20s %-20s %-20s\n", $2, $11, $12, $13, $14}'
    wsd_exe_cmd ps aux | grep ssh | grep -v grep | grep -E '\-L|\-R|\-D' | awk 'BEGIN {printf "%-10s %-10s %-20s %-20s %-20s %-10s %-20s %-20s %-20s\n", "PID", "USER", "START", "TIME", "COMMAND", "LOCAL_PORT", "FORWARD_TYPE", "REMOTE_PORT", "REMOTE_HOST"} {printf "%-10s %-10s %-20s %-20s %-20s %-10s %-20s %-20s %-20s\n", $2, $1, $9, $10, $11, $12, $13, $14, $15}'
}
# Alias to show all jobs running
alias sshlistforwarding="ssh_list_forwarding"

# read_ssh_conf function
# Reads and sources the content of an SSH configuration file.
#
# Usage:
#   read_ssh_conf <filename>
#
# Description:
#   The 'read_ssh_conf' function reads and sources the content of an SSH configuration file specified by the <filename> parameter.
#   This function is useful for dynamically loading SSH configurations from a file.
#
# Parameters:
#   - filename: The path to the SSH configuration file.
#
# Example:
#   read_ssh_conf ~/.ssh/config
#
# Recommendations:
#   - Ensure the specified file contains valid SSH configuration directives.
#   - Use this function to load SSH configurations dynamically based on different scenarios.
#
# Dependencies:
#   - None
function read_ssh_conf() {
    if [ $# -lt 1 ]; then
        echo "Usage: read_ssh_conf <filename>"
        return 1
    fi
    local filename="$1"

    if [[ ! -f "$filename" ]]; then
        echo "❌ Error: Conf file '$filename' not found."
        return 1
    fi

    wsd_exe_cmd source "$filename"
}
alias readsshconf="read_ssh_conf"

# ssh_create_tunnel function
# Creates an SSH tunnel based on the configurations specified in an SSH configuration file.
#
# Usage:
#   ssh_create_tunnel <filename>
#
# Description:
#   The 'ssh_create_tunnel' function reads SSH configurations from the specified <filename> using the 'read_ssh_conf' function.
#   It then establishes an SSH tunnel based on the configured parameters.
#   Note: Modify the SSH tunneling command to suit your specific requirements.
#
# Parameters:
#   - filename: The path to the SSH configuration file.
#
# Example:
#   ssh_create_tunnel ~/.ssh/config
#
# Recommendations:
#   - Ensure the specified file contains valid SSH configuration directives.
#   - Adjust the SSH tunneling command according to your tunneling needs.
#   - Execute this function in a background process to run the tunnel in the background.
#
# Dependencies:
#   - read_ssh_conf function
function ssh_create_tunnel() {
    if [ $# -lt 1 ]; then
        echo "Usage: ssh_create_tunnel <filename>"
        return 1
    fi
    local filename="$1"
    read_ssh_conf "$filename"
    echo "🚀 SSH tunnel for '$ssh_name' connecting"
    # Modify this line according to your SSH tunnel requirements
    wsd_exe_cmd ssh -i "\"$ssh_filename_rsa\"" -N -L "$local_port:$remote_host:$remote_port" "$ssh_user@$ssh_host" -p "$ssh_port" &
}
alias sshcreatetunnel="ssh_create_tunnel"

# ssh_bind_tunnel function
# Utility function to bind an SSH tunnel using a specified configuration file.
#
# Usage:
#   ssh_bind_tunnel <filename>
#
# Parameters:
#   <filename> - Name of the SSH forward configuration file.
#
# Description:
#   The 'ssh_bind_tunnel' function reads the specified SSH forward configuration
#   file and binds an SSH tunnel using the provided information. It also adds
#   the RSA key to the SSH agent.
#
# Example usage:
#   ssh_bind_tunnel my_forward_config.conf
#
# Instructions:
#   1. Run 'ssh_bind_tunnel' with the filename of the SSH forward configuration.
#   2. The function reads the configuration file and establishes an SSH tunnel.
#   3. The RSA key associated with the tunnel is added to the SSH agent.
#
# Notes:
#   - This function simplifies the process of binding an SSH tunnel using a
#     preconfigured configuration file.
function ssh_bind_tunnel() {
    if [ $# -lt 1 ]; then
        echo "Usage: ssh_bind_tunnel <filename>"
        return 1
    fi
    local filename="$1"
    eval "$(ssh-agent -s)"
    read_ssh_conf "$filename"
    echo "🚀 SSH tunnel for '$ssh_name' binding"
    # Modify this line according to your SSH tunnel requirements
    wsd_exe_cmd ssh-add -K "\"$ssh_filename_rsa\""
}
alias sshbindtunnel="ssh_bind_tunnel"

# ssh_verify_tunnel function
# Verifies the SSH tunnel connectivity based on the configurations specified in an SSH configuration file.
#
# Usage:
#   ssh_verify_tunnel <filename>
#
# Description:
#   The 'ssh_verify_tunnel' function reads SSH configurations from the specified <filename> using the 'read_ssh_conf' function.
#   It then attempts to establish an SSH connection to verify the tunnel connectivity.
#   Note: Modify the SSH connection command to suit your specific requirements.
#
# Parameters:
#   - filename: The path to the SSH configuration file.
#
# Example:
#   ssh_verify_tunnel ~/.ssh/config
#
# Recommendations:
#   - Ensure the specified file contains valid SSH configuration directives.
#   - Adjust the SSH connection command according to your verification needs.
#   - Execute this function to verify the connectivity of an existing SSH tunnel.
#
# Dependencies:
#   - read_ssh_conf function
function ssh_verify_tunnel() {
    if [ $# -lt 1 ]; then
        echo "Usage: ssh_verify_tunnel <filename>"
        return 1
    fi
    local filename="$1"
    read_ssh_conf "$filename"
    echo "🚀 SSH tunnel for '$ssh_name' verifying"
    # Modify this line according to your SSH tunnel requirements
    wsd_exe_cmd ssh -i "\"$ssh_filename_rsa\"" "$ssh_user@$ssh_host" -p "$ssh_port"
}
alias sshverifytunnel="ssh_verify_tunnel"

# ssh_gen_key function
# Generate an SSH key pair with the specified email and optional key name.
#
# Usage:
#   ssh_gen_key <email> [key_name]
#
# Parameters:
#   <email>: Email address associated with the SSH key.
#   [key_name]: (Optional) Name of the SSH key files (default: id_rsa).
#
# Description:
#   The 'ssh_gen_key' function generates an SSH key pair using the ssh-keygen tool.
#   It creates both private and public key files in the ~/.ssh directory.
#
# Options:
#   - <email>: Specify the email address associated with the SSH key.
#   - [key_name]: (Optional) Specify a custom name for the SSH key files. Defaults to 'id_rsa'.
function ssh_gen_key() {
    if [ $# -lt 1 ]; then
        echo "Usage: ssh_gen_key <email> [key_name]"
        return 1
    fi
    local email="$1"
    local key_name="${2:-id_rsa}"
    local key_filename="$HOME/.ssh/${key_name}"
    echo "🚀 Generating SSH key pair for '$email' with the name '$key_name'..."
    wsd_exe_cmd ssh-keygen -t rsa -b 4096 -C "$email" -f "$key_filename"
    echo "🍺 SSH key pair generated successfully."
    echo "ℹ️ Public key: ${key_filename}.pub"
    echo "⚠️ Keep your private key (${key_filename}) secure."
}
alias sshgenkey="ssh_gen_key"

# ssh_all_keys function
# List all SSH keys in the user's ~/.ssh directory.
#
# Usage:
#   ssh_all_keys
#
# Description:
#   The 'ssh_all_keys' function lists all SSH keys present in the user's ~/.ssh directory.
#   It displays detailed information about each key, including file permissions, owner, group, and modification time.
function ssh_all_keys() {
    ls_files "$HOME/.ssh/"
}
alias sshallkeys="ssh_all_keys"

# ssh_gen_forward_conf function
# Utility function to generate an SSH forward configuration file.
#
# Usage:
#   ssh_gen_forward_conf <filename.ext>
#
# Parameters:
#   <filename.ext> - Name of the configuration file to be generated.
#
# Description:
#   The 'ssh_gen_forward_conf' function interactively collects information
#   required for creating an SSH forward configuration file and saves it to
#   the specified file.
#
# Example usage:
#   ssh_gen_forward_conf my_forward_config.conf
#
# Instructions:
#   1. Run 'ssh_gen_forward_conf' with the desired filename.
#   2. Enter the necessary information when prompted.
#
# Notes:
#   - This function helps streamline the creation of SSH forward configurations
#     by guiding the user through the required parameters.
function ssh_gen_forward_conf() {
    if [ $# -lt 1 ]; then
        echo "Usage: ssh_gen_forward_conf <new_filename.ext>"
        return 1
    fi

    local filename="$1"
    local file_rsa=""
    local ssh_desc=""
    local ssh_host=""
    local ssh_port=""
    local ssh_user=""
    local local_port=""
    local remote_host=""
    local remote_port=""

    # filename SSH rsa
    while [ -z "$file_rsa" ]; do
        echo -n "Enter file path's SSH rsa (private): "
        read file_rsa
        if [ -z "$file_rsa" ]; then
            echo "❌ Invalid SSH rsa (private). Please try again."
        fi
    done

    # SSH desc
    while [ -z "$ssh_desc" ]; do
        echo -n "Enter SSH desc: "
        read ssh_desc
        if [ -z "$ssh_desc" ]; then
            echo "❌ Invalid SSH desc. Please try again."
        fi
    done

    # SSH host
    while [ -z "$ssh_host" ]; do
        echo -n "Enter SSH host (public): "
        read ssh_host
        if [ -z "$ssh_host" ]; then
            echo "❌ Invalid SSH host. Please try again."
        fi
    done

    # SSH port
    while [ -z "$ssh_port" ]; do
        echo -n "Enter SSH port (public): "
        read ssh_port
        if [ -z "$ssh_port" ]; then
            echo "❌ Invalid SSH port. Please try again."
        fi
    done

    # SSH user
    while [ -z "$ssh_user" ]; do
        echo -n "Enter SSH user: "
        read ssh_user
        if [ -z "$ssh_user" ]; then
            echo "❌ Invalid SSH user. Please try again."
        fi
    done

    # local port
    while [ -z "$local_port" ]; do
        echo -n "Enter local port (binding): "
        read local_port
        if [ -z "$local_port" ]; then
            echo "❌ Invalid local port. Please try again."
        fi
    done

    # remote host
    while [ -z "$remote_host" ]; do
        echo -n "Enter remote host (server localhost): "
        read remote_host
        if [ -z "$remote_host" ]; then
            echo "❌ Invalid remote host. Please try again."
        fi
    done

    # remote port
    while [ -z "$remote_port" ]; do
        echo -n "Enter remote port (server localhost): "
        read remote_port
        if [ -z "$remote_port" ]; then
            echo "❌ Invalid remote port. Please try again."
        fi
    done

    # added double quotes
    file_rsa="\"$file_rsa\""
    ssh_desc="\"$ssh_desc\""
    ssh_host="\"$ssh_host\""
    ssh_port="\"$ssh_port\""
    ssh_user="\"$ssh_user\""
    local_port="\"$local_port\""
    remote_host="\"$remote_host\""
    remote_port="\"$remote_port\""

    #  base file path
    local base="$filename_ssh_forward_base_conf/$filename"
    # key/value
    add_conf "ssh_filename_rsa" "$file_rsa" "$base"
    add_conf "ssh_name" "$ssh_desc" "$base"
    add_conf "ssh_host" "$ssh_host" "$base"
    add_conf "ssh_port" "$ssh_port" "$base"
    add_conf "ssh_user" "$ssh_user" "$base"
    add_conf "local_port" "$local_port" "$base"
    add_conf "remote_host" "$remote_host" "$base"
    add_conf "remote_port" "$remote_port" "$base"

    # finalize, path file conf
    echo "🍺 $base"
}
alias sshgenforwardconf="ssh_gen_forward_conf"

# ssh_edit_sfc function
# Open the directory containing SSH forward configuration files using the 'editor' function.
#
# Usage:
#   ssh_edit_sfc
#
# Description:
#   The 'ssh_edit_sfc' function provides a convenient way to open the directory containing SSH
#   forward configuration files using the 'editor' function. It uses the 'editor' function, which
#   allows you to select a file from the specified folder interactively.
#
# Options:
#   None
#
# Example usage:
#   ssh_edit_sfc
#
# Instructions:
#   1. Run the 'ssh_edit_sfc' function.
#   2. Use 'fzf' to select a configuration file from the SSH forward configuration directory.
#   3. Choose an action (text editor) to open the selected configuration file.
#
# Note:
#   - Ensure that the 'editor' function and 'fzf' are installed for proper functionality.
#   - The 'editor' function supports the following text editors: cat, less, more, vim, nano.
#
# Dependencies:
#   - editor function
function ssh_edit_sfc() {
    ide "$filename_ssh_forward_base_conf"
}
alias ssheditsfc="ssh_edit_sfc"

# ssh_sync_forward_conf function
# Synchronize a specified SSH configuration file to the SSH forward configuration directory.
#
# Usage:
#   ssh_sync_forward_conf <filename>
#
# Parameters:
#   - <filename>: The name of the SSH configuration file to synchronize.
#
# Description:
#   The 'ssh_sync_forward_conf' function moves the specified SSH configuration file to the SSH forward
#   configuration directory. It uses the 'move_file' function to perform the synchronization operation.
#
# Options:
#   - <filename>: The name of the SSH configuration file to be synchronized.
#
# Example usage:
#   ssh_sync_forward_conf example_ssh_config.conf
#
# Instructions:
#   1. Run the 'ssh_sync_forward_conf' function with the name of the SSH configuration file to be synchronized.
#   2. The function will move the specified file to the SSH forward configuration directory.
#
# Notes:
#   - Ensure that the 'move_file' function is correctly configured and that the specified SSH configuration file exists.
#
# Dependencies:
#   - move_file function
function ssh_sync_forward_conf() {
    if [ $# -lt 1 ]; then
        echo "Usage: ssh_sync_forward_conf <filename>"
        return 1
    fi
    move_file "$1" "$filename_ssh_forward_base_conf"
}
alias sshsyncforwardconf="ssh_sync_forward_conf"

# ssh_select_and_create_tunnel function
# Select an SSH configuration file from the SSH forward configuration directory and create an SSH tunnel.
#
# Usage:
#   ssh_select_and_create_tunnel
#
# Description:
#   The 'ssh_select_and_create_tunnel' function provides an interactive way to select an SSH configuration
#   file from the SSH forward configuration directory using 'fzf'. Once selected, it invokes the 'ssh_create_tunnel'
#   function to create an SSH tunnel using the chosen configuration.
#
# Options:
#   None
#
# Example usage:
#   Run the 'ssh_select_and_create_tunnel' function interactively to choose an SSH configuration and create a tunnel.
#
# Instructions:
#   1. Execute the 'ssh_select_and_create_tunnel' function.
#   2. Use 'fzf' to select an SSH configuration file from the SSH forward configuration directory.
#   3. The chosen configuration will be used to create an SSH tunnel using the 'ssh_create_tunnel' function.
#
# Notes:
#   - Ensure that the 'fzf' command-line fuzzy finder is installed for proper functionality.
#   - The 'ssh_create_tunnel' function is called to establish an SSH tunnel with the selected configuration.
#
# Dependencies:
#   - fzf
#   - ssh_create_tunnel function
function ssh_select_and_create_tunnel() {
    local selected_file
    selected_file=$(ls "$filename_ssh_forward_base_conf" | fzf --prompt="Select SSH Conf: ")

    if [ -z "$selected_file" ]; then
        echo "❌ No file selected. Exiting."
        return 1
    fi

    echo "🚀 Creating SSH tunnel using selected: $selected_file"
    ssh_create_tunnel "$filename_ssh_forward_base_conf/$selected_file"
}
alias sshselectcreatetunnel="ssh_select_and_create_tunnel"
