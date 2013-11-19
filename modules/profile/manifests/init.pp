class profile {
  file { '/etc/profile.d':
    ensure  => directory,
    source  => 'puppet:///files/etc/profile.d',
    recurse => false,
    purge   => false,
    ignore  => ['.svn','svn'],
    owner   => 'root',
    group   => 'root',
  }
}

