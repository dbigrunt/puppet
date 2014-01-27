class rkhunter (
  $administrator_email     = undef,
  $rkhunter_xinetd_allowed = undef,
  $rkhunter_disable_tests  = undef,
  $allowdevfiles           = undef,
  $allow_ssh_root_user     = 'no',
) {
  package { 'rkhunter':
    ensure  => installed,
  }
  file { '/etc/rkhunter.conf':
    content => template('rkhunter/rkhunter.conf.erb'),
  }
  cron { 'rkhunter scan':
    ensure  => present,
    command => 'rkhunter --cronjob --report-warnings-only',
    user    => 'root',
    hour    => '3',
    minute  => '30',
  }
}
