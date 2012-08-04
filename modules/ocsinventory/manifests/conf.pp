class ocsinventory::conf {

	$ocs_server=extlookup("ocsinventory::conf::server","inventory-1.mit.esportz.com")
	$install_ocs_agent=extlookup("ocsinventory::agent::install","no")
	$ocsinventory_tag=extlookup("ocsinventory::conf::tag","default" )

	concat::puppetinfo::register { "ocsinventory server": content=>"OCS Inventory server : ${ocs_server}" }
	concat::puppetinfo::register { "ocsinventory server tag": content=>"OCS Inventory tag : ${ocsinventory_tag}" }

        file { "/etc/ocsinventory":
                owner  => root,
                group  => root,
                mode   => 770,
                ensure => $install_ocs_agent ? {
                        yes => directory,
                        default => absent,
                },
                force => true,
        }

        file { "/etc/ocsinventory/ocsinventory-agent.cfg":
                content => template("ocsinventory/ocsinventory-agent.cfg.erb"),
                owner   => root,
                group   => root,
                mode    => 660,
                ensure  => $install_ocs_agent ? {
                        yes => present,
                        default => absent,
                },
                require => File["/etc/ocsinventory"]
        }

        file { '/usr/bin/update-adm.pl':
                content => template("ocsinventory/update-adm.pl.erb"),
                owner   => root,
                group   => root,
                mode    => 775,
                ensure  => $install_ocs_agent ? {
                        yes => file,
                        default => "absent",
                },
                require => Package["Ocsinventory-Unix-Agent"],
        }
}

