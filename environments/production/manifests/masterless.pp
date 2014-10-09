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
  ssh_authorized_key { 'Xavi@tatooshiba':
    ensure => present,
    key    => 'AAAAB3NzaC1yc2EAAAADAQABAAABAQDAHFYxdcWFAj/GOvG1SEutIqd6ybne1pkkX6kJEE4UQaC0S2Gxn0/9cuXSYG1EFgTF9c/rVC/kCed5ktVC8/rCjDwyOi9BNdKsBIwLpQIDSG+8kBMsLOwIta4sq3TA9QclwEDDdF07J3zryWxB0+eoTg5jVMtQo5GQlKjRR0qv3e2ybUWM6sg4Gs82PA7du9Z3PgKLww76GkwsNJzgp83SAwUVWv27+5rf6RNjy9WzHkm/qe31zhq18rnRINUbhgkcgYBoZVGoFsO0N1VVlJ58fhXKVJpt8INmjUsnO+p4zK9pD5tCVROnysIczBeXttXaCPJ3zuVQF+G2wIFDgExb',
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
      hour    => '*',
      minute  => '30',
  }
  file { '/root/.gitconfig':
    ensure  => present,
    content => "[user] \n  name = Xavi Carrillo\n  email = xavi.carrillo@gmail.com\n",
  }
