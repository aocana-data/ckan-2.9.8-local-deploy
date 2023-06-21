Vagrant.configure("2") do |config|
  config.vm.box = "centos/8"
  config.disksize.size = '20GB'
  config.vm.network "forwarded_port", guest: 5000, host: 5000, host_ip: "127.0.0.1"

  config.vm.synced_folder ".", "/home/sync_folder" , type: "rsync"

  config.vm.provision "shell",  path: "./script_setup/init_vm.sh"

end
    
