#!/usr/bin/env bash

# it is expected that vagrant VMs will have different keys as they are
# frequently destroyed and recreated
export ANSIBLE_HOST_KEY_CHECKING=False

ansible-playbook --diff --inventory ./dev/inventory.vagrant \
    --vault-password-file=<(/usr/local/bin/pass oxborrow.net/ansible/vault) \
    ./ansible/mailservers.yml --limit "halifax"
