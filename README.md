# Intro

- This documentation will explain and note down the steps needed to be able to create a provisioned VM that runs a node.js app

<br>

# Pre-requisites
- Install `Oracle Virtual Box` [here](https://www.virtualbox.org/wiki/Downloads). This is the software that allows us to create Guest OS's on our machine.

- One will need `Vagrant` installed, find it [here](https://www.vagrantup.com/downloads.html). We use Vagrant to manage our virtual machines in Oracle VM.

- One will also need `Ruby` installed, find it [here](https://www.ruby-lang.org/en/downloads/). 

- Once `Ruby` is installed, we will need the `bundler`, we can install it using the terminal command `gem install bundler`.

- Then within this directory, navigate to `environment`. When you `ls` you should be able to see a file called `Gemfile`. After, type the terminal command `bundle install`.

<br>

# Instructions

- To allow us to automate the action of creating a VM with the necessary provisions, we can use a shell script. These files end with the `.sh` extension.

- For these scripts to run in the VM, we add a line in our `Vagrantfile` stating: `config.vm.provision "shell", path: "environment/provision.sh"`. Our file should then look like the following:
```ruby
    # Install required plugins
required_plugins = ["vagrant-hostsupdater"]
required_plugins.each do |plugin|
    exec "vagrant plugin install #{plugin}" unless Vagrant.has_plugin? plugin
end

Vagrant.configure("2") do |config|
  config.vm.box = "ubuntu/bionic64"
  config.vm.network "private_network", ip: "192.168.10.100"
  config.hostsupdater.aliases = ["development.local"]

  config.vm.synced_folder "app", "/app"

  #runs a .sh file, paths are relative to the vagrantfile
  config.vm.provision "shell", path: "environment/provision.sh"

end
```
