define motd::populate  (

    $messages = []

){
    file { "/etc/motd":
        owner   => root,
        group   => root,
        mode    => 644,
        content => template("/etc/puppet/files/etc/motd.erb"),
    }
}

