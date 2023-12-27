# add_secret function
# Add or update a secret key-value pair in a secret configuration file.
#
# Usage:
#   add_secret
#
# Description:
#   The 'add_secret' function interactively prompts the user to enter a key and value pair,
#   which is then appended to a secret configuration file. The secret file is created if it
#   doesn't exist. This function is useful for managing sensitive information securely.
# Instructions:
#   1. Run the 'add_secret' function.
#   2. Enter a key when prompted.
#   3. Enter a corresponding value when prompted.
#   4. The key-value pair is added or updated in the secret configuration file.
#
# Notes:
#   - The secret configuration file is specified by the variable 'filename_secret_conf'.
#   - Modify 'filename_secret_conf' to set the desired location of the secret file.
#
# Dependencies:
#   - create_file_if_not_exists (ensure the existence of the secret configuration file)
function add_secret() {
    local key=""
    local value=""
    # Set key
    while [ -z "$key" ]; do
        echo -n "Enter key: "
        read key
        if [ -z "$key" ]; then
            echo "❌ Invalid key. Please try again."
        fi
    done
    # Set value
    while [ -z "$value" ]; do
        echo -n "Enter value: "
        read value
        if [ -z "$value" ]; then
            echo "❌ Invalid value. Please try again."
        fi
    done

    # Check if the secret file exists, create it if not
    create_file_if_not_exists "$filename_secret_conf"
    allow_full_perm "$filename_secret_conf"

    # Add or update the secret in the file
    echo "$key=$value" >>"$filename_secret_conf"
    echo "🔐 Secret added or updated for key: $key"
}
alias addsecret="add_secret"

# get_secret function
# Retrieve the value associated with a given key from a secret configuration file.
#
# Usage:
#   get_secret <key>
#
# Description:
#   The 'get_secret' function retrieves the value associated with a specified key from
#   a secret configuration file. If the key is found, the corresponding value is echoed,
#   and the function returns successfully. If the key is not found or the secret file
#   does not exist, an error message is displayed, and the function returns an error.
#
# Options:
#   <key> - The key for which to retrieve the value.
#
# Example usage:
#   Uncomment the line below to execute the 'get_secret' function for a specific key.
#   get_secret "example_key"
#
# Instructions:
#   1. Run the 'get_secret' function with the desired key.
#   2. The function will display the value associated with the specified key if found.
#   3. If the key is not found or the secret file does not exist, an error message is shown.
#
# Notes:
#   - The secret configuration file is specified by the variable 'filename_secret_conf'.
#   - Modify 'filename_secret_conf' to set the desired location of the secret file.
#
# Dependencies:
#   - None
#
# Example:
#   get_secret "example_key"
function get_secret() {
    if [ $# -lt 1 ]; then
        echo "Usage: get_secret <key>"
        return ""
    fi
    local key="$1"
    local value

    # Check if the secret file exists
    if [ -e "$filename_secret_conf" ]; then
        value=$(grep "^$key=" "$filename_secret_conf" | cut -d "=" -f2)
        if [ -n "$value" ]; then
            echo "$value"
        else
            echo "❌ Key '$key' not found in secrets file."
            return 1
        fi
    else
        echo "❌ Secrets file not found. No secrets available."
        return 1
    fi
}
alias getsecre="get_secret"

# get_secret_noop function
# Dummy function to demonstrate the usage of the 'get_secret' function.
#
# Usage:
#   get_secret_noop
#
# Description:
#   The 'get_secret_noop' function is a dummy function intended for demonstration purposes.
#   It prompts the user to enter a key, retrieves the associated value using the 'get_secret'
#   function, and echoes the result. This function can be used as an example of integrating
#   the 'get_secret' function into a more comprehensive script.
# Example usage:
#   Uncomment the line below to execute the 'get_secret_noop' function.
#   get_secret_noop
#
# Instructions:
#   1. Run the 'get_secret_noop' function.
#   2. Enter the desired key when prompted.
#   3. The function will display the associated value retrieved using the 'get_secret' function.
#
# Notes:
#   - This function is intended for demonstration and testing purposes.
#   - It depends on the 'get_secret' function to retrieve secret values.
#
# Dependencies:
#   - get_secret function
function get_secret_noop() {
    local key=""
    while [ -z "$key" ]; do
        echo -n "Enter key: "
        read key
        if [ -z "$key" ]; then
            echo "❌ Invalid key. Please try again."
        fi
    done
    value=$(get_secret "$key")
    echo "🍺🍺 val: " $value
}
alias getsecretnoop="get_secret_noop"

# delete_secret function
# Delete a secret identified by a specified key from the secrets configuration file.
#
# Usage:
#   delete_secret <key>
#
# Parameters:
#   <key> - The key associated with the secret to be deleted.
#
# Description:
#   The 'delete_secret' function removes a secret entry from the secrets configuration file
#   based on the specified key. It prompts the user to enter a key, and then deletes the
#   associated secret from the configuration file. The original file is backed up before
#   modification.
#
# Instructions:
#   1. Run the 'delete_secret' function with the desired key as a parameter.
#   2. The function will prompt for confirmation before deleting the secret.
#   3. The secret associated with the specified key will be removed from the configuration file.
#
# Notes:
#   - This function modifies the secrets configuration file.
#   - It creates a backup of the original file before making changes.
#
# Dependencies:
#   - create_file_if_not_exists function
#   - allow_full_perm function
#
# Example:
#   delete_secret my_secret_key
function delete_secret() {
    if [ $# -lt 1 ]; then
        echo "Usage: delete_secret <key>"
        return 1
    fi
    local key="$1"

    # Check if the secret file exists, create it if not
    create_file_if_not_exists "$filename_secret_bak_conf"
    allow_full_perm "$filename_secret_bak_conf"
    allow_full_perm "$filename_secret_conf"

    # Check if the secret file exists
    if [ -e "$filename_secret_conf" ]; then
        wsd_exe_cmd sudo sed -i.bak "/^$key=/d" "$filename_secret_conf"
        echo "🗑️ Secret deleted for key: $key"
    else
        echo "❌ Secrets file not found. No secrets to delete."
    fi
}
alias deletesecret="delete_secret"

# delete_secret_noop function
# Delete a secret interactively, prompting the user to enter the key.
#
# Usage:
#   delete_secret_noop
#
# Parameters:
#   None
#
# Description:
#   The 'delete_secret_noop' function provides an interactive way to delete a secret.
#   It prompts the user to enter a key, and then calls the 'delete_secret' function to
#   delete the associated secret from the configuration file.
#
# Example usage:
#   delete_secret_noop
#
# Instructions:
#   1. Run the 'delete_secret_noop' function.
#   2. The function will prompt for a key to identify the secret to be deleted.
#   3. The associated secret will be removed from the configuration file.
#
# Notes:
#   - This function relies on the 'delete_secret' function.
#
# Dependencies:
#   - delete_secret function
function delete_secret_noop() {
    local key=""
    while [ -z "$key" ]; do
        echo -n "Enter key: "
        read key
        if [ -z "$key" ]; then
            echo "❌ Invalid key. Please try again."
        fi
    done
    delete_secret "$key"
}
alias deletesecretnoop="delete_secret_noop"

# get_all_secret function
# Retrieve all secrets from the configuration file.
#
# Usage:
#   get_all_secret
#
# Parameters:
#   None
#
# Description:
#   The 'get_all_secret' function retrieves and displays all secrets stored in the configuration file.
#
# Instructions:
#   1. Run the 'get_all_secret' function.
#   2. All secrets stored in the configuration file will be displayed.
#
# Notes:
#   - This function reads and prints all secrets from the configuration file.
function get_all_secret() {
    if [ -e "$filename_secret_conf" ]; then
        wsd_exe_cmd cat $filename_secret_conf
    else
        echo "❌ Secrets file not found. No secrets to delete."
    fi
}
alias getallsecret="get_all_secret"

# read_conf function
# Reads and sources the content of configuration file.
#
# Usage:
#   read_conf <filename>
#
# Description:
#   The 'read_conf' function reads and sources the content of configuration file specified by the <filename> parameter.
#   This function is useful for dynamically loading configurations from a file.
#
# Parameters:
#   - filename: The path to the configuration file.
#
# Example:
#   read_conf ~/.ssh/config
#
# Recommendations:
#   - Ensure the specified file contains valid configuration directives.
#   - Use this function to load configurations dynamically based on different scenarios.
#
# Dependencies:
#   - None
function read_conf() {
    if [ $# -lt 1 ]; then
        echo "Usage: read_conf <filename>"
        return 1
    fi
    local filename="$1"

    if [[ ! -f "$filename" ]]; then
        echo "❌ Error: Conf file '$filename' not found."
        return 1
    fi

    wsd_exe_cmd source "$filename"
}
alias readconf="read_conf"

# add_conf function
# Utility function to add or update key-value pairs in a configuration file.
#
# Usage:
#   add_conf <key> <value> <filename>
#
# Parameters:
#   <key>      - Key for the configuration entry.
#   <value>    - Value associated with the key.
#   <filename> - Path to the configuration file.
#
# Description:
#   The 'add_conf' function allows the user to interactively enter a key,
#   value, and filename to add or update a key-value pair in a configuration
#   file.
#
# Example usage:
#   add_conf my_key my_value /path/to/config.conf
#
# Instructions:
#   1. Run 'add_conf' with the desired key, value, and filename.
#   2. Enter the key when prompted.
#   3. Enter the value when prompted.
#   4. Enter the filename when prompted.
#
# Notes:
#   - This function is useful for maintaining configuration files where new
#     entries need to be added or existing entries updated.
#
# Example:
#   add_conf server_port 8080 /etc/myapp/config.conf
function add_conf() {
    if [ $# -lt 3 ]; then
        echo "Usage: add_conf <key> <value> <filename>"
        return 1
    fi
    local key="$1"
    local value="$2"
    local filename="$3"

    # Set key
    while [ -z "$key" ]; do
        echo -n "Enter key: "
        read key
        if [ -z "$key" ]; then
            echo "❌ Invalid key. Please try again."
        fi
    done
    # Set value
    while [ -z "$value" ]; do
        echo -n "Enter value: "
        read value
        if [ -z "$value" ]; then
            echo "❌ Invalid value. Please try again."
        fi
    done
    # Set filename
    while [ -z "$filename" ]; do
        echo -n "Enter filename: "
        read filename
        if [ -z "$filename" ]; then
            echo "❌ Invalid filename. Please try again."
        fi
    done
    # Check if the secret file exists, create it if not
    create_file_if_not_exists "$filename"
    allow_full_perm "$filename"

    echo "$key=$value" >>"$filename"
    echo "🔐 Secret added/updated for key: $key"
}
alias addconf="add_conf"
