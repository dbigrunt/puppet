class puppet::master {

    include puppet
    #include puppet::fileserver

    package { "puppet-server":
        ensure => installed,
    }

    service { "puppetmaster":
        ensure     => running,
        hasstatus  => true,
        hasrestart => true,
        enable     => true,
        require    => File["/etc/puppet/puppet.conf"],
    }

    file { "/etc/sysconfig/puppetmaster":
        ensure  => present,
        owner   => "root",
        group   => "root",
        content => template("puppet/sysconfig-puppetmaster.erb"),
        require => Class["puppet::install"],
        notify  => [ Service[puppet],Service[puppetmaster] ],
    }

}
