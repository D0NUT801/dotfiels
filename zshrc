# --- 1. Environment & Encoding ---
export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8

# PATH Configuration (~/.local/bin and Rust/Cargo binaries)
export PATH="$HOME/.local/bin:$HOME/.cargo/bin:$PATH"

# --- 2. Title & Location Logic ---
chpwd() {
    print -Pn "\e]2;%~\a"
}

# --- 3. Custom Soft Pink Prompt (Your Palette) ---
chpwd
# Top line: Soft Pink current path | Bottom line: Deep Berry prompt arrow
PROMPT=$'%F{#e06c9f}%~%f\n%F{#e65575}$~> %f'

# --- 4. History & Completions Config ---
HISTFILE=~/.zsh_history
HISTSIZE=5000
SAVEHIST=5000
setopt HIST_IGNORE_DUPS
setopt SHARE_HISTORY

# Initialize native completion engine
autoload -Uz compinit
compinit

# Zsh native completion stylings
zstyle ':completion:*' menu select
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}' # Case-insensitive match

# History search with Up / Down arrows
autoload -Uz up-line-or-beginning-search down-line-or-beginning-search
zle -N up-line-or-beginning-search
zle -N down-line-or-beginning-search
bindkey '^[[A' up-line-or-beginning-search
bindkey '^[[B' down-line-or-beginning-search

# --- 5. Modern Aliases & Wrappers ---
alias vim="nvim"
alias vi="nvim"

# Smart bat replacement for cat
if command -v bat &>/dev/null; then
    alias cat="bat"
fi

# Modern eza replacement for ls
if command -v eza &>/dev/null; then
    alias ls="eza --icons"
    alias ll="eza --icons -l"
    alias la="eza --icons -la"
    alias tree="eza --icons --tree"
fi

# Yazi CWD Wrapper (changes shell directory on exit)
y() {
    local tmp="$(mktemp -t "yazi-cwd.XXXXXX")"
    yazi "$@" --cwd-file="$tmp"
    if cwd="$(cat -- "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
        builtin cd -- "$cwd"
    fi
    rm -f -- "$tmp"
}

# --- 6. Zoxide (Smart Directory Jumping) ---
if command -v zoxide &>/dev/null; then
    eval "$(zoxide init zsh)"
    alias cd="z"
fi

# --- 7. Carapace Completions ---
if command -v carapace &>/dev/null; then
    export CARAPACE_BRIDGES='zsh,fish,bash'
    source <(carapace _carapace zsh)
fi

# --- 8. Arch Linux Zsh Plugins ---
[[ -f /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ]] && source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
[[ -f /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh ]] && source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh

# --- 9. Soft Pink Highlighting & Predictions ---
typeset -A ZSH_HIGHLIGHT_STYLES
ZSH_HIGHLIGHT_STYLES[command]='fg=#e06c9f,bold'      # Soft Pink
ZSH_HIGHLIGHT_STYLES[argument]='fg=#e65575'         # Deep Berry
ZSH_HIGHLIGHT_STYLES[string]='fg=#a594dc'           # Pastel Lavender/Pink
ZSH_HIGHLIGHT_STYLES[variable]='fg=#f783b5'         # Light Pink
ZSH_HIGHLIGHT_STYLES[operator]='fg=#e06c9f'         # Soft Pink
ZSH_HIGHLIGHT_STYLES[number]='fg=#a594dc'           # Lavender Accent
ZSH_HIGHLIGHT_STYLES[comment]='fg=#7a6b8a,italic'    # Muted Gray-Lavender
ZSH_HIGHLIGHT_STYLES[keyword]='fg=#e65575,bold'      # Berry Bold
ZSH_HIGHLIGHT_STYLES[unknown-token]='fg=#e65575,underline' 

# Autosuggestions color & Accept Keybind (Ctrl + F)
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=#8c7b9e'
bindkey '^F' forward-word

