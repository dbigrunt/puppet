class btsync::service inherits btsync {
  service { 'btsync':
    ensure    => $service_ensure,
    enable    => $service_enable,
  }
  file { '/etc/init.d/btsync':
    mode   => '0755',
    owner  => root,
    group  => root,
    source => 'puppet:///modules/btsync/init.d/btsync',
  }
}
