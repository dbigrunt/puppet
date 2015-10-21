class transmission {
  # In order to avoid the daemon to override settings.json, you have to stop the deamon, edit, and start it
  package { 'transmission-daemon':
    ensure => installed,
  }
  file { '/var/lib/transmission/.config/transmission-daemon/settings.json':
    mode   => '0600',
    owner  => 'transmission',
    group  => 'transmission',
    source => 'puppet:///modules/torrents/settings.json',
  }
  service { 'transmission-daemon':
    enable => true,
    ensure => running,
  }
}
