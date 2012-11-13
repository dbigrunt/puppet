class clamav {

	package { ["clamav","clamd","clamav-db"]:
		ensure   => installed,
		before   => Service["clamd"],
		provider => "yum"
	}

	service { "clamd":
		ensure    => running,
		enable    => true,
        hasstatus => true,
        require   => Package["clamd"]
	}

    user { clam:
        comment => "Clam Anti Virus Checker",
        home    => "/var/clamav",
        shell   => "/sbin/nologin",
        #uid     => 118,
		groups  => "clam",
    }

    user { clamav:
        comment => "Clam Anti Virus Checker",
        home    => "/var/clamav",
        shell   => "/sbin/nologin",
        #uid     => 115,
        groups  => "clam",
    }

    group { clam:
        #gid     => 118,
        require => user[clam],
    }

    file { "/var/log/clamav/":
        owner   => 'clamav',
        group   => 'clamav',
        mode    => 775,
		ensure  => directory,
		recurse => true,
    }

    file { "/var/lib/clamav/":
        owner   => 'clam',
        group   => 'clamav',
        mode    => 775,
        ensure  => directory,
        recurse => false,
    }

}
