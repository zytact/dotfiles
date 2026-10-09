export PATH="$HOME/.node_modules/bin:$PATH"
export PATH="/usr/local/node/bin:$PATH"
export PATH="$HOME/.local/share/flutter/bin:$PATH"
export ANDROID_HOME="$HOME/Android/Sdk"
export PATH="$ANDROID_HOME/cmdline-tools/latest/bin:$ANDROID_HOME/emulator:$ANDROID_HOME/platform-tools:$PATH"
export JAVA_HOME="$HOME/.local/share/jdk/17"
export PATH="$JAVA_HOME/bin:$PATH"
export PATH="$HOME/.config/composer/vendor/laravel/installer/bin:$PATH"
export PATH="$HOME/.local/share/quickemu:$PATH"
export PATH=$HOME/.local/bin:$PATH
export PATH=$HOME/Projects/scripts:$PATH
export NODE_COMPILE_CACHE="$HOME/.cache/nodejs-compile-cache"
export ENABLE_CLAUDEAI_MCP_SERVERS=false

export EDITOR="nvim"
export NVIM_APPNAME="lazyvim"
. "$HOME/.cargo/env"
. "$HOME/.secrets"

# Vite+ bin (https://viteplus.dev)
. "$HOME/.vite-plus/env"

export PATH=/home/arnab/.opencode/bin:$PATH

# Added by LM Studio CLI (lms)
export PATH="$PATH:/home/arnab/.lmstudio/bin"

export TEACH_HOME="$HOME/Documents/learning"
export TEACH_DOMAIN="teach.zytact.com"

# Agent shells replay a snapshot without chpwd hooks, which trips zoxide's doctor.
[[ -n $CLAUDECODE ]] && export _ZO_DOCTOR=0
