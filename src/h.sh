# add_suffix_if_needed function
# This function appends a suffix to a given path if the path does not already end with the specified suffix.

# Parameters:
#   $1: The original path
#   $2: The suffix to be added

# Example usage:
# original_path="/some/directory"
# suffix_to_add="files"
# modified_path=$(add_suffix_if_needed "$original_path" "$suffix_to_add")
# echo "Modified Path: $modified_path"
function add_suffix_if_needed() {
    local path="$1"
    local suffix="$2"
    if [[ "$path" != *"$suffix" ]]; then
        path="$path/$suffix"
    fi
    echo "$path"
}

# wsd_exe_cmd function
# Function to print and execute a command
function wsd_exe_cmd() {
    local command="$*"
    # Print the command
    echo "🖥️: $command"
    # Execute the command without using eval
    "$@"
    # eval "$command"
}

# wsd_exe_cmd_hook function
# Print a command
function wsd_exe_cmd_hook() {
    local command="$*"
    # Print the command
    echo "👉 use: $command"
}

# create_file_if_not_exists function
# Creates a file with administrator privileges if it doesn't exist.
# Parameters:
#   $1: File path
# Returns:
#   0 on success, 1 on error
function create_file_if_not_exists() {
    if [ $# -lt 1 ]; then
        echo "Usage: create_file_if_not_exists <filename>"
        return 1
    fi

    local filename="$1"
    local directory="$(dirname "$filename")"

    # Check if the directory exists
    if [ ! -d "$directory" ]; then
        echo "📁 Directory does not exist. Creating $directory with admin privileges..."

        # Use sudo to create the directory with elevated privileges
        sudo mkdir -p "$directory"

        # Check if the directory was successfully created
        if [ $? -eq 0 ]; then
            echo "✅ Directory created successfully."
        else
            echo "❌ Error: Failed to create the directory."
            return 1
        fi
    fi

    # Check if the file exists
    if [ ! -e "$filename" ]; then
        echo "📄 File does not exist. Creating $filename with admin privileges..."

        # Use sudo to create the file with elevated privileges
        sudo touch "$filename"

        # Check if the file was successfully created
        if [ $? -eq 0 ]; then
            echo "✅ File created successfully."
            return 0
        else
            echo "❌ Error: Failed to create the file."
            return 1
        fi

        # the file permissions to allow read and write access only for the owner and no access for others.
        sudo chmod -R 777 "$filename"
    else
        # the file permissions to allow read and write access only for the owner and no access for others.
        sudo chmod -R 777 "$filename"
    fi

    return 0
}

# Example usage:
# create_file_if_not_exists "/Users/arisnguyenit97/wsdkit.conf/assets/secrets.txt"
