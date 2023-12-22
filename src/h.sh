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

# Example usage:
# wsd_exe_cmd ls -l
# wsd_exe_cmd echo "Hello, World!"

function is_blank() {
    local str="$1"
    [[ -z "${str}" || -z "${str##*[![:space:]]*}" ]]
}

# Example usage:
# if is_blank "$my_string"; then
#     echo "String is blank or empty"
# else
#     echo "String is not blank or empty"
# fi
