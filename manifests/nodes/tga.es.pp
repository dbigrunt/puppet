
    file { "/var/www/vhosts/tga.es/httpdocs/.htaccess":
        ensure  => present,
        owner   => "root",
        group   => "root",
        mode    => 644,
        content => file("/etc/puppet/files/var/www/vhosts/tga.es/httpdocs/.htaccess"),
    }

