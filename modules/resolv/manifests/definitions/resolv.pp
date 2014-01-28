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
        content => template('resolv/resolv.erb'),
    }

}
