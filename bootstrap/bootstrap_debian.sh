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

if [[ $EUID != "0" ]]; then
    echo "Please run this script as root"
    exit 1
fi

echo "Please set a password for the user root"
passwd

echo "Creating the user toby"
useradd --gid users --groups adm,sudo --shell /bin/bash --create-home toby

echo "Please set a password for the user toby"
passwd toby

echo "Adding SSH key for the user toby"
mkdir -p ~toby/.ssh/
chmod 0700 ~toby/.ssh/
echo "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQCjYf9u9mItGujvxv+TTBIPd0gmdUXwcU+J7xvXbVdDDdQ29uo6BtZfWKyTXViTCozxlqdyqhEOJKwXEgZ9Bv24eHnpL9rrbBIqDwXHAoR8WorEQjIJ4PPvAMIizh6dw/B+huvNQG4sdDzdeAllc6w4QjJ2PpcQ66fTVHPb59G9MXvgKcWkptpdkDnSLXa1AXppNI8h1bEBUi5PV0sCM3w0qclUHEXAR2cRbJ1tYE2DLVMLgiprfeudR958ig14EQmBqA0p8whOREn5CqUWe5nbDwd/zqcyDAIsff0YZkM6xq+Zzay8WK+S7FdSNbXGovuOORjXShE2/AkzuU0aSAjF6FCWftBLCG02IbW5EGS6LfD+coo3CVu4mTjQy3efKYSnJJR6K9J4vOn8OwDUnprE+zmvvRRkmqca+N+sk1Sghm+pFnkRnSUHEpP39JylSFSLefGWZ+aE7Go86TBm2q0IsxTz942o1/eRSwR+lRgWEBm8aWxoHnXGXya+8BJ0QKLBXkCeNe0ogB/S99UE/pLKAGfhttBL5azDAoU31Uyq9zFVcKaF0YEFXKwTGz9IcTyS5D9uZB/cf2PLdfCthQ+3BKa8QT1/MyQhSSia3hN+oOYY0pYZ3ES+YEM9HvhFpocEuSB9ebhzEQo2Fc+rQcOvl/kuxHcMqdGfP2O6mGKSUQ== toby@oxborrow.net" >> ~toby/.ssh/authorized_keys
chmod 0600 ~toby/.ssh/authorized_keys
chown -R toby:users ~toby/.ssh/

echo "Updating repositories..."
apt-get update

# 201701: Ansible requires Python2, support for v3 is not in stable releases
echo "Installing ansible dependancies..."
if ! which python > /dev/null 2>&1; then
    apt-get install --yes python
fi
# python-apt must be installed to use check mode
if ! dpkg -s python-apt > /dev/null 2>&1; then
    apt-get install --yes python-apt
fi
# python's git module requires the git command-line
if ! dpkg -s git > /dev/null 2>&1; then
    apt-get install --yes git
fi
