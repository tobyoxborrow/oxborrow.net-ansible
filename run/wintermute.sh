#!/usr/bin/env bash

CHECK_ARGS=""
if [[ $1 == "check" ]]; then
    CHECK_ARGS="--check"
    echo "CHECK MODE"
fi

# --vault-password-file=<(/usr/bin/env pass oxborrow.net/ansible/vault) \

ansible-playbook --diff --inventory ./ansible/inventory \
    ${CHECK_ARGS} \
    --ask-become-pass \
    --vault-id=run/vault-pass-client.py \
    ./ansible/oxborrow.net.yml --limit "wintermute"
