box      = 'precise64'
url      = 'http://files.vagrantup.com/precise64.box'
hostname = 'vagrantcloudera5ubuntu64'
ram      = '4096'

Vagrant.configure("2") do |config|
  config.vm.box = box
  config.vm.box_url = url
  config.vm.host_name = hostname
  config.vm.network :forwarded_port, host: 8088, guest: 8088  
  config.vm.network :forwarded_port, host: 50070, guest: 50070  
  config.vm.network :forwarded_port, host: 10020, guest: 10020  
  config.vm.network :forwarded_port, host: 19888, guest: 19888  
  config.vm.provider :virtualbox do |vb|
	vb.customize [
		'modifyvm', :id,
		'--name', hostname,
		'--memory', ram,
		"--natdnshostresolver1", "on"
	]
  end

  config.vm.provision :puppet do |puppet|
    puppet.manifests_path = 'manifests'
    puppet.manifest_file = 'site.pp'
    puppet.module_path = 'modules'
	puppet.options = '--verbose --debug'
  end
end
