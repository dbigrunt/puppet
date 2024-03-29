class puppet::config {

    file { "/etc/puppet/puppet.conf":
        ensure  => present,
        owner   => "puppet",
        group   => "puppet",
        content => template("puppet/puppet.conf.erb"),
        require => Class["puppet::install"],
        notify  => Class["puppet::service"],
    }

    file { "/etc/sysconfig/puppet":
        ensure  => present,
        owner   => "root",
        group   => "root",
        content => template("puppet/sysconfig-puppet.erb"),
        require => Class["puppet::install"],
        notify  => Class["puppet::service"],
    }

}
