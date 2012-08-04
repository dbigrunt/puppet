class puppet::config {

    file { "/etc/puppet/puppet.conf":
        ensure  => present,
        owner   => "puppet",
        group   => "puppet",
        content => template("/etc/puppet/files/etc/puppet/puppet.conf.erb"),
        require => Class["puppet::install"],
        notify  => Class["puppet::service"],
    }

    file { "/etc/sysconfig/puppet":
        ensure  => present,
        owner   => "root",
        group   => "root",
        content => template("/etc/puppet/files/etc/sysconfig/puppet"),
        require => Class["puppet::install"],
        notify  => Class["puppet::service"],
    }

}
