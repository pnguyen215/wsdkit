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
alias jvlib="java_make_gradle_plugin"

# java_make_gradle_suit function
#
# Downloads a Java Gradle project template from a GitHub repository,
# extracts it, and cleans up, creating a new directory with the specified app name.
#
# Usage:
#   java_make_gradle_suit <app_name>
#
# Parameters:
#   <app_name>: The name of the application to create.
#               This parameter is mandatory.
#
# Dependencies:
#   - curl: Used for downloading the project template ZIP file.
#   - unzip: Used for extracting the downloaded ZIP file.
#   - mktemp: Used for creating a temporary directory.
#
# Global Variables Used:
#   - $github_java_gradle_suit_template_repository:
#       The URL of the GitHub repository containing the Java Gradle project template.
#       This variable should be set before calling this function.
#
# Returns:
#   0: If the operation is successful.
#   1: If the <app_name> parameter is missing.
#
# Output:
#   - Various status messages during the download, extraction, and cleanup process.
#   - The final location and contents of the downloaded project directory.
#
# Note:
#   - This function assumes that the necessary utilities (curl, unzip, mktemp) are available in the system.
#   - It requires the $github_java_gradle_suit_template_repository variable to be set correctly.
#   - Uses 'wsd_exe_cmd' to execute commands, which could be an alias or wrapper for executing commands
#     with optional debug output or error handling.
function java_make_gradle_suit() {
    if [ -z "$1" ]; then
        echo "Usage: java_make_gradle_suit <app_name>"
        return 1
    fi

    local app_name="$1"
    local zip_url="$github_java_gradle_suit_template_repository"
    local zip_file="${app_name}_suit4j.zip"
    local temp_dir=$(mktemp -d)

    echo "🚀 Downloading $app_name from $zip_url..."
    wsd_exe_cmd curl -L -o "$zip_file" "$zip_url"

    echo "🚀 Extracting $zip_file to $temp_dir..."
    wsd_exe_cmd unzip "$zip_file" -d "$temp_dir"

    local target_dir="$(pwd)/$app_name"
    wsd_exe_cmd mv "$temp_dir/suit4j-master" "$target_dir"

    echo "🚀 Cleaning up..."
    wsd_exe_cmd rm "$zip_file"
    wsd_exe_cmd rmdir "$temp_dir"

    echo "🍺 Downloaded $app_name to $target_dir"
    wsd_exe_cmd cd "$target_dir"
    wsd_exe_cmd ls -all
}
alias javamakegradlesuit="java_make_gradle_suit"
alias jvsuit="java_make_gradle_suit"

# java_make_gradle_sdk function
#
# Downloads a Java Gradle SDK template from a specified GitHub repository,
# extracts it to a temporary directory, and moves it to a target directory
# named after the provided application name. This process includes downloading
# the SDK, extracting it, and cleaning up temporary files.
#
# Usage:
#   java_make_gradle_sdk <app_name>
#
# Parameters:
#   <app_name>: The name of the application for which the SDK template is being created.
#               This parameter is mandatory and will be used as the name of the target directory.
#
# Dependencies:
#   - curl: Used to download the SDK template ZIP file from the given URL.
#   - unzip: Used to extract the contents of the downloaded ZIP file.
#   - mktemp: Used to create a temporary directory for the extraction process.
#
# Global Variables Used:
#   - $github_java_gradle_sdk_template_repository:
#       The URL pointing to the GitHub repository containing the Java Gradle SDK template.
#       Ensure this variable is set with the correct repository URL before invoking the function.
#
# Returns:
#   0: If the operation completes successfully.
#   1: If the <app_name> parameter is not provided.
#
# Output:
#   - Status messages indicating the progress of downloading, extracting, and cleaning up.
#   - The final location of the downloaded and extracted SDK template directory.
#
# Note:
#   - This function assumes the presence of necessary utilities (curl, unzip, mktemp) on the system.
#   - It relies on the $github_java_gradle_sdk_template_repository variable being set appropriately.
#   - Uses 'wsd_exe_cmd' to execute commands, which may include additional debugging or error handling features.
function java_make_gradle_sdk() {
    if [ -z "$1" ]; then
        echo "Usage: java_make_gradle_sdk <app_name>"
        return 1
    fi

    local app_name="$1"
    local zip_url="$github_java_gradle_sdk_template_repository"
    local zip_file="${app_name}_wizards2s4j.zip"
    local temp_dir=$(mktemp -d)

    echo "🚀 Downloading $app_name from $zip_url..."
    wsd_exe_cmd curl -L -o "$zip_file" "$zip_url"

    echo "🚀 Extracting $zip_file to $temp_dir..."
    wsd_exe_cmd unzip "$zip_file" -d "$temp_dir"

    local target_dir="$(pwd)/$app_name"
    wsd_exe_cmd mv "$temp_dir/wizards2s4j-master" "$target_dir"

    echo "🚀 Cleaning up..."
    wsd_exe_cmd rm "$zip_file"
    wsd_exe_cmd rmdir "$temp_dir"

    echo "🍺 Downloaded $app_name to $target_dir"
    wsd_exe_cmd cd "$target_dir"
    wsd_exe_cmd ls -all
}
alias javamakegradlesdk="java_make_gradle_sdk"
alias jvsdk="java_make_gradle_sdk"
