define resolv_conf (

    $domainname = "$domain",
    $searchpath,
    $nameservers,
    $options

) {

    file { "/etc/resolv.conf":
        owner   => root,
        group   => root,
        mode    => 644,
        content => template("/etc/puppet/files/etc/resolv.erb"),
    }

}
