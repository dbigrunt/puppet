
class ntp ($servers = [ '0.centos.pool.ntp.org' ],) {

  case $::osfamily{
    'Debian':  {
      $service_name = 'ntp'
    }
    'RedHat':  {
      $service_name = 'ntpd'
    }
    default: {
      fail("Unsupported platform: ${::operatingsystem}")
    }
  }

  $packages = 'ntp'
  package { $packages: ensure => 'latest' }

  service { $service_name:
    ensure  => 'running',
    enable  => true,
    require => Package['ntp'],
  }

  file { '/etc/ntp.conf':
    require => Package['ntp'],
    notify  => Service[$service_name],
    content => template('ntp/ntp.conf.erb'),
  }

  file { '/etc/logrotate.d/ntpd':
    source => 'puppet:///ntp/logrotate.d/ntpd',
  }

}

