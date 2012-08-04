class puppet::master {

    include puppet
    include puppet::fileserver

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
        content => template("/etc/puppet/files/etc/sysconfig/puppetmaster"),
        require => Class["puppet::install"],
        notify  => Service["ntpd"],
    }

}
