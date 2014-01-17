class rkhunter::scan {
  cron { 'rkhunter scan':
    ensure  => present,
    command => 'rkhunter --cronjob --report-warnings-only',
    user    => 'root',
    hour    => '3',
    minute  => '30',
  }
}
