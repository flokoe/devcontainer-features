#!/usr/bin/env bash

set -e

if [ -z "$_REMOTE_USER" ] || [ -z "$_REMOTE_USER_HOME" ]; then
    echo "***********************************************************************************"
    echo "*** Require _REMOTE_USER and _REMOTE_USER_HOME to be set (by dev container CLI) ***"
    echo "***********************************************************************************"
    exit 1
fi

# Ensure ~/.config exists to prevent tests failing if root user
mkdir -p "$_REMOTE_USER_HOME/.config"

# Create /dc/bitwarden-cli folder if doesn't exist.
mkdir -p "/dc/bitwarden-cli"

# As to why we move around the folder, check `github-cli-persistence/install.sh` @github.com/joshuanianji/devcontainer-features
if [ -d "$_REMOTE_USER_HOME/.config/Bitwarden CLI" ]; then
    echo "Moving existing '~/.config/Bitwarden CLI' folder to '~/.config/Bitwarden CLI OLD'"
    mv "$_REMOTE_USER_HOME/.config/Bitwarden CLI" "$_REMOTE_USER_HOME/.config/Bitwarden CLI OLD"
fi

ln -s /dc/bitwarden-cli "$_REMOTE_USER_HOME/.config/Bitwarden CLI"

# Change owner of folder.
chown -R "${_REMOTE_USER}:${_REMOTE_USER}" "$_REMOTE_USER_HOME/.config/Bitwarden CLI"

# chown mount (only attached on startup)
cat <<EOF >>"$_REMOTE_USER_HOME/.bashrc"
sudo chown -R "${_REMOTE_USER}:${_REMOTE_USER}" /dc/bitwarden-cli
EOF
chown -R "$_REMOTE_USER" "$_REMOTE_USER_HOME/.bashrc"

echo "done!"
