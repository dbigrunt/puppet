class ocsinventory::agent {

    package { "Ocsinventory-Unix-Agent":
        ensure => $install_ocs_agent ? {
            yes => latest,
            default => absent,
        },
        provider => "yum",
    }

	file { '/etc/cron.daily/ocsinventory-agent':
		content => template("ocsinventory/ocsinventory-agent-cron.erb"),
        owner   => root,
		group   => root,
		mode    => 775,
		ensure  => $install_ocs_agent ? {
			yes => file,
			default => "absent",
		},
	    require => Package["Ocsinventory-Unix-Agent"],
    }

	# Remove old packages
	package { "Ocsinventory-Agent":
		ensure => absent,
		provider => "yum",
	}

	# Remove old cron files
	tidy { "/etc/cron.d":
        matches => "ocsinventory-agent",
		recurse => true,
	}
	tidy { "/etc/cron.daily":
		matches => ["ocsinventoryagent", "ocsinventor-yagent"],
		recurse => true,
    }

}
