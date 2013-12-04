class clamav {

  include yum::thirdparty::epel

  package { ['clamav','clamd','clamav-db']:
    ensure  => latest,
    before  => Service['clamd'],
  }

  service { 'clamd':
    ensure    => running,
    enable    => true,
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
    ensure => present,
  }

  group { 'clamav':
    ensure => present,
  }

  file { '/var/log/clamav/':
    ensure    => directory,
    owner     => 'clam',
    group     => 'clamav',
    mode      => '0775',
    recurse   => true,
    require   => [ User['clam'], Group['clamav'] ],
  }

  file { '/var/lib/clamav/':
    ensure    => directory,
    owner     => 'clam',
    group     => 'clamav',
    mode      => '0775',
    recurse   => false,
    require   => [ User['clam'], Group['clamav'] ],
  }

}
