define lsyncd::server (

    $sourcedir,
    $targetdir,
    $slaves     = [],
    $logfile    = "/var/log/lsyncd.log",
    $nodaemon   = false,
    $remoteuser = repomaster, 
    $exclude    = [],
    $rsyncOps   = ["--archive","--recursive","--verbose","--delete"]

) {

    package { "lsyncd": ensure => "2.0.7-0ito", provider => "yum" }

    service { "lsyncd":
        require   => Package["lsyncd"],
        enable    => true,
        ensure    => running,
        hasstatus => true,
    }

    file { "/etc/lsyncd.conf":
        require => Package["lsyncd"],
        notify  => Service["lsyncd"],
        content => template("/etc/puppet/resources/lsyncd/templates/lsyncd.conf.erb"),
    }

    file { "/etc/init.d/lsyncd":
        owner   => root,
	    group   => root,
	    mode    => 755,
        content => template("/etc/puppet/resources/lsyncd/files/lsyncd-init"),
    }


    # All the files on the RPMs directory must be repomaster:apache in order to the rsync to work
    file { "/var/www/rpms":
        ensure  => directory,
        recurse => true,
        force   => true,
        owner   => "repomaster",
        group   => "apache",
	}

}

