export PATH="/opt/homebrew/opt/postgresql@16/bin:$PATH"

function parse_git_branch() {
    git branch 2> /dev/null | sed -n -e 's/^\* \(.*\)/[\1] /p'
}

COLOR_DEF=$'%f'
COLOR_USR=$'%F{243}'
COLOR_DIR=$'%F{197}'
COLOR_GIT=$'%F{39}'
setopt PROMPT_SUBST
export PROMPT='${COLOR_USR}%n ${COLOR_DIR}%2~ ${COLOR_GIT}$(parse_git_branch)${COLOR_DEF}$ '

autoload -U up-line-or-beginning-search
autoload -U down-line-or-beginning-search
zle -N up-line-or-beginning-search
zle -N down-line-or-beginning-search
bindkey "^[[A" up-line-or-beginning-search # Up
bindkey "^[[B" down-line-or-beginning-search # Down

# SHORTCUTS
alias sv='source venv/bin/activate'
alias sz='source ~/.zshrc'

## GIT
alias gs='git status'
alias go='git checkout'
alias goo='git checkout -- :/'
alias gc='git commit -m'
alias gp='git pull'
alias gf='git fetch'
alias gb='git branch'
alias ga='git add'
alias gaa='git add -- :/'
alias gpu='git push'
alias gl='git log'
alias gd='git diff'
alias pm='python3 manage.py'
alias gf='git fetch'
alias mb='make black'
alias ml='make lint'
alias gbclean='git branch -vv | grep ': gone]' | awk '{print $1}' | xargs git branch -D'

##
alias repo='cd /Users/bartlibner/Documents/quickbit/'
alias jAndroid="export JAVA_HOME=/Applications/Android Studio.app/Contents/jbr/Contents/Home"
alias j17="export JAVA_HOME=/opt/homebrew/opt/openjdk@17; java -version"
alias p3="python3"
alias start_celery="CONF_ENV_FILE="/opt/homebrew/etc/rabbitmq/rabbitmq-env.conf" /opt/homebrew/opt/rabbitmq/sbin/rabbitmq-server"


##export JAVA_HOME=/opt/homebrew/opt/openjdk@17
export JAVA_HOME=/opt/homebrew/Cellar/openjdk@17/17.0.13/libexec/openjdk.jdk/Contents/Home
export PATH="$PATH:/Applications/Visual Studio Code.app/Contents/Resources/app/bin"

# NODE
export NODE_OPTIONS=--max-old-space-size=8192

## functions
# Function to push the current Git branch
gbp() {
    # Get the current branch name
    local branch_name=$(git rev-parse --abbrev-ref HEAD)
    
    # Check if the branch name was retrieved successfully
    if [ -n "$branch_name" ]; then
        # Push the current branch to the origin remote
        git push -u origin "$branch_name"
    else
        echo "Error: Could not determine the current branch name."
    fi
}




# Smart grep function - searches in current directory by default
gr() {
    if [ $# -eq 0 ]; then
        echo "Usage: gr <search_term> [directory]"
        echo "Examples:"
        echo "  gr MyFunction              # Search for 'MyFunction' in current directory"
        echo "  gr MyFunction src/         # Search for 'MyFunction' in src/ directory"
        return 1
    fi
    
    local search_term="$1"
    local directory="${2:-.}"  # Default to current directory if not specified
    
    # Use grep with common useful flags, excluding hidden directories
    grep -r --color=auto \
        --exclude-dir=.git \
        --exclude-dir=.mypy_cache \
        --exclude-dir=.pytest_cache \
        --exclude-dir=__pycache__ \
        --exclude-dir=node_modules \
        --exclude-dir=.vscode \
        --exclude-dir=.idea \
        --exclude-dir=venv \
        --exclude="*.pyc" \
        --exclude="*.log" \
        "$search_term" "$directory"
}

# Super simple grep - just search term in current directory
g() {
    if [ $# -eq 0 ]; then
        echo "Usage: g <search_term>"
        echo "Searches for the term in current directory (excludes common junk files)"
        return 1
    fi
    
    grep -r --color=auto \
        --exclude-dir=.git \
        --exclude-dir=.mypy_cache \
        --exclude-dir=.pytest_cache \
        --exclude-dir=__pycache__ \
        --exclude-dir=node_modules \
        --exclude-dir=.vscode \
        --exclude-dir=.idea \
        --exclude-dir=venv \
        --exclude="*.pyc" \
        --exclude="*.log" \
        "$1" .
}

fd() {
    if [ $# -eq 0 ]; then
        echo "Usage: finddir <search_string>"
        echo "Searches for directories containing the search string in their name (case-insensitive)"
        echo "Example: finddir migration"
        return 1
    fi
    
    local search_term="$1"
    echo "Searching for directories containing '$search_term' in current directory and subdirectories..."
    find . -type d -iname "*${search_term}*" \
        -not -path "*/venv/*" \
        -not -path "*/node_modules/*" \
        -not -path "*/.git/*" \
        -not -path "*/__pycache__/*" \
        -not -path "*/.pytest_cache/*" \
        -not -path "*/dist/*" \
        -not -path "*/build/*" \
        -not -path "*/.mypy_cache/*" \
        -not -path "*/.venv/*" \
        -not -path "*/env/*" \
        -not -path "*/.env/*" \
        -not -path "*/target/*" \
        -not -path "*/.cache/*" \
        -not -path "*/tmp/*" \
        -not -path "*/temp/*" \
	2>/dev/null | grep -i --color=auto "$search_term"
}

ff() {
    if [ $# -eq 0 ]; then
        echo "Usage: findfile <search_string>"
        echo "Searches for files containing the search string in their name (case-insensitive)"
        echo "Example: findfile migration"
        return 1
    fi
    
    local search_term="$1"
    echo "Searching for files containing '$search_term' in current directory and subdirectories..."
    find . -type f -iname "*${search_term}*" \
        -not -path "*/venv/*" \
        -not -path "*/node_modules/*" \
        -not -path "*/.git/*" \
        -not -path "*/__pycache__/*" \
        -not -path "*/.pytest_cache/*" \
        -not -path "*/dist/*" \
        -not -path "*/build/*" \
        -not -path "*/.mypy_cache/*" \
        -not -path "*/.venv/*" \
        -not -path "*/env/*" \
        -not -path "*/.env/*" \
        -not -path "*/target/*" \
        -not -path "*/.cache/*" \
        -not -path "*/tmp/*" \
        -not -path "*/temp/*" \
        2>/dev/null | grep -i --color=auto "$search_term"
}
