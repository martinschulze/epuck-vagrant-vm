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

exec { 'update-package-sources':
  command => '/usr/bin/pacman -Sy',
}

Exec[ 'update-package-sources' ] -> Package <| |>

include xfce

class { 'locale' :
  locale           => 'de_DE.UTF-8',
  keymap           => 'de-latin1-nodeadkeys',
  keymap_x         => 'de',
  keymap_x_variant => 'nodeadkeys',
  use_eu_norm      => 'true',
  local_clock_rtc  => 'true',
}

file { '/home/vagrant/Desktop':
  ensure  => directory,
  owner   => 'vagrant',
  group   => 'vagrant',
  mode    => '0755',
}

class { 'timezone':
  timezone => 'Europe/Berlin',
  ensure   => present,
  require => File[ '/home/vagrant/Desktop/eclipse.desktop' ],
}


package { 'jre7-openjdk':
  ensure => installed,
}

package { 'git':
  ensure => present,
}

eclipse { 'eclipseRCP':
  downloadurl  => 'http://mirror.netcologne.de/eclipse//technology/epp/downloads/release/kepler/SR2/eclipse-cpp-kepler-SR2-linux-gtk.tar.gz',
  downloadfile => 'eclipse-cpp-kepler-SR2-linux-gtk.tar.gz',
  pluginrepositories => ['http://download.eclipse.org/releases/kepler/'],
  pluginius => [ ],
  timeout => 1800,
  require => Package [ 'jre7-openjdk' ],
}

file { '/home/vagrant/Desktop/eclipse.desktop':
  ensure  => present,
  source  => '/vagrant/data/eclipse.desktop',
  owner   => 'vagrant',
  group   => 'vagrant',
  mode    => '0755',
  require => [ File['/home/vagrant/Desktop'] ],
}

bininstall { 'mplabxc16linux' :
  download_referer    => 'http://www.microchip.com/pagehandler/en_us/devtools/mplabxc/',
  download_user_agent => 'Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US; rv:1.8.1.6) Gecko/20070725 Firefox/2.0.0.6',
  download_url        => 'http://www.microchip.com/mplabxc16linux',
  download_path       => '/tmp',
  download_file       => 'mplabxc16linux',
  download_timeout    => 600,
  extract_file        => 'xc16-v1.21-linux-installer.run',
  extract_method      => 'tar',
  install_options     => ' --mode unattended --installerfunction installcompiler --netclient 0 --netservername localhost',
  install_creates     => '/opt/microchip/xc16/v1.21/bin/xc16-gcc',
}

exec { '/usr/bin/sed -i \'s/PATH=\"\(.*\)\"/PATH=\"\1:\/opt\/microchip\/xc16\/v1.21\/bin\"/\' /etc/profile' :
  unless => '/usr/bin/grep -q "/opt/microchip/xc16/v1.21/bin" /etc/profile',
}

file { '/opt/microchip/xc16/v1.21/bin/xc16-g++':
  ensure  => link,
  target  => '/opt/microchip/xc16/v1.21/bin/xc16-gcc',
  require => Bininstall[ 'mplabxc16linux' ],
}

file { '/home/vagrant/git':
  ensure => directory,
  owner   => 'vagrant',
  group   => 'vagrant',
  mode    => '0755',
}

exec { '/usr/bin/git clone https://github.com/dariuskl/puck-example.git':
  creates => '/home/vagrant/git/puck-example',
  cwd     => '/home/vagrant/git',
  user    => 'vagrant',
}

package { 'bluez' : 
  ensure => present,
}

package { 'bluez-libs' :
  ensure  => present,
  require => Package[ 'bluez' ],
}

package { 'bluez-utils' :
  ensure => present,
  require => Package[ 'bluez' ],
}

service { 'bluetooth' :
  ensure     => running,
  enable     => true,
  require => Package[ 'bluez' ],
}

file { '/home/vagrant/epuckuploadbt':
  source  => "/vagrant/data/epuckuploadbt",
  recurse => true,
}

file { '/home/vagrant/epuck-example.zip':
  ensure => present,
  source => '/vagrant/data/epuck-example.zip',
}
