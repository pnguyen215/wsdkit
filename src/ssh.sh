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

# create_ssh_tunnel function
# Creates an SSH tunnel based on the configurations specified in an SSH configuration file.
#
# Usage:
#   create_ssh_tunnel <filename>
#
# Description:
#   The 'create_ssh_tunnel' function reads SSH configurations from the specified <filename> using the 'read_ssh_conf' function.
#   It then establishes an SSH tunnel based on the configured parameters.
#   Note: Modify the SSH tunneling command to suit your specific requirements.
#
# Parameters:
#   - filename: The path to the SSH configuration file.
#
# Example:
#   create_ssh_tunnel ~/.ssh/config
#
# Recommendations:
#   - Ensure the specified file contains valid SSH configuration directives.
#   - Adjust the SSH tunneling command according to your tunneling needs.
#   - Execute this function in a background process to run the tunnel in the background.
#
# Dependencies:
#   - read_ssh_conf function
function create_ssh_tunnel() {
    if [ $# -lt 1 ]; then
        echo "Usage: create_ssh_tunnel <filename>"
        return 1
    fi

    local filename="$1"
    read_ssh_conf "$filename"
    echo "🚀 SSH tunnel for '$ssh_name' connecting"
    # Modify this line according to your SSH tunnel requirements
    wsd_exe_cmd ssh -i "$ssh_filename_rsa" -N -L "$local_port:$remote_host:$remote_port" "$ssh_user@$ssh_host" -p "$ssh_port" &
}
alias createsshtunnel="create_ssh_tunnel"

# verify_ssh_tunnel function
# Verifies the SSH tunnel connectivity based on the configurations specified in an SSH configuration file.
#
# Usage:
#   verify_ssh_tunnel <filename>
#
# Description:
#   The 'verify_ssh_tunnel' function reads SSH configurations from the specified <filename> using the 'read_ssh_conf' function.
#   It then attempts to establish an SSH connection to verify the tunnel connectivity.
#   Note: Modify the SSH connection command to suit your specific requirements.
#
# Parameters:
#   - filename: The path to the SSH configuration file.
#
# Example:
#   verify_ssh_tunnel ~/.ssh/config
#
# Recommendations:
#   - Ensure the specified file contains valid SSH configuration directives.
#   - Adjust the SSH connection command according to your verification needs.
#   - Execute this function to verify the connectivity of an existing SSH tunnel.
#
# Dependencies:
#   - read_ssh_conf function
function verify_ssh_tunnel() {
    if [ $# -lt 1 ]; then
        echo "Usage: verify_ssh_tunnel <filename>"
        return 1
    fi
    local filename="$1"
    read_ssh_conf "$filename"
    echo "🚀 SSH tunnel for '$ssh_name' verifying"
    # Modify this line according to your SSH tunnel requirements
    wsd_exe_cmd ssh "$ssh_user@$ssh_host" -p "$ssh_port" &
}
alias verifysshtunnel="verify_ssh_tunnel"
