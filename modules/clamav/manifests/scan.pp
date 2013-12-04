define clamav::scan ( $directory ) {

    cron { "clamav scan":
        command => "clamscan --infected --recursive $directory",
        user    => root,
        hour    => 3,
        minute  => 54,
        ensure  => present
    }

}
