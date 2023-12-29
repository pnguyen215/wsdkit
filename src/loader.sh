# loading_spinner function
# Display a loading spinner in the console.
#
# Usage:
#   loading_spinner [duration]
#
# Parameters:
#   - [duration]: Optional. The duration in seconds for which the spinner should be displayed.
#                 Default is 3 seconds.
#
# Example usage:
#   loading_spinner
#   loading_spinner 10
#
# Instructions:
#   1. Run the 'loading_spinner' function with an optional duration parameter.
#
# Notes:
#   - The spinner consists of a sequence of characters to create a visual effect.
#   - Press Ctrl+C to stop the spinner manually.
function loading_spinner() {
    local duration="${1:-3}" # Default duration is 3 seconds
    local spinner="/-\|"

    local end_time=$((SECONDS + duration))

    while [ $SECONDS -lt $end_time ]; do
        for i in $(seq 0 3); do
            echo -n "${spinner:$i:1}"
            sleep 0.1
            echo -ne "\b#"
        done
    done

    echo -e
}
alias loadingspinner="loading_spinner"

# progress_bar function
# Display a loading progress bar in the console.
#
# Usage:
#   progress_bar [duration]
#
# Parameters:
#   - [duration]: Optional. The duration in seconds for which the progress bar should be displayed.
#                 Default is 3 seconds.
#
# Example usage:
#   progress_bar
#   progress_bar 10
#
# Instructions:
#   1. Run the 'progress_bar' function with an optional duration parameter.
#
# Notes:
#   - The progress bar is a series of '=' characters that gradually fill up.
#   - Press Ctrl+C to stop the progress bar manually.
function progress_bar() {
    local duration="${1:-3}" # Default duration is 3 seconds
    local width=40           # Width of the progress bar
    local fill_char="."      # Character used to fill the progress bar
    local interval=$((duration * 10 / width))

    for ((i = 0; i <= width; i++)); do
        local percentage=$((i * 100 / width))
        echo -n -e "\r["
        for ((j = 0; j < i; j++)); do
            echo -n -e "$fill_char"
        done
        for ((j = i; j < width; j++)); do
            echo -n -e " "
        done
        echo -n -e "] $percentage% ($duration s)"
        sleep 0.1
    done

    echo -e
}
alias progressbar="progress_bar"
