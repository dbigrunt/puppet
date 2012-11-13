class rkhunter::scan {

    cron { "rkhunter scan":
        command => "rkhunter --cronjob --report-warnings-only",
        user    => root,
        hour    => 3,
        minute  => 30,
        ensure  => present
    }

}
