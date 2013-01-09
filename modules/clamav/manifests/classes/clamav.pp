class clamav {

  package { ['clamav','clamd','clamav-db']:
    ensure    => installed,
    provider  => 'yum',
    before    => Service['clamd'],
  }

  service { 'clamd':
    ensure    => running,
    enable    => true,
    hasstatus => true,
    require   => Package['clamd'],
  }

  user { 'clam':
    comment   => 'Clam Anti Virus Checker',
    home      => '/var/clamav',
    shell     => '/sbin/nologin',
    groups    => 'clam',
  }

  user { 'clamav':
    comment   => 'Clam Anti Virus Checker',
    home      => '/var/clamav',
    shell     => '/sbin/nologin',
    groups    => 'clam',
  }

  group { 'clam':
    require   => user['clam'],
  }

  file { '/var/log/clamav/':
    ensure    => directory,
    owner     => 'clam',
    group     => 'clamav',
    mode      => 775,
    recurse   => true,
  }

  file { '/var/lib/clamav/':
    ensure    => directory,
    owner     => 'clam',
    group     => 'clamav',
    mode      => 775,
    recurse   => false,
  }

}
