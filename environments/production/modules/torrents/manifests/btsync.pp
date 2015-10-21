class btsync {
  # Install the binary on /usr/bin from https://www.getsync.com/
  # Once btsync is running, go to hastaelfindelmundo.net:8888/gui/ and set up a shared folder . By doing so we don't upload the SECRETKEY to github
  file { '/etc/init.d/btsync':
    mode   => '0755',
    source => 'puppet:///modules/torrents/etc/init.d/btsync',
  }
  file { '/etc/btsync.conf.json':
    mode   => '0640',
    source => 'puppet:///modules/torrents/etc/btsync.conf.json',
  }
  file { '/var/run/btsync':
    ensure => directory,
  }
  service { 'btsync':
    enable => true,
    ensure => running,
  }
}
