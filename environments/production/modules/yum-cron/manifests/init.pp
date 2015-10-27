class yum-cron (
  $apply_updates = 'no',
  $email_from,
  $email_to,
){

  package { 'yum-cron':
    ensure => installed,
  }

  file { '/etc/yum/yum-cron.conf':
    ensure  => present,
    content => template('yum-cron/yum-cron.conf.erb'),
    notify  => Service['yum-cron'],
  }

  service { 'yum-cron':
    enable => true,
    ensure => running,
  }

}
