class profile {

    file { "/etc/profile.d":
        ensure    => directory,
        #source    => "puppet:///files/profile.d",
        source    => "/etc/puppet/files/profile.d",
        recurse   => "false",
        purge     => "false",
        ignore    => [".svn","svn"],
        owner     => "root",
        group     => "root",
    }

}
