class ocsinventory::agent {

	$install_ocs_agent=extlookup("ocsinventory::agent::install","no")

        package { "Ocsinventory-Unix-Agent":
                ensure => $install_ocs_agent ? {
                        yes => latest,
                        default => absent,
                },
                provider => "yum",
        }

	concat::puppetinfo::register { "ocsinventory agent": content=>"OCS Inventory installed  : ${install_ocs_agent}" }

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

	# Remove old configs
	file {'/etc/ocsinventory-agent':
		ensure  => absent,
		recurse => true,
		recurselimit => 1,
		force => true,
	}

	# Remove old server's cache
        file {'/var/lib/ocsinventory-agent/http:__unix.mal.esportz.com_ocsinventory':
                ensure  => absent,
		recurse => true,
		recurselimit => 1,
                force => true,
        }
}
