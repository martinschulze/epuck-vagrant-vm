# -*- mode: ruby -*-
# vi: set ft=ruby :
#
# Copyright 2014 Martin Schulze
# 
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
# 
#     http://www.apache.org/licenses/LICENSE-2.0
# 
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

Vagrant.configure("2") do |config|
  config.vm.box = "mschulze/arch-mini-i386"

  vm_name = "e_puck"

  # 1: Configure shared folders here.
  config.vm.synced_folder "data", "/vagrant_data"

  # 2: Set VM name here and at point 3.
  config.vm.define vm_name do |e_puck|
  end

  config.vm.provider :virtualbox do |vb|
  # 3: Set VM name here and at point 2.
    vb.name = vm_name
  # 4: Set group name here with starting slash.
    vb.customize ["modifyvm", :id, "--groups", "/AMS"]
  # 5: Set system memory at least to 1024 MB.
  #    Works best with 2048 MB or more, if your main memory is
  #    minimum 4096 MB. Reserve at least 2048 MB for host.
    vb.customize ["modifyvm", :id, "--memory", "4096"]
  # 6: Increase video memory to 128 MB on large screens.
    vb.customize ["modifyvm", :id, "--vram", "64"]
    vb.gui = true
    vb.customize ['modifyvm', :id, '--usb', 'on']
  end
  
  # Don't change provisioning after this line.
  config.vm.provision "shell", inline: "mkdir -p /etc/puppet"
  config.vm.provision "shell", inline: "touch /etc/puppet/hiera.yaml"
  config.vm.provision :puppet do |puppet|
    puppet.manifests_path = "manifests"
    puppet.manifest_file  = "init.pp"
    puppet.module_path    = "modules"
  # puppet.options = "--verbose --debug"
  end
end
