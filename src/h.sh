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

# allow_execute_perm function
# Grants execute permission to the specified file or directory.
#
# Usage:
#   allow_execute_perm <file/dir>
#
# Description:
#   The 'allow_execute_perm' function sets the execute permission for the specified <file/dir>.
#   This is useful for making a script or binary executable.
#
# Parameters:
#   - file/dir: The path to the file or directory for which execute permission is to be granted.
#
# Example:
#   allow_execute_perm ./my_script.sh
#
# Recommendations:
#   - Use this function responsibly and only on files that should be executable.
#   - Ensure that granting execute permission is necessary for the specified file or directory.
function allow_execute_perm() {
    if [ $# -lt 1 ]; then
        echo "Usage: allow_execute_perm <file/dir>"
        return 1
    fi

    wsd_exe_cmd chmod +x "$1"
    echo "🍺 Execute permission granted to $1"
}
alias allowexecuteperm="allow_execute_perm"

# allow_full_perm function
# Grants full permissions (read, write, and execute) to the specified file or directory.
#
# Usage:
#   allow_full_perm <file/dir>
#
# Description:
#   The 'allow_full_perm' function sets the permission to 777 for the specified <file/dir>.
#   This provides read, write, and execute permissions to the owner, group, and others.
#
# Parameters:
#   - file/dir: The path to the file or directory for which full permissions are to be granted.
#
# Example:
#   allow_full_perm ./my_script.sh
#
# Recommendations:
#   - Use this function responsibly and only on files or directories that require full permissions.
#   - Granting full permissions should be done with caution, especially for security-sensitive files.
function allow_full_perm() {
    if [ $# -lt 1 ]; then
        echo "Usage: allow_full_perm <file/dir>"
        return 1
    fi
    wsd_exe_cmd sudo chmod 777 "$1"
    echo "🍺 Full permissions granted to $1 (read, write and execute)"
}
alias allowfullperm="allow_full_perm"

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
        allow_full_perm "$filename"
    else
        # the file permissions to allow read and write access only for the owner and no access for others.
        allow_full_perm "$filename"
    fi
    return 0
}

# Example usage:
# create_file_if_not_exists "/Users/arisnguyenit97/wsdkit.conf/assets/secrets.txt"

# Check port running
function check_port() {
    if [ $# -ne 1 ]; then
        echo "Usage: check_port <port>"
        return 1
    fi
    wsd_exe_cmd lsof -nP -iTCP:"$1" | grep LISTEN
}

# Kill port running
# Kill processes using specified ports
function kill_ports() {
    echo "Enter the ports you want to kill (separated by spaces): \c"
    read ports

    # Loop through each port in the input
    for port in $ports; do
        # Check if the port is valid
        if ! [[ "$port" =~ ^[0-9]+$ ]]; then
            echo "❌ Invalid port number: $port. Skipping..."
            continue
        fi

        # Get the process running on the specified port
        local process=$(lsof -n -iTCP:$port -sTCP:LISTEN -t)

        # Check if any process is running on the specified port
        if [ -z "$process" ]; then
            echo "No process is using port $port. Skipping..."
            continue
        fi

        # Ask for confirmation before killing the process
        echo -n "Are you sure you want to kill the process running on port $port? (y/n) "
        read confirm
        if [ "$confirm" != "y" ]; then
            echo "Process kill operation canceled for port $port."
            continue
        fi

        # Kill the process using the specified port
        kill $process
        echo "🍺 Process on port $port has been killed."
    done
}

# Copy filename by new filename
function copy_file() {
    if [ $# -ne 2 ]; then
        echo "Usage: copy_file <source_filename> <new_filename>"
        return 1
    fi

    local source="$1"
    local filename="$2"
    local destination="$PWD/$filename"

    if [ -e "$destination" ]; then
        echo "❌ Error: Destination file already exists."
        return 1
    fi

    wsd_exe_cmd cp "$source" "$destination"
    echo "🍺 File copied successfully to $destination"
}

# Copy filename by new filename (copy from one file to many files)
function copy_files() {
    if [ $# -lt 2 ]; then
        echo "Usage: copy_files <source_filename> <new_filename1> [<new_filename2> ...]"
        return 1
    fi

    local source="$1"
    shift # Remove the source file from the arguments
    local destination="$PWD"

    for filename in "$@"; do
        local destination_file="$destination/$filename"

        if [ -e "$destination_file" ]; then
            echo "❌ Error: Destination file '$filename' already exists."
            continue
        fi

        wsd_exe_cmd cp "$source" "$destination_file"
        echo "🍺 File copied successfully to $destination_file"
    done
}

# Move file to a specified folder
function move_file() {
    if [ $# -ne 2 ]; then
        echo "Usage: move_file <source_filename> <destination_folder>"
        return 1
    fi

    local source="$1"
    local destination_folder="$2"

    if [ ! -d "$destination_folder" ]; then
        echo "❌ Error: Destination folder does not exist."
        return 1
    fi

    local destination="$destination_folder/$(basename "$source")"

    if [ -e "$destination" ]; then
        echo "❌ Error: Destination file already exists."
        return 1
    fi

    wsd_exe_cmd mv "$source" "$destination"
    echo "🍺 File moved successfully to $destination"
}

# Move multiple files to a specified folder
function move_files() {
    if [ $# -lt 2 ]; then
        echo "Usage: move_files <destination_folder> <file1> <file2> ... <fileN>"
        return 1
    fi

    local destination_folder="$1"
    shift # Remove the first argument (destination folder) from the list

    if [ ! -d "$destination_folder" ]; then
        echo "❌ Error: Destination folder does not exist."
        return 1
    fi

    for source in "$@"; do
        if [ ! -e "$source" ]; then
            echo "❌ Error: Source file '$source' does not exist."
            return 1
        fi

        local destination="$destination_folder/$(basename "$source")"

        if [ -e "$destination" ]; then
            echo "❌ Error: Destination file '$destination' already exists."
            return 1
        fi

        wsd_exe_cmd mv "$source" "$destination"
        echo "🍺 File '$source' moved successfully to $destination"
    done
}

# Rename file or directory
function rename_file() {
    if [ $# -ne 2 ]; then
        echo "Usage: rename_file <old_name> <new_name>"
        return 1
    fi

    local old_name="$1"
    local new_name="$2"
    local old_path="$PWD/$old_name"
    local new_path="$PWD/$new_name"

    if [ ! -e "$old_path" ]; then
        echo "❌ Error: Source file/directory does not exist."
        return 1
    fi

    if [ -e "$new_path" ]; then
        echo "❌ Error: Destination file/directory already exists."
        return 1
    fi

    wsd_exe_cmd mv "$old_path" "$new_path"
    echo "🍺 File/directory renamed successfully to $new_path"
}
