# bookmark_add function
# Creates a symbolic link to the current working directory and adds it as a bookmark.
#
# Usage:
#   bookmark_add <file/dir>
#
# Description:
#   The 'bookmark_add' function creates a symbolic link to the current working directory
#   and adds it as a bookmark in the ~/.bookmarks directory. Bookmarks provide a quick way
#   to navigate to frequently accessed directories.
#
# Parameters:
#   - <file/dir>: The name of the bookmark, which can be a file or directory.
#
# Example:
#   bookmark_add project1
#
# Recommendations:
#   - Use meaningful names for bookmarks to easily identify the associated directories or files.
#   - Use bookmarks for directories you frequently navigate to.
#
# Dependencies:
#   - The 'ln' command for creating symbolic links.
function bookmark_add() {
    if [ $# -lt 1 ]; then
        echo "Usage: bookmark_add <file/dir>"
        return 1
    fi
    wsd_exe_cmd ln -s "$(pwd)" ~/.bookmarks/$1
}
alias bookmarkadd="bookmark_add"

# bookmark_goto function
# Changes the current working directory to the location of a bookmark.
#
# Usage:
#   bookmark_goto <file/dir>
#
# Description:
#   The 'bookmark_goto' function changes the current working directory to the location
#   associated with the specified bookmark. Bookmarks provide a quick way to navigate to
#   frequently accessed directories.
#
# Parameters:
#   - <file/dir>: The name of the bookmark, which corresponds to the bookmark created using 'bookmark_add'.
#
# Example:
#   bookmark_goto project1
#
# Recommendations:
#   - Use meaningful names for bookmarks to easily identify the associated directories or files.
#   - Ensure that the specified bookmark exists before using 'bookmark_goto'.
#
# Dependencies:
#   - The 'cd' command for changing the current working directory.
function bookmark_goto() {
    if [ $# -lt 1 ]; then
        echo "Usage: bookmark_goto <file/dir>"
        return 1
    fi
    wsd_exe_cmd cd ~/.bookmarks/$1
}
alias bookmarkgoto="bookmark_goto"

# bookmark_removal function
# Removes a bookmark associated with a specified file or directory.
#
# Usage:
#   bookmark_removal <file/dir>
#
# Description:
#   The 'bookmark_removal' function removes the bookmark associated with the specified file or directory.
#   This operation helps manage the list of bookmarks when a bookmark is no longer needed.
#
# Parameters:
#   - <file/dir>: The name of the bookmark to be removed.
#
# Example:
#   bookmark_removal project1
#
# Recommendations:
#   - Use meaningful names for bookmarks to easily identify the associated directories or files.
#   - Ensure that the specified bookmark exists before attempting removal.
#
# Dependencies:
#   - The 'rm' command for removing files.
function bookmark_removal() {
    if [ $# -lt 1 ]; then
        echo "Usage: bookmark_removal <file/dir>"
        return 1
    fi
    if [ -e ~/.bookmarks/"$1" ]; then
        wsd_exe_cmd rm ~/.bookmarks/"$1"
        echo "🗑️ Bookmark '$1' removed."
    else
        echo "❌ Bookmark '$1' not found."
    fi
}
alias bookmarkremoval="bookmark_removal"

# bookmark_list function
# Lists all bookmarks stored in the ~/.bookmarks directory.
#
# Usage:
#   bookmark_list
#
# Description:
#   The 'bookmark_list' function displays a list of all bookmarks stored in the ~/.bookmarks directory.
#   Bookmarks are used to quickly navigate to predefined directories or files.
#
# Example:
#   bookmark_list
#
# Recommendations:
#   - Regularly review the list of bookmarks to stay organized.
#   - Use meaningful names for bookmarks to easily identify associated directories or files.
#
# Dependencies:
#   - None
function bookmark_list() {
    if [ ! -d ~/.bookmarks ]; then
        echo "❌ No bookmarks found."
        return 1
    fi
    echo "🍺 Bookmarks:"
    for bookmark in ~/.bookmarks/*; do
        echo "$(basename $bookmark)"
    done
}
alias bookmarklist="bookmark_list"
