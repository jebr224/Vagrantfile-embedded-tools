VAGRANT_COMMAND = ARGV[0]

Vagrant.configure(2) do |config|

  config.vm.box = "hashicorp/precise64"
  config.vm.hostname = "oven"

  config.vm.synced_folder ".", "/vagrant", disabled: true
  config.vm.synced_folder "src", "/home/jebr224/src", create: true

  if Vagrant.has_plugin?("vagrant-timezone")
    config.timezone.value = :host
  end
  
  config.vm.provider "virtualbox" do |v|
    
    v.name = "embedded system maker"
    v.cpus = "1"
    v.memory = "512"
    
	v.customize ["modifyvm", :id, "--natdnshostresolver1", "on"]
    v.customize ["guestproperty", "set", :id, "/VirtualBox/GuestAdd/VBoxService/--timesync-set-threshold", 10000]
		v.customize ["modifyvm", :id, "--usb", "off"]
		v.customize ["modifyvm", :id, "--usbehci", "off"]
  end

  config.vm.provision "file", source: ".provision/sharedfolders.conf", destination: "/tmp/sharedfolders.conf"
  
  config.vm.provision "shell",  path: ".provision/provision.sh"
  
  if VAGRANT_COMMAND == "ssh"
    config.ssh.username = "jebr224"
  end
end
