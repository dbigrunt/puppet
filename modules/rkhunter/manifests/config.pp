class rkhunter::config {

    file { "/etc/rkhunter.conf":
        require => Class["puppet::install"],
        owner   => "root",
        group   => "root",
        mode    => 640,
        content => template("rkhunter/rkhunter.conf.erb"),
    }

}

