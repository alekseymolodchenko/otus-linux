# -*- mode: ruby -*-
# vim: set ft=ruby :

MACHINES = {
  :otuslinux2 => {
  :box_name => "centos/7",
  :ip_addr => '192.168.11.102',
	:disks => {
		:sata1 => {
			:dfile => '/tmp/sata1.vdi',
			:size => 1024,
			:port => 1
		},
		:sata2 => {
      :dfile => '/tmp/sata2.vdi',
      :size => 1024, # Megabytes
		  :port => 2
		}
	}
},
}

Vagrant.configure("2") do |config|

  MACHINES.each do |boxname, boxconfig|

      config.vm.define boxname do |box|

          box.vm.box = boxconfig[:box_name]
          box.vm.host_name = boxname.to_s

          #box.vm.network "forwarded_port", guest: 3260, host: 3260+offset

          box.vm.network "private_network", ip: boxconfig[:ip_addr]

          box.vm.provider :virtualbox do |vb|
                vb.customize ["modifyvm", :id, "--memory", "1024"]
                vb.customize ["modifyvm", :id, "--cpus", 4]
                  needsController = false
		  boxconfig[:disks].each do |dname, dconf|
			  unless File.exist?(dconf[:dfile])
				vb.customize ['createhd', '--filename', dconf[:dfile], '--variant', 'Fixed', '--size', dconf[:size]]
                                needsController =  true
                          end

		  end
      if needsController == true
         vb.customize ["storagectl", :id, "--name", "SATA", "--add", "sata" ]
         boxconfig[:disks].each do |dname, dconf|
             vb.customize ['storageattach', :id,  '--storagectl', 'SATA', '--port', dconf[:port], '--device', 0, '--type', 'hdd', '--medium', dconf[:dfile]]
         end
      end
    end
 	  box.vm.provision "shell", inline: <<-SHELL
	      mkdir -p ~root/.ssh
        cp ~vagrant/.ssh/auth* ~root/.ssh
        yum install -y mdadm smartmontools hdparm gdisk wget
  	  SHELL

      end
  end
end
