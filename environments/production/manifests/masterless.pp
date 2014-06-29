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
  #include collectd
  class { 'yum-cron':
    mailto => 'xavi.carrillo@gmail.com',
  }
  class { 'dropbox':
    users => 'root',
  }
  package { 'rdiff-backup':
    ensure => latest,
  }
  file { '/root/Dropbox/backups/vps38933/sql':
    ensure => directory,
  }
  file { '/root/Dropbox/backups/vps38933/rdiff':
    ensure => directory,
  }
  file { '/etc/sudoers.d/xcarrillo':
    content => 'xcarrillo  ALL=(ALL) NOPASSWD:/usr/bin/yum update, /usr/bin/puppet',
    mode    => '0440',
  }
  ssh_authorized_key { 'xcarrillo@ubuntu-tid':
    ensure => present,
    key    => 'AAAAB3NzaC1yc2EAAAADAQABAAABAQDMG1i3aMtbsXO/2F08yivDLDd9SU8MkUxZLku3xSvlXXYrJ0QXqwUC7REnwZC+kwS5Yg31P/WGix/j9v0atZzbTgI9sJ20XpA5zJjLJyT2YjNL2CPbgBNbI7hy0O86kMywwn7dC7RgXX8SYjqZsDJ7VGPfHUJNb2RFthvGLTlnAzjBCfpMuXhjsyJD9gMOORXDaSXX4+9cfhyOHhaqdXgxbmUxWt4r7NOOJw3aB1IQuBCKv5VHGHJBxXOVjiEQwhhJDwmM+Cbq21HwRRdIiMOhIZBtjTnuQRXg8/uVGYaI5pkIDbu50mcVx79KTaDNHEnYcUztgnlQUzErPzx3Xd2D',
    type   => 'rsa',
    user   => 'xcarrillo',
  }
  service { 'rsyslog':
    ensure => 'running',
    enable => true,
  }
  cron {
    "backup sql":
      ensure      => present,
      environment => 'MAILTO=xavi.carrillo@gmail.com',
      command     => '/opt/scripts/backups/backup_sql.sh /root/Dropbox/backups/vps38933/sql/',
      user        => root,
      hour        => 2,
      minute      => 20;
    'rdiff-backup':
       ensure     => present,
       command    => '/usr/local/bin/backup',
       user       => root,
       hour       => 4,
       minute     => 20;
    'Masterless puppet':
      ensure      => present,
      command     => 'puppet apply /etc/puppet/manifests/masterless.pp',
      user        => root,
      hour        => '*',
      minute      => '30';
  }
  file { '/root/.gitconfig':
    ensure  => present,
    content => "[user] \n  name = Xavi Carrillo\n  email = xavi.carrillo@gmail.com\n",
  }
