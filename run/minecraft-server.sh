#!/usr/bin/env bash

CHECK_ARGS=""
if [[ $1 == "check" ]]; then
    CHECK_ARGS="--check"
    echo "CHECK MODE"
fi

ansible-playbook \
    --diff \
    --inventory ./ansible/inventory \
    ${CHECK_ARGS} \
    --vault-id=run/vault-pass-client.py \
    ./ansible/minecraft-server.yml
