  # to avoid the Warning, as stated in http://docs.puppetlabs.com/puppet/3.6/reference/release_notes.html#changes-to-rpm-behavior-with-virtual-packages
  Package {
    allow_virtual => true,
  }
  class { 'resolv':
    searchpath  => [ 'jcbconsulting.biz' ],
    nameservers => [ '127.0.0.1','8.8.8.8','8.8.4.4' ],
    options     => [ 'rotate','timeout:1','attempts:5' ],
  }
  file { '/tmp':
    ensure => directory,
    mode   => 1777,
  }
  include yum
  include yum::thirdparty::epel
  include ntp
  include ssh
  #include puppet
  #include puppet::master
  include cosmetic
  include cosmetic::vim
  include dns
  include web
  include db
  include mail
  include backup
  #include collectd
  include monitoritzacio

  class { 'yum-cron':
    mailto => 'xavi.carrillo@gmail.com',
  }
  file { '/etc/sudoers.d/xcarrillo':
    content => 'xcarrillo  ALL=(ALL) NOPASSWD:/usr/bin/yum update, /usr/bin/puppet
    ', # sudo complains if there is no carriage return
    mode    => '0440',
  }
  ssh_authorized_key { 'xcarrillo@ubuntu-tid':
    ensure => present,
    key    => 'AAAAB3NzaC1yc2EAAAADAQABAAABAQDMG1i3aMtbsXO/2F08yivDLDd9SU8MkUxZLku3xSvlXXYrJ0QXqwUC7REnwZC+kwS5Yg31P/WGix/j9v0atZzbTgI9sJ20XpA5zJjLJyT2YjNL2CPbgBNbI7hy0O86kMywwn7dC7RgXX8SYjqZsDJ7VGPfHUJNb2RFthvGLTlnAzjBCfpMuXhjsyJD9gMOORXDaSXX4+9cfhyOHhaqdXgxbmUxWt4r7NOOJw3aB1IQuBCKv5VHGHJBxXOVjiEQwhhJDwmM+Cbq21HwRRdIiMOhIZBtjTnuQRXg8/uVGYaI5pkIDbu50mcVx79KTaDNHEnYcUztgnlQUzErPzx3Xd2D',
    type   => 'rsa',
    user   => 'xcarrillo',
  }
  ssh_authorized_key { 'Xavi@windows7':
    ensure => present,
    key    => 'AAAAB3NzaC1yc2EAAAADAQABAAABAQDQyD3xlWwgsvMDjHKNMgq8SzIqkMljiIYmJ3aUajieWpLMYWTUOgj5KwBhlEXCOsxd6+24LlXr6/wQ1wSMRrEr28UZpvP03vQwfDFEC1GLLP6RZJIiC6tlOvHosUTayJtnl2bCL1UFOj8rhfWjnzJko5uO9SUyt6Mj67dxXzeTzwvE4whsfWCeb/RRf5n4VRegfWB5GparX6uXJ1f804Z7TnzzUiwHB0j6zmEjtGOe0QRhxtD3mdUZphiUbt1vDnWrCJYWAar2DKeRFHfr5S83x+2HKxns3WMM1wtV4WvEMVJf+HZAT/e65XMCUPsgvTTckGQx1F5io2O+smQZQ3ZJ',
    type   => 'rsa',
    user   => 'xcarrillo',
  }
  service { 'rsyslog':
    ensure => 'running',
    enable => true,
  }
  cron {
    'Masterless puppet':
      ensure      => present,
      command     => 'puppet apply /etc/puppet/environments/production/manifests/masterless.pp  --modulepath=/etc/puppet/environments/production/modules | grep -v Notice',
      user        => root,
      hour        => '*',
      minute      => '15',
  }
  file { '/root/.gitconfig':
    ensure  => present,
    content => "[user] \n  name = Xavi Carrillo\n  email = xavi.carrillo@gmail.com\n",
  }
