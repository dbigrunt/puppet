class dropbox (
  $users = '',
) {
  file { '/etc/init.d/dropbox':
    ensure => present,
    source => 'puppet:///modules/dropbox/init.d_dropbox',
    mode   => '0750',
  }
  file { '/etc/sysconfig/dropbox':
    ensure  => present,
    content => template('dropbox/sysconfig_dropbox.erb'),
  }
  service { 'dropbox':
    ensure => running,
    enable => true,
  }
}

  
