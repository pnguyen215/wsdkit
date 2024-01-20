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
# Execute a command and print it for logging purposes.
#
# Usage:
#   wsd_exe_cmd <command>
#
# Parameters:
#   - <command>: The command to be executed.
#
# Description:
#   The 'wsd_exe_cmd' function executes a command and prints it for logging purposes.
#   It is designed to display the command before executing it.
#
# Options:
#   None
#
# Example usage:
#   wsd_exe_cmd ls -l
#
# Instructions:
#   1. Use 'wsd_exe_cmd' to execute a command.
#   2. The command will be printed before execution for logging.
#
# Notes:
#   - This function is useful for logging commands before they are executed.
function wsd_exe_cmd() {
    local command="$*"
    # Print the command
    echo "🖥️: $command"
    # Execute the command without using eval
    "$@"
    # eval "$command"
}

# wsd_exe_cmd_hook function
# Hook to print a command without executing it.
#
# Usage:
#   wsd_exe_cmd_hook <command>
#
# Parameters:
#   - <command>: The command to be printed.
#
# Description:
#   The 'wsd_exe_cmd_hook' function prints a command without executing it.
#   It is designed as a hook for logging or displaying commands without actual execution.
#
# Example usage:
#   wsd_exe_cmd_hook ls -l
#
# Instructions:
#   1. Use 'wsd_exe_cmd_hook' to print a command without executing it.
#
# Notes:
#   - This function is useful for displaying commands in logs or hooks without execution.
function wsd_exe_cmd_hook() {
    local command="$*"
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
    wsd_exe_cmd sudo chmod +x "$1"
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

    wsd_exe_cmd sudo chmod -R 777 "$1"
    echo "🍺 Full permissions granted to $1 (read, write and execute)"
}
alias allowfullperm="allow_full_perm"

# create_file_if_not_exists function
# Utility function to create a file if it doesn't exist.
#
# Usage:
#   create_file_if_not_exists <filename>
#
# Parameters:
#   - <filename>: The name of the file to be created.
#
# Description:
#   The 'create_file_if_not_exists' function checks if a file exists. If the file
#   does not exist, it creates the file along with its parent directory with admin
#   privileges using sudo. It also sets file permissions to allow read and write
#   access only for the owner and no access for others.
#
# Example usage:
#   create_file_if_not_exists /path/to/file.txt
#
# Instructions:
#   1. Use 'create_file_if_not_exists' to ensure a file exists, creating it if necessary.
#
# Notes:
#   - This function is useful for initializing files within a script or ensuring the existence
#     of a file before performing operations.
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
    fi
    return 0
}
alias createfileifnotexists="create_file_if_not_exists"

# check_port function
# Utility function to check if a specific port is in use (listening).
#
# Usage:
#   check_port <port>
#
# Parameters:
#   - <port>: The port number to check.
#
# Description:
#   The 'check_port' function checks whether a specified port is in use by
#   examining the system's open file descriptors using lsof. It specifically
#   looks for LISTEN status, indicating that a process is actively listening on
#   the given port.
#
# Example usage:
#   check_port 8080
#
# Instructions:
#   1. Use 'check_port' to determine if a specific port is already in use.
#
# Notes:
#   - This function is helpful when setting up services to avoid port conflicts.
function check_port() {
    if [ $# -ne 1 ]; then
        echo "Usage: check_port <port>"
        return 1
    fi
    wsd_exe_cmd lsof -nP -iTCP:"$1" | grep LISTEN
}
alias checkport="check_port"

# kill_ports function
# Utility function to kill processes running on specified ports.
#
# Usage:
#   kill_ports
#
# Parameters:
#   None
#
# Description:
#   The 'kill_ports' function prompts the user to enter one or more port
#   numbers, identifies the processes running on those ports, and provides the
#   option to kill those processes.
#
# Example usage:
#   kill_ports
#
# Instructions:
#   1. Run 'kill_ports' to interactively enter and kill processes running on
#      specified ports.
#   2. Enter the desired port numbers when prompted.
#   3. Confirm the process kill operation for each specified port.
#
# Notes:
#   - This function is useful when dealing with port conflicts and needing to
#     free up ports that are currently in use.
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
        local process=$(wsd_exe_cmd lsof -n -iTCP:$port -sTCP:LISTEN -t)

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
        wsd_exe_cmd kill $process
        echo "🍺 Process on port $port has been killed."
    done
}
alias killports="kill_ports"

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

    wsd_exe_cmd sudo cp "$source" "$destination"
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

        wsd_exe_cmd sudo cp "$source" "$destination_file"
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

    wsd_exe_cmd sudo mv "$source" "$destination"
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

        wsd_exe_cmd sudo mv "$source" "$destination"
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

    wsd_exe_cmd sudo mv "$old_path" "$new_path"
    echo "🍺 File/directory renamed successfully to $new_path"
}

# remove_file function
# Remove a file using 'sudo rm' command.
#
# Usage:
#   remove_file <filename>
#
# Parameters:
#   - <filename>: The path to the file to be removed.
#
# Description:
#   The 'remove_file' function removes a file using the 'sudo rm' command. It takes the
#   path to the file as an argument and uses 'sudo' to ensure proper permissions for file removal.
#
# Options:
#   - <filename>: The path to the file you want to remove.
#
# Example usage:
#   remove_file /path/to/file.txt
#
# Instructions:
#   1. Run the 'remove_file' function with the path to the file you want to remove.
#   2. Confirm the deletion by entering 'y' when prompted.
#
# Notes:
#   - Exercise caution when using 'sudo rm' as it permanently deletes files.
#   - Ensure you have the necessary permissions to delete the specified file.
function remove_file() {
    if [ -z "$1" ]; then
        echo "Usage: remove_file <filename>"
        return 1
    fi
    wsd_exe_cmd sudo rm "$1"
}
alias removefile="remove_file"

# chmod_info function
# Provides information about the 'chmod' command, including its usage, options, and modes.
#
# Usage:
#   chmod_info
#
# Description:
#   The 'chmod_info' function displays information about the 'chmod' command, explaining its usage,
#   options, and modes for changing file mode bits. It covers both numeric and symbolic notations,
#   file permissions, and provides examples of using the 'chmod' command.
function chmod_info() {
    echo "chmod - Change file mode bits"
    echo
    echo "Usage: chmod [OPTIONS] MODE FILE"
    echo
    echo "Options:"
    echo "  -c  Like verbose but report only when a change is made"
    echo "  -f  Suppress most error messages"
    echo "  -R  Change files and directories recursively"
    echo "  -v  Output a diagnostic for every file processed"
    echo "  --help  Display this help and exit"
    echo
    echo "MODE can be specified in several ways:"
    echo
    echo "Numeric Notation:"
    echo "  3-digit octal number: e.g., 644, 755"
    echo "    First digit: owner permissions"
    echo "    Second digit: group permissions"
    echo "    Third digit: others permissions"
    echo "    4: read, 2: write, 1: execute"
    echo "    Sum the desired numbers to set the mode"
    echo
    echo "Symbolic Notation:"
    echo "  Symbolic notation: e.g., u=rw,g=r,o=r"
    echo "    u: user, g: group, o: others, a: all"
    echo "    r: read, w: write, x: execute"
    echo "    +: add permission, -: remove permission, =: set permission"
    echo "    Use commas to separate multiple settings"
    echo
    echo "File Permissions:"
    echo "  r (read)    - The file can be read"
    echo "  w (write)   - The file can be modified"
    echo "  x (execute) - The file can be executed as a program"
    echo
    echo "Examples:"
    echo "  chmod 755 myfile.txt  # Owner has read, write, and execute permission; group and others have read and execute permission"
    echo "  chmod u+x,g-w,o=r myfile.sh  # Add execute permission for user, remove write permission for group, and set read permission for others"
    echo "  chmod -R a+rX directory  # Recursively add read and execute permission for all"
}
alias chmodinfo="chmod_info"

# extract function
# Extract compressed files using a single command based on their file extensions.
#
# Usage:
#   extract <filename>
#
# Description:
#   The 'extract' function simplifies the extraction process for various compressed file formats.
#   It detects the file type based on its extension and executes the corresponding extraction command.
#   Supported formats include tar.bz2, tar.gz, bz2, rar, gz, tar, tbz2, tgz, zip, Z, and 7z.
#
# Options:
#   <filename>: The name of the compressed file to be extracted.
function extract() {
    if [ $# -ne 1 ]; then
        echo "Usage: extract <filename>"
        return 1
    fi
    if [ -f "$1" ]; then
        case "$1" in
        *.tar.bz2) wsd_exe_cmd tar xvjf "$1" ;;
        *.tar.gz) wsd_exe_cmd tar xvzf "$1" ;;
        *.bz2) wsd_exe_cmd bunzip2 "$1" ;;
        *.rar) wsd_exe_cmd unrar x "$1" ;;
        *.gz) wsd_exe_cmd gunzip "$1" ;;
        *.tar) wsd_exe_cmd tar xvf "$1" ;;
        *.tbz2) wsd_exe_cmd tar xvjf "$1" ;;
        *.tgz) wsd_exe_cmd tar xvzf "$1" ;;
        *.zip) wsd_exe_cmd unzip "$1" ;;
        *.Z) wsd_exe_cmd uncompress "$1" ;;
        *.7z) wsd_exe_cmd 7z x "$1" ;;
        *) echo "❌ '$1' cannot be extracted via extract()" ;;
        esac
    else
        echo "❌ '$1' is not a valid file"
    fi
}

# ls_files function
# List all files within a specified folder, displaying their full paths.
#
# Usage:
#   ls_files <folder>
#
# Description:
#   The 'ls_files' function provides a convenient way to retrieve the full paths of all files
#   within the specified folder. It utilizes the 'find' command to locate and display file paths.
#
# Options:
#   <folder>: The directory for which to list all files.
function ls_files() {
    if [ $# -lt 1 ]; then
        echo "Usage: ls_files <folder>"
        return 1
    fi
    local folder="$1"
    if [ ! -d "$folder" ]; then
        echo "❌ Error: '$folder' is not a valid directory."
        return 1
    fi
    wsd_exe_cmd find "$folder" -type f -exec readlink -f {} \;
    echo "💭💭💭"
    wsd_exe_cmd ls -all "$folder"
}
alias lsfiles="ls_files"

# editor function
# Open a selected file from a specified folder using a chosen text editor.
#
# Usage:
#   editor <folder>
#
# Description:
#   The 'editor' function provides an interactive way to select a file from the specified
#   folder and open it using a chosen text editor. It uses the 'fzf' command-line fuzzy finder
#   for file and command selection.
#
# Options:
#   <folder>: The directory containing the files you want to edit.
#
# Example usage:
#   Uncomment the line below and replace '<folder>' with the actual directory you want to open files from.
#   editor <folder>
#
# Instructions:
#   1. Run the 'editor' function.
#   2. Use 'fzf' to select a file from the specified folder.
#   3. Choose an action (text editor) to open the selected file.
#
# Supported Text Editors:
#   - cat
#   - less
#   - more
#   - vim
#   - nano
#
# Note:
#   Ensure that 'fzf' is installed for proper functionality.
#
# Dependencies:
#   - fzf
#
# Example:
#   editor ~/documents
function editor() {
    if [ $# -lt 1 ]; then
        echo "Usage: editor <folder>"
        return 1
    fi
    local folder="$1"
    if [ ! -d "$folder" ]; then
        echo "❌ Error: '$folder' is not a valid directory."
        return 1
    fi
    local file_list
    file_list=$(find "$folder" -type f -exec readlink -f {} \;)
    if [ -z "$file_list" ]; then
        echo "❌ No files found in '$folder'."
        return 1
    fi
    local selected_file
    selected_file=$(echo "$file_list" | fzf --prompt="Select a file: ")
    if [ -z "$selected_file" ]; then
        echo "❌ No file selected."
        return 1
    fi
    local selected_command
    selected_command=$(echo "cat;less;more;vim;nano" | tr ';' '\n' | fzf --prompt="Select an action: ")
    if [ -n "$selected_command" ]; then
        wsd_exe_cmd $selected_command "$selected_file"
    fi
}
alias ide="editor"

# open_link function
# Open a URL in the default web browser.
#
# Usage:
#   open_link <url>
#
# Parameters:
#   - <url>: The URL to be opened.
#
# Example usage:
#   open_link "https://www.example.com"
#
# Instructions:
#   1. Run the 'open_link' function with the desired URL.
function open_link() {
    if [ -z "$1" ]; then
        echo "Usage: open_link <url>"
        return 1
    fi
    local url="$1"
    wsd_exe_cmd open "$url"
}
alias openlink="open_link"

# emojis function
# Display a list of supported emojis in the terminal.
#
# Usage:
#   emojis
#
# Description:
#   The 'emojis' function prints a list of supported emojis in the terminal, covering a wide range
#   of Unicode code points. It is a fun way to explore and display emojis within your terminal.
#
# Options:
#   None
#
# Example usage:
#   emojis
#
# Instructions:
#   1. Run the 'emojis' function to display a list of supported emojis in the terminal.
#
# Notes:
#   - This function is purely for entertainment and exploration of emojis within the terminal.
# function emojis() {
#     echo "🚀 Supported emojis in terminal:"
#     for code_point in {128512..128591} {128640..128704} {127744..128317} {9986..10160} {127744..128317}; do
#         printf "\U$(printf '%x' "$code_point") "
#     done
#     echo -e
# }
function emojis() {
    echo "🚀 Supported emojis in terminal:"
    local -i count=0
    for code_point in {128512..128591} {128640..128704} {127744..128317} {9986..10160} {127744..128317}; do
        printf "\U$(printf '%x' "$code_point") "
        # printf "$(printf '%x' "$code_point") "
        printf "%s " "\U$(printf '%08x' "$code_point")"
        # printf "%q " "\U$(printf '%08x' "$code_point")"
        ((count++))
        if ((count % 5 == 0)); then
            echo
        fi
    done
    echo -e
}

# translate_emojis function
# Display the Unicode character for a given emoji code point.
#
# Usage:
#   translate_emojis <unicode>
#
# Parameters:
#   - <unicode>: The Unicode code point of the emoji.
#
# Description:
#   The 'translate_emojis' function prints the Unicode character for a given emoji code point.
#   It allows you to translate emoji codes into the corresponding Unicode characters.
#
# Options:
#   None
#
# Example usage:
#   translate_emojis 1F603
#
# Instructions:
#   1. Run 'translate_emojis' with the Unicode code point of the emoji as a parameter.
#
# Notes:
#   - The Unicode code point should be provided as a hexadecimal value.
function translate_emojis() {
    if [ $# -lt 1 ]; then
        echo "Usage: translate_emojis <unicode>"
        return 1
    fi
    wsd_exe_cmd echo -e "$1"
}
alias translateemojis="translate_emojis"

# download_file function
# Download a file from the specified link and save it with the provided filename.
#
# Usage:
#   download_file <filename_with_extension> <download_link>
#
# Description:
#   The 'download_file' function downloads a file from the specified URL and saves it with the given filename.
#   It uses the 'curl' command to perform the download.
#
# Options:
#   - <filename_with_extension>: The desired filename for the downloaded file, including the file extension.
#   - <download_link>: The URL from which to download the file.
#
# Example usage:
#   download_file "example.zip" "https://example.com/example.zip"
#
# Instructions:
#   1. Run 'download_file' with the desired filename and the download link.
#   2. The function will attempt to download the file using 'curl'.
#   3. If successful, it will display a success message; otherwise, it will indicate a failure.
#
# Notes:
#   - Ensure that 'curl' is installed for proper functionality.
#   - The function checks the exit code of the 'curl' command to determine the success or failure of the download.
function download_file() {
    if [ $# -ne 2 ]; then
        echo "Usage: download_file <filename_with_extension> <download_link>"
        return 1
    fi

    local filename="$1"
    local link="$2"

    # Extract the directory path from the filename
    local directory="$(dirname "$filename")"

    # Check if the directory exists, create it if not
    create_file_if_not_exists "$directory"

    # Change to the directory to download the file
    cd "$directory" || return 1

    local base="$directory/$filename"
    # Check if the file already exists
    if [ -e "$base" ]; then
        local confirm=""
        while [ -z "$confirm" ]; do
            echo -n "❓ Wanna to overwrite? (y/n): "
            read confirm
            if [ -z "$confirm" ]; then
                echo "❌ Invalid confirm. Please try again."
            fi
        done

        if [ "$confirm" != "y" ]; then
            echo "🍌 Download canceled. File already exists."
            return 1
        fi
        # Remove the existing file before downloading
        wsd_exe_cmd sudo rm "$base"
    fi

    # Download the file
    # wsd_exe_cmd curl -O "$link" -o "$filename"
    wsd_exe_cmd curl -LJ "$link" -o "$filename"

    if [ $? -eq 0 ]; then
        echo "🍺 Downloaded successfully: $filename"
    else
        echo "❌ Error: Failed to download: $link"
    fi

    # Return to the original directory
    cd - >/dev/null || return 1
}
