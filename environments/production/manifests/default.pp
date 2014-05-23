node default {

  $puppetserver = 'vps38933.ovh.net'

  include yum
  include ntp
  include puppet
  include ssh

  class { 'resolv':
    searchpath  => [ 'jcbconsulting.biz' ],
    nameservers => [ '127.0.0.1','8.8.8.8','8.8.4.4' ],
    options     => [ 'rotate','timeout:1','attempts:5' ],
  }

  file { '/tmp':
    ensure => directory,
    mode   => 1777,
  }
}
