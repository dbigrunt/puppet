node 'falcon.jcbconsulting.biz' inherits base {
    #import profile
    #include vim, syslog-ng

    file { "/var/log/clamav/":
        owner  => 'clamav',
        group  => 'clamav',
        mode   => 775,
		ensure => directory,
		recurse => true,
    }

}
