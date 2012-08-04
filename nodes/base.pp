node base {

    $puppetserver = "mundodisea.com"
    $resolv_searchpaths = ['jcbconsulting.biz']
    $resolv_nameservers = ['127.0.0.1','8.8.8.8','8.8.4.4']
    $resolv_options     = ['rotate','timeout:1','attempts:5']

    import "resolv"
    resolv_conf { "basenode_resolv":
        searchpath  => $resolv_searchpaths,
        nameservers => $resolv_nameservers,
        options     => $resolv_options,
    }

    #import "profile"
    include profile
    import "ntp"
    include ntp-client
    include puppet

    file { "/tmp":
        ensure => directory,
        mode => 1777,
    }

}
