# Simple NTP client class andd server definition
#
# Usage: include ntp-client
#        ntp-server { $hostname: servers => [ "ntp1", "ntp2" ] }

class ntp-client {
    ntpd { $hostname: servers => [ "0.centos.pool.ntp.org" ] }
}

define ntp-server ( $servers ) {
    ntpd { $title: servers => $servers }
    # Iptables configuration
    iptables { "/etc/sysconfig/iptables":
        udpports => [ "123" ],
    }
}

define ntpd ( $servers ) {

    # Main package and service it provides
    package { "ntp": ensure => installed }
    service { "ntpd":
        require   => Package["ntp"],
        enable    => true,
        ensure    => running,
        hasstatus => true,
    }

    # Main configuration file
    file { "/etc/ntp.conf":
        require => Package["ntp"],
        content => template("/etc/puppet/files/etc/ntp.conf.erb"),
        notify  => Service["ntpd"],
    }

    # Logrotate for our custom log file
    file { "/etc/logrotate.d/ntpd":
        #source => "puppet:///files/etc/logrotate.d/ntpd",
        source => "/etc/puppet/files/etc/logrotate.d/ntpd",
    }

}

