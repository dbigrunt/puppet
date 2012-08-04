class puppet::fileserver {

    file { "/etc/puppet/fileserver.conf":
        ensure  => present,
        owner   => "root",
        group   => "root",
        content => template("/etc/puppet/files/etc/puppet/fileserver.conf.erb"),
        require => Class["puppet::install"],
        notify  => Class["puppet::service"],
    }

}
