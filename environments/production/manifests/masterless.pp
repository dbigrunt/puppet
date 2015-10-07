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

  class { 'transmission_daemon':
    download_dir   => '/var/lib/transmission/downloads',
    incomplete_dir => '/tmp/downloads',
    rpc_url        => 'bittorrent',
    rpc_port       => 9091,
    rpc_password   => 'lasmargaritas',
    rpc_whitelist  => [ ], #'195.244.215.132', # Gib
	}

  class { 'btsync': }
  btsync::shared_folder { '/var/lib/transmission/downloads/': secret => 'AZC4C5Y6UACNK227CNLKUXZ76KUJ2KWXY' }

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
  class { 'monit':
    admin          => 'xavi.carrillo@gmail.com',
    logfile        => '/var/log/monit.log',
    interval       => 60, # seconds
    only_localhost => false, # So that we can check it on  http://puppet.aislada.hi.inet:2812/ (admin/monit)
    allows         => 'admin:monit',
  }
  monit::monitor { 'clamsmtp-clamd':
    pidfile      => '/var/run/clamd.clamsmtp/clamd.pid',
    socket       => '/var/run/clamd.clamsmtp/clamd.sock',
    start_script => '/etc/init.d/clamsmtp-clamd start',
    stop_script  => '/etc/init.d/clamsmtp-clamd stop',
    checks       => ["if 3 restarts within 3 cycles then timeout"],
  }
  monit::monitor { 'spampd':
    pidfile      => '/var/run/spampd.pid',
    start_script => '/etc/init.d/spampd start',
    stop_script  => '/etc/init.d/spampd stop',
    checks       => ["if 3 restarts within 3 cycles then timeout"],
  }
  monit::monitor { 'dovecot':
    pidfile      => '/var/run/dovecot/master.pid',
    start_script => '/etc/init.d/dovecot start',
    stop_script  => '/etc/init.d/dovecot stop',
    checks       => ["if 3 restarts within 3 cycles then timeout"],
  }
  monit::monitor { 'mysqld':
    pidfile      => '/var/run/mysqld/mysqld.pid',
    socket       => '/var/lib/mysql/mysql.sock',
    start_script => '/etc/init.d/mysqld start',
    stop_script  => '/etc/init.d/mysqld stop',
    checks       => ["if 3 restarts within 3 cycles then timeout"],
  }
  monit::monitor { 'named':
    pidfile      => '/var/run/named/named.pid',
    start_script => '/etc/init.d/named start',
    stop_script  => '/etc/init.d/named stop',
    checks       => ["if 3 restarts within 3 cycles then timeout"],
  }


  class { 'yum-cron':
    mailto => 'xavi.carrillo@gmail.com',
  }
  file { '/etc/sudoers.d/xcarrillo':
    content => 'xcarrillo  ALL=(ALL) NOPASSWD:/usr/bin/yum update, /usr/bin/puppet
    ', # sudo complains if there is no carriage return
    mode    => '0440',
  }
  ssh_authorized_key { 'Xavi@tatooshiba':
    ensure => present,
    key    => 'AAAAB3NzaC1yc2EAAAADAQABAAABAQDAHFYxdcWFAj/GOvG1SEutIqd6ybne1pkkX6kJEE4UQaC0S2Gxn0/9cuXSYG1EFgTF9c/rVC/kCed5ktVC8/rCjDwyOi9BNdKsBIwLpQIDSG+8kBMsLOwIta4sq3TA9QclwEDDdF07J3zryWxB0+eoTg5jVMtQo5GQlKjRR0qv3e2ybUWM6sg4Gs82PA7du9Z3PgKLww76GkwsNJzgp83SAwUVWv27+5rf6RNjy9WzHkm/qe31zhq18rnRINUbhgkcgYBoZVGoFsO0N1VVlJ58fhXKVJpt8INmjUsnO+p4zK9pD5tCVROnysIczBeXttXaCPJ3zuVQF+G2wIFDgExb',
    type   => 'rsa',
    user   => 'xcarrillo',
  }
  ssh_authorized_key { 'xcperramon@GIB-ML013.local':
    ensure => present,
    key    => 'AAAAB3NzaC1yc2EAAAADAQABAAABAQC8AXz98WGhIUfmrBxcXQfL0FHLlJLwTloEUtxlLuYuyD3DYOeLgNHWE44m1NiiHGEzbmOzkqusPkYyEAYI+PSN5C/Xtiy/f2WHYEDK7lHDNm8t031DUlMzAbzNO+4VN6+GOJwTCjuX/MuI5lQqIJzsTvDdMGxlM9OkF9ingbOwDLH8+HwE8deHOYtGV0B4Ppb/oiz1SPl0GXQYSP8qsvo/ciOcrhM8Q4qgjvWMV6vKvVq5B8PSkTaLqPLXcNSVAK4WK4SU7i9w7ZVNd5+Bz/5yqKM2nH1/kluH7pmcze6wO0pW2tYBMPwceY15IbpcsH7R3qEzDoMfD6HAszyueStH', 
    type   => 'rsa',
    user   => 'xcarrillo',
  }

  service { 'rsyslog':
    ensure => 'running',
    enable => true,
  }
  cron {
    'Masterless puppet':
      ensure  => present,
      command => 'puppet apply /etc/puppet/environments/production/manifests/masterless.pp --modulepath=/etc/puppet/environments/production/modules | grep -v Notice',
      user    => root,
      hour    => '3',
      minute  => '30',
  }
  file { '/root/.gitconfig':
    ensure  => present,
    content => "[user] \n  name = Xavi Carrillo\n  email = xavi.carrillo@gmail.com\n",
  }
