Vagrant.configure("2") do |config|
  config.vm.box = "centos/7"
  dir = File.join(File.dirname(File.expand_path(__FILE__)), "My_HDDs")
  FileUtils.mkdir_p(dir)

  config.vm.provider "virtualbox" do |vb|
    vb.name = "hometask6" 
    if Dir.empty?(dir) 
      vb.customize ["storagectl", :id, "--name", "SATA Controller", "--add", "sata"]
    end
    for i in 1..4
      diskName = "HDD#{i}.vdi" % [i]
      path = File.join(dir, diskName)
      if !File.exist?(path)
        vb.customize ["createhd", "--filename", path, "--size", 300]
      end
      vb.customize ["storageattach", :id, "--storagectl", "SATA Controller", "--port", i, "--device", 0, "--type", "hdd", "--medium", path]
    end
  end

  config.vm.provision "shell", path: "task6.sh"
end