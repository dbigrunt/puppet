class ssh {

  $banner = ""

  case $::osfamily{
    'Debian':  {
      $ssh_packages = [ 'openssh-client', 'openssh-server' ]
      $service_name = 'ssh'
    }
    'RedHat':  {
      $ssh_packages = [ 'openssh', 'openssh-server' ]
      $service_name = 'sshd'
    }
    default: {
      fail("Unsupported platform: ${::operatingsystem}")
    }
  }
  package { $ssh_packages: ensure => 'latest' }
  service { $service_name: ensure => 'running' }

  file {'/etc/banner':
    content => $banner,
  }

  # Make sure that the root login is not allowed, nothing else (so that the RE can change sshd_config if they want to)
  augeas { "sshd_config":
    changes => [
      "set /files/etc/ssh/sshd_config/PermitRootLogin no",
    ],
    notify => Service[$service_name],
  }
}

