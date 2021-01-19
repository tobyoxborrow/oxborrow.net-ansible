#!/usr/bin/env bash
# Bootstrap debian-like linux host for ansible
#
# Installs basic package dependancies and creates a toby user
# This should only need to be run once on freshly installed hosts.
#
# Pre-Bootstrap
# The host requires at least the following and typically this will have to be
# done manually:
# * network connectivity
# * working repository system (i.e. apt-get update succeeds)
#
# Usage example:
#
# scp ./bootstrap/bootstrap_debian.sh example.oxborrow.net:
# ssh example.oxborrow.net sudo ./bootstrap_debian.sh

set -o errexit
set -o pipefail
set -o nounset

# if [[ $EUID != "0" ]]; then
#     echo "Please run this script as root"
#     exit 1
# fi
#
# echo "Please set a password for the user root"
# passwd

if ! getent passwd toby; then
    echo "Creating the user toby"
    useradd --gid users --groups adm,sudo --shell /bin/bash --create-home toby

    echo "Please set a password for the user toby"
    passwd toby
fi

echo "Preparing SSH key permissions for the user toby"
mkdir -p ~toby/.ssh/
chmod 0700 ~toby/.ssh/
touch ~toby/.ssh/authorized_keys
chmod 0600 ~toby/.ssh/authorized_keys
chown -R toby:users ~toby/.ssh/

if ! grep -q L005nN ~toby/.ssh/authorized_keys; then
    echo "Adding SSH key 1 for the user toby"
    echo "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOXx0w7HECZqZilUYqMxT6K4Ym014gkmURfovdL005nN toby@oxborrow.net" >> ~toby/.ssh/authorized_keys
fi
if ! grep -q ajpw4K ~toby/.ssh/authorized_keys; then
    echo "Adding SSH key 2 for the user toby"
    echo "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIEoFbrKme/ZvYLIRVACAXOdVwUYd0ZyYgSA1F0ajpw4K toby@hurricane.home.oxborrow.net" >> ~toby/.ssh/authorized_keys
fi

echo "Updating repositories..."
/usr/bin/apt update

# Ansible requires sudo for "become", and it is not necessarily installed by default
if ! type sudo >/dev/null 2>&1; then
    /usr/bin/apt install --yes sudo
fi

# Ansible should detect python, but may fail. explicitly set python to point to python3
if ! type python3 >/dev/null 2>&1; then
    /usr/bin/apt install --yes python3
fi
if ! type python >/dev/null 2>&1; then
    /usr/bin/update-alternatives --install /usr/bin/python python /usr/bin/python3 1
fi

# # python-apt must be installed to use check mode
# if ! dpkg -s python-apt > /dev/null 2>&1; then
#     apt install --yes python-apt
# fi
# # python's git module requires the git command-line
# if ! dpkg -s git > /dev/null 2>&1; then
#     apt install --yes git
# fi
