#!/usr/bin/env bash

ansible-playbook --diff --inventory ./ansible/inventory \
    --ask-become-pass \
    --vault-password-file=<(/usr/local/bin/pass oxborrow.net/ansible/vault) \
    ./ansible/mailservers.yml --limit "halifax"
