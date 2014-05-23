class puppet::fileserver {

    file { "/etc/puppet/fileserver.conf":
        ensure  => present,
        owner   => "root",
        group   => "root",
        content => template("puppet/fileserver.conf.erb"),
        require => Class["puppet::install"],
        notify  => Class["puppet::service"],
    }

}
