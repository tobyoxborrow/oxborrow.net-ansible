#!/usr/bin/env python
"""
Get ansible vault password from a local pass vault.

pass: https://www.passwordstore.org/
apt install pass
brew install pass
"""

import sys
import shlex
import subprocess
from pathlib import Path

VAULT_NAME='oxborrow.net/ansible/vault'


def find_pass() -> str:
    locations = [
        Path('/usr/bin/local/pass'),  # macOS / homebrew
        Path('/usr/bin/pass'),  # linux
    ]
    for location in locations:
        if location.exists():
            return str(location)
    return '/usr/bin/env pass'  # may work


def get_password_from_vault():
    """Call pass and return the output."""
    pass_path = find_pass()
    command_line = f'{pass_path} {VAULT_NAME}'
    command_args = shlex.split(command_line)
    process = subprocess.Popen(
        command_args,
        stdin=subprocess.PIPE,
        stdout=subprocess.PIPE,
        stderr=subprocess.PIPE,
    )

    output = process.communicate()

    lines = output[0].decode().split('\n')

    return lines[0]


def main():
    password = get_password_from_vault()
    if not password:
        print('Failed to get password from vault.', file=sys.stderr)
        sys.exit(1)
    print(password)



if __name__ == '__main__':
    main()
