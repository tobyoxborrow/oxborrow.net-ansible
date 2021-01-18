# oxborrow.net Host Management

Configuration management scripts for various oxborrow.net hosts.

Ansible is the primary configuration management tool used for all hosts.

## Pre-Bootstrap

The host requires at least the following and typically this will have to be
done manually, perhaps via KVM or local console:

* network connectivity
* working repository system (i.e. apt-get update succeeds)

## Vault

Certain secret sauce is kept in ansible vault encrypted files so that they can
be safely stored in public along with the the rest of this repository. To aid
automation the password for decrypting them is stored on your workstation in
pass oxborrow.net/ansible/vault.

Pass and pwgen can be installed with homebrew:
```
brew install pass pwgen
pass init
```

Generate a password for the vault. Since I'll never type it and it will be
stored in public, go nuts with the length:
```
pwgen 128 1
```

To store the vault password in pass:
```
pass insert oxborrow.net/ansible/vault
```

Encrypt (or rekey) the files that should be kept secret:
```
ansible-vault encrypt ansible/group_vars/*/vault
```

Alternatively, OSX Keychain Access could be used and the pass commands could be
swapped with their `security` equivilents.

See the files in the run/ directory for examples of how that is used.

## Bootstrap

Scripts are included in the `bootstrap/` directory that install the minimum
dependancies required for ansible. These scripts are dead simple so should have
no problem running, but would be higher maintenance if they grow too large,
which is why they are only used briefly.

The scripts are intended to be run on the host to bootstrap, this reduces some
complexity (i.e. you don't need to prepare the ssh service, a user who can
login and ssh keys beforehand, and so on).

Usage example:

```
scp ./bootstrap/bootstrap_debian.sh example.oxborrow.net:
ssh example.oxborrow.net sudo ./bootstrap_debian.sh
```

Alternatively, and perhaps easier, the bootstrap file could be downloaded with
wget and run.

## Development

Vagrant is used for development and testing before applying changes to
production hosts.

To prepare a new vagrant for testing you just need to vagrant up, it will run
the bootstrap script and will be ready for ansible when done. The
`dev/vagrant.sh` is provided to bring up a vagrant as well as remove any
existing one.

To make running ansible against vagrant easier, scripts can be found in the
`dev/` directory. They wrap ansible-playbook and help providing credentials to
ansible vault.

Example:
```
./dev/vagrant.sh
./dev/hostname.vagrant.sh
```

See these scripts for more details.

## Dotfiles

No user dotfiles are managed here. Those are managed in a separate repository.
This approach was chosen so the dotfiles can be quickly applied to adhoc hosts
without having to create a formal inventory definition here.

See: https://github.com/tobyoxborrow/dotfiles

## Usage

There are multiple playbooks, one per oxborrow.net host. To make running
ansible against the hosts easier, scripts can be found in the `run/` directory.
They wrap ansible-playbook and help providing credentials to ansible vault.

Ensure you have some out-of-band connection to the host, e.g. KVM, just in case
the openssh configuration gets messed up.

Usage example:

```
./run/hostname.sh
```
