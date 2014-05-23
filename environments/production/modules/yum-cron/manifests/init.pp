class yum-cron (
  $check_only = 'yes',
  $mailto     = undef,
){

  package { 'yum-cron':
    ensure => installed,
  }

  file { '/etc/sysconfig/yum-cron':
    ensure  => present,
    content => template('yum-cron/yum-cron.erb'),
  }

  service { 'yum-cron':
    enable => true,
    ensure => running,
  }

}
