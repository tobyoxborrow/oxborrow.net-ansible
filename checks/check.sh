#!/usr/bin/env bash

set -o errexit
set -o pipefail
set -o nounset

gitlint --version
gitlint

ansible-lint --version
find ansible -name "*.yml" -print0 | xargs -0 ansible-lint

ansible-playbook --syntax-check --list-tasks \
    --inventory ./ansible/inventory.vagrant \
    --vault-password-file=<(/usr/local/bin/pass oxborrow.net/ansible/vault) \
    ./ansible/*.yml
