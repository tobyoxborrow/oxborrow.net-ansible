# -*- mode: ruby -*-
# vi: set ft=ruby :
#
# Vagrant is used for development and testing before applying changes to
# production hosts.
#
# See README.md for usage instructions.

# set the root and user passwords to "vagrant" so ansible can sudo
# since there are no other prompts, this works
$bootstrap = <<__END__
yes vagrant | /vagrant/bootstrap/bootstrap_debian.sh
__END__

Vagrant.configure("2") do |config|
  config.vm.box = "ubuntu/xenial64"
  config.vm.provider "virtualbox" do |vb|
    vb.memory = "512"
    vb.cpus = "1"
  end

  # primary test host for ansible code
  config.vm.define "ansible", primary: true do |ansible|
    ansible.vm.provision "shell", inline: $bootstrap
    # define a fixed ssh port which is then specified in inventory.vagrant
    ansible.vm.network :forwarded_port, guest: 22, host: 62200, id: "ssh"
  end
end
