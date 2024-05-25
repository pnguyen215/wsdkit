# java_make_gradle_plugin function
#
# Downloads a Java Gradle plugin template from a GitHub repository,
# extracts it, and cleans up, creating a new directory with the specified app name.
#
# Usage:
#   java_make_gradle_plugin <app_name>
#
# Parameters:
#   <app_name>: The name of the application to create.
#               This parameter is mandatory.
#
# Dependencies:
#   - curl: Used for downloading the plugin template ZIP file.
#   - unzip: Used for extracting the downloaded ZIP file.
#   - mktemp: Used for creating a temporary directory.
#
# Global Variables Used:
#   - $github_java_gradle_plugin_template_repository:
#       The URL of the GitHub repository containing the Java Gradle plugin template.
#       This variable should be set before calling this function.
#
# Returns:
#   0: If the operation is successful.
#   1: If the <app_name> parameter is missing.
#
# Output:
#   - Various status messages during the download, extraction, and cleanup process.
#   - The final location and contents of the downloaded template directory.
#
# Note:
#   - This function assumes that the necessary utilities (curl, unzip, mktemp) are available in the system.
#   - It requires the $github_java_gradle_plugin_template_repository variable to be set correctly.
#   - Uses 'wsd_exe_cmd' to execute commands, which could be an alias or wrapper for executing commands
#     with optional debug output or error handling.
function java_make_gradle_plugin() {
    if [ -z "$1" ]; then
        echo "Usage: java_make_gradle_plugin <app_name>"
        return 1
    fi

    local app_name="$1"
    local zip_url="$github_java_gradle_plugin_template_repository"
    local zip_file="${app_name}_wizard4j.zip"
    local temp_dir=$(mktemp -d)

    echo "🚀 Downloading $app_name from $zip_url..."
    wsd_exe_cmd curl -L -o "$zip_file" "$zip_url"

    echo "🚀 Extracting $zip_file to $temp_dir..."
    wsd_exe_cmd unzip "$zip_file" -d "$temp_dir"

    local target_dir="$(pwd)/$app_name"
    wsd_exe_cmd mv "$temp_dir/wizard4j-master" "$target_dir"

    echo "🚀 Cleaning up..."
    wsd_exe_cmd rm "$zip_file"
    wsd_exe_cmd rmdir "$temp_dir"

    echo "🍺 Downloaded $app_name to $target_dir"
    wsd_exe_cmd cd "$target_dir"
    wsd_exe_cmd ls -all
}
alias javamakegradleplugin="java_make_gradle_plugin"
