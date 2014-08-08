class dropbox (
  $users = '',
) {
  # First install the binaries: http://www.dropboxwiki.com/tips-and-tricks/install-dropbox-centos-gui-required
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

  
