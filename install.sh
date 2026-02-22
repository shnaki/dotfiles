#!/bin/bash

DOT_DIR="$(builtin cd "$(dirname "${BASH_SOURCE:-${(%):-%N}}")" && pwd)"
DOT_REPO="https://github.com/shnaki/dotfiles.git"
DOT_SCR="${HOME}/.dot"

echo "-------------------------"
echo " Install dotfiles "
echo "-------------------------"
echo
echo "First, Clone dot command from GitHub."
echo "  * git clone https://github.com/ssh0/dot.git ${DOT_SCR}"
echo
git clone https://github.com/ssh0/dot.git "${DOT_SCR}"

# Source dot command
if [ -f "${DOT_SCR}/dot.sh" ] && . "${DOT_SCR}/dot.sh"; then
    echo "dot is succefully installed."
    echo
else
    echo "dot cannot be installed."
    echo
    echo "Try manuall installation."
    echo
    exit 1
fi

# Create temporary configuration file to set some variables.
temp_config="$(mktemp)"
cat << EOF > "${temp_config}"
clone_repository='${DOT_REPO}'
dotdir='${DOT_DIR}'
EOF

dot_main -c "${temp_config}" set --force --verbose

if [ -f "${DOT_DIR}/etc/init_zed.sh" ]; then
    sh "${DOT_DIR}/etc/init_zed.sh"
fi
