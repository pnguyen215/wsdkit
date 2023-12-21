# Secrets Management Bash Functions
# These functions provide basic secret management capabilities, allowing users to add, retrieve, and delete secrets stored in a file.

# add_secret function
# add or update a secret
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
    [ -e "$filename_secret_conf" ] || touch "$filename_secret_conf"

    # Add or update the secret in the file
    echo "$key=$value" >>"$filename_secret_conf"
    echo "🔐 Secret added or updated for key: $key"
}

# Retrieve a secret by key
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

# get_secret_noop function
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

# Delete a secret by key
function delete_secret() {
    if [ $# -lt 1 ]; then
        echo "Usage: delete_secret <key>"
        return 1
    fi
    local key="$1"

    # Check if the secret file exists
    if [ -e "$filename_secret_conf" ]; then
        sed -i.bak "/^$key=/d" "$filename_secret_conf"
        echo "🗑️ Secret deleted for key: $key"
    else
        echo "❌ Secrets file not found. No secrets to delete."
    fi
}

# delete_secret_noop function
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

# get_all_secret function
# Show all key-value on secret file
function get_all_secret() {
    if [ -e "$filename_secret_conf" ]; then
        wsd_exe_cmd cat $filename_secret_conf
    else
        echo "❌ Secrets file not found. No secrets to delete."
    fi
}

# Example usage:
# add_secret
# secret_value=$(get_secret "API_KEY")
# echo "Retrieved secret value: $secret_value"
# delete_secret "API_KEY"
