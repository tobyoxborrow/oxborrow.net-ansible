#!/usr/bin/env bash

CHECK_ARGS=""
if [[ $1 == "check" ]]; then
    CHECK_ARGS="--check"
    echo "CHECK MODE"
fi

ansible-playbook --diff --inventory ./ansible/inventory \
    ${CHECK_ARGS} \
    --ask-become-pass \
    --vault-password-file=<(/usr/local/bin/pass oxborrow.net/ansible/vault) \
    --tags mail \
    ./ansible/mailservers.yml --limit "mailservers"
