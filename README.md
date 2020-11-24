# Intro

- This documentation will explain and note down the steps needed to be able to create a provisioned VM that runs a node.js app

<br>

# Pre-requisites
- Install `Oracle Virtual Box` [here](https://www.virtualbox.org/wiki/Downloads). This is the software that allows us to create virtual machines (VM).

- One will need `Vagrant` installed, find it [here](https://www.vagrantup.com/downloads.html). We use Vagrant to manage our virtual machines in Oracle VM.

- Once `Vagrant` is installed, you need the `vagrant-hostsupdater` plugin. Run `vagrant plugin install vagrant-hostsupdater` to install it. For knowledge, `vagrant plugin uninstall vagrant-hostsupdater` will uninstall this.
> Might be some problems with this plugin, if you do encounter some just uninstall and then install again

- One will also need `Ruby` installed, find it [here](https://www.ruby-lang.org/en/downloads/). 

- Once `Ruby` is installed, we will need the `bundler`, we can install it using the terminal command `gem install bundler`.

- Navigate to the directory where you copied this repo into and navigate to `environment`. When you `ls` you should be able to see a file called `Gemfile`. Afterwards, type the terminal command `bundle install`. This will install the necessary dependencies.

<br>

# Instructions

**Main Commands and what they do**
- `vagrant init` - this creates a fresh Vagrantfile that can be changed in a text editor. This is written in Ruby.

- `vagrant up` - this will start a VM with the information written in the Vagrantfil`. You need to run this command in the same directory as a Vagrantfile

- `vagrant halt` - this will stop a VM from running

- `vagrant destroy` - this will remove the VM from the list of VM's in Oracle
> This won't remove the Vagrantfile so you can just `vagrant up` to create a new VM with the provisioned file

- `vagrant reload` - this is the combination of typing `vagrant halt` and then `vagrant up`.
> Use this if you make a change to the Vagrantfile while the VM is running and you want to use those changes

- `vagrant ssh` - this will connect to your VM and allow you to use it from your terminal on your primary OS


<br>

**Explanation**
- After running `vagrant init`, we will have a fresh `Vagrantfile` that we can change as we like. Specify the OS you would like to install into the VM by changing `config.vm.box = "<box name>`.
> Vagrant boxes can be found [here](https://app.vagrantup.com/boxes/search). For the purposes of this tutorial, we will use `ubuntu/bionic64`

- Our `Vagrantfile` will be used to host an `nginx` server so we need to specify which network the VM server runs on and it's ip address. We can also create an alias for the specified ip address using `hosts-updater`. Observe the following file for the necessary syntax:
```ruby
Vagrant.configure("2") do |config|
# Specify the box you want to use
  config.vm.box = "ubuntu/bionic64"
# Specify the network type and it's ip address
  config.vm.network "private_network", ip: "192.168.10.100"
# Specify the aliases for this ip address, can be more than one
  config.hostsupdater.aliases = ["development.local"]
end
```

- We also need to be able to load apps into this server, so to migrate files and folders into a VM we can use the following line:
```ruby
Vagrant.configure("2") do |config|
  config.vm.box = "ubuntu/bionic64"
  config.vm.network "private_network", ip: "192.168.10.100"
  config.hostsupdater.aliases = ["development.local"]
# This creates a synced folder between your primary machine and the VM
# First argument is the relative path to the app on primary machine
# Second arguement is where the folder is found within your VM
  config.vm.synced_folder "app", "/app"
end
```

- To run an `nginx` server we need to install it within the VM machine. We can do this via `vagrant ssh` or we can write a shell script that will do it for us when we run `vagrant up`. I detail the latter in the following.

- To allow us to automate the action of creating a VM with the necessary provisions, we can use a shell script. These files end with the `.sh` extension. Our shell file will be called `provision.sh` and inside it we write:
```bash
#!/bin/bash

sudo apt-get update
sudo apt-get install nginx -y
sudo apt-get install nodejs -y
sudo apt-get install npm
cd /app
sudo npm install pm2 -g
npm start
```

- For these scripts to run in the VM, we add a line in our `Vagrantfile`. Our file should then look like the following:
```ruby
Vagrant.configure("2") do |config|
  config.vm.box = "ubuntu/bionic64"
  config.vm.network "private_network", ip: "192.168.10.100"
  config.hostsupdater.aliases = ["development.local"]

  config.vm.synced_folder "app", "/app"

  #runs a .sh file, paths are relative to the vagrantfile
  config.vm.provision "shell", path: "environment/provision.sh"
end
```

- Now to check using tests, we `cd environment/spec-test` to navigate to our environment folder, with our tests. Then run `rake spec` to run the tests. It should tell us which requirements fail and which didn't.

<br>

---
**Used:**
- [Vagrant documentation](https://www.vagrantup.com/docs/index)