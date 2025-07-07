# .bashrc

# Source global definitions
if [ -f /etc/bashrc ]; then
    . /etc/bashrc
fi

if [[ $(tty) == *"pts"* ]]; then
    fastfetch -c $HOME/.config/fastfetch/term.jsonc
fi

# User specific environment
if ! [[ "$PATH" =~ "$HOME/.local/bin:$HOME/bin:" ]]; then
    PATH="$HOME/.local/bin:$HOME/bin:$PATH"
fi
export PATH

# Uncomment the following line if you don't like systemctl's auto-paging feature:
# export SYSTEMD_PAGER=

# User specific aliases and functions
if [ -d ~/.bashrc.d ]; then
    for rc in ~/.bashrc.d/*; do
        if [ -f "$rc" ]; then
            . "$rc"
        fi
    done
fi
unset rc

# Agnoster bash theme
export THEME=$HOME/.shrc/agnoster.bash
if [[ $(tty) == *"pts"* ]]; then
    if [[ -f $THEME ]]; then
         export DEFAULT_USER=`whoami`
         source $THEME
    fi
fi