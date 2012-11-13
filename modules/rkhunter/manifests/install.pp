class rkhunter::install {

    package { "rkhunter":
        ensure   => "installed",
        provider => "yum"
    }

}
