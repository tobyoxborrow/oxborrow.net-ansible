#!/usr/bin/env bash

# usage:
# ./bootstrap/vagrant.sh
#   - brings up VM and runs provision
# ./bootstrap/vagrant.sh reset
#   - destroy existing VM
#   - brings up VM and runs provision
#   - use this to start from a clean environment

# it is expected that vagrant VMs will have different keys as they are
# frequently destroyed and recreated
ssh-keygen -R "[127.0.0.1]:62200"

if [[ $1 == "reset" ]]; then
    vagrant destroy -f
fi

vagrant up
