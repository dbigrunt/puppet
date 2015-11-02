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
#  cron {
#    'Masterless puppet':
#      ensure  => present,
#      command => 'puppet apply /etc/puppet/environments/production/manifests/masterless.pp --modulepath=/etc/puppet/environments/production/modules | grep -v Notice',
#      user    => root,
#      hour    => '3',
#      minute  => '30',
#  }
 
  include yum
  include yum::thirdparty::epel
  #include backup
  #include ntp # doesnt seem to work on centos7 with the new ovh vps: cap_set_proc() failed to drop root privileges: Operation not permitted
  include ssh
  #include collectd
  #include monitoritzacio
  include cosmetic
  include cosmetic::vim
  include dns
  include web
  include db
  #include mail
  include torrents

  class { 'monit':
    admin          => 'xavi.carrillo@gmail.com',
    logfile        => '/var/log/monit.log',
    interval       => 60, # seconds
    allows         => 'admin:monit',
    only_localhost => false, # So that we can check it on  http://puppet.aislada.hi.inet:2812/ (admin/monit)
  }
  monit::monitor { 'amavis':
    pidfile      => '/var/run/clamd.amavisd/clamd.pid',
    start_script => '/bin/systemctl start amavisd',
    stop_script  => '/bin/systemctl stop amavisd',
    checks       => ["if 3 restarts within 3 cycles then timeout"],
  }

  monit::monitor { 'spamassassin':
    pidfile      => '/var/run/spampd.pid',
    start_script => '/bin/systemctl start spamassassin',
    stop_script  => '/bin/systemctl stop spamassassin',
    checks       => ["if 3 restarts within 3 cycles then timeout"],
  }
  monit::monitor { 'dovecot':
    pidfile      => '/var/run/dovecot/master.pid',
    start_script => '/bin/systemctl start dovecot',
    stop_script  => '/bin/systemctl stop dovecot',
    checks       => ["if 3 restarts within 3 cycles then timeout"],
  }
  monit::monitor { 'mariadb':
    pidfile      => '/var/run/mariadb/mariadb.pid',
    socket       => '/var/lib/mysql/mysql.sock',
    start_script => '/bin/systemctl start mariadb',
    stop_script  => '/bin/systemctl stop mariadb',
    checks       => ["if 3 restarts within 3 cycles then timeout"],
  }
  monit::monitor { 'named':
    pidfile      => '/var/run/named/named.pid',
    start_script => '/bin/systemctl start monit',
    stop_script  => '/bin/systemctl stop monit',
    checks       => ["if 3 restarts within 3 cycles then timeout"],
  }
  monit::monitor { 'httpd':
    pidfile      => '/var/run/httpd/httpd.pid',
    start_script => '/bin/systemctl start httpd',
    stop_script  => '/bin/systemctl stop httpd',
    checks       => ["if 3 restarts within 3 cycles then timeout"],
  }



  class { 'yum-cron':
    email_from => "$::id@$::fqdn",
    email_to   => 'xavi.carrillo@gmail.com',
  }
  user { 'xcarrillo':
    ensure     => present,
    password   => '$6$qeB1K1QC$lFw0uc0iKvPACE3IL0YUeinMNMJZRvIX/eLBtRTDwEn1u4MsW0fx17Iz..ERqIRwnmqXKHEgBYQlTp1yx5y/G/',
    home       => '/home/xcarrillo',
    managehome => true,
  } 
  file { '/home/xcarrillo':
    ensure => directory,
    owner  => 'xcarrillo',
    group  => 'xcarrillo',
  }
  package { 'sudo':
    ensure => installed,
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
  ssh_authorized_key { 'xcarrillo@GIB-ML013.local':
    ensure => present,
    key    => 'AAAAB3NzaC1yc2EAAAADAQABAAABAQC8AXz98WGhIUfmrBxcXQfL0FHLlJLwTloEUtxlLuYuyD3DYOeLgNHWE44m1NiiHGEzbmOzkqusPkYyEAYI+PSN5C/Xtiy/f2WHYEDK7lHDNm8t031DUlMzAbzNO+4VN6+GOJwTCjuX/MuI5lQqIJzsTvDdMGxlM9OkF9ingbOwDLH8+HwE8deHOYtGV0B4Ppb/oiz1SPl0GXQYSP8qsvo/ciOcrhM8Q4qgjvWMV6vKvVq5B8PSkTaLqPLXcNSVAK4WK4SU7i9w7ZVNd5+Bz/5yqKM2nH1/kluH7pmcze6wO0pW2tYBMPwceY15IbpcsH7R3qEzDoMfD6HAszyueStH', 
    type   => 'rsa',
    user   => 'xcarrillo',
  }

  package { 'rsyslog':
    ensure => installed,
  }
  service { 'rsyslog':
    ensure => 'running',
    enable => true,
  }
 file { '/root/.gitconfig':
    ensure  => present,
    content => "[user] \n  name = Xavi Carrillo\n  email = xavi.carrillo@gmail.com\n",
  }
