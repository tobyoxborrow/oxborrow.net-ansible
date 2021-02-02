#!/usr/bin/env bash

FILENAME="${1:-}"
if [[ -z $FILENAME ]]; then
    echo "usage: $0 <filename>"
    exit 1
fi

ansible-vault edit \
    --vault-id=run/vault-pass-client.py \
    "${FILENAME}"
