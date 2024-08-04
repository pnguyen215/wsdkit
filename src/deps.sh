# bash functions
source "$(dirname "$0")/loader.sh"
source "$(dirname "$0")/bookmark.sh"
source "$(dirname "$0")/bookmark_v2.sh"
source "$(dirname "$0")/brew.sh"
source "$(dirname "$0")/plugins.sh"
source "$(dirname "$0")/key.sh"
source "$(dirname "$0")/git.sh"
source "$(dirname "$0")/telegram.sh"
source "$(dirname "$0")/ssh.sh"
source "$(dirname "$0")/fuzzy.sh"

# languages programming
source "$(dirname "$0")/go.sh"
source "$(dirname "$0")/nvm.sh"
source "$(dirname "$0")/java.sh"

# keep at the bottom line
source "$(dirname "$0")/sync.sh"

# devops functions
source "$(dirname "$0")/devops/github_go_ci.sh"
source "$(dirname "$0")/devops/github_ci.sh"
source "$(dirname "$0")/devops/gitignore_ci.sh"
