class cacti::server {

    # remember to add
    #         monitored_by_cacti => true,
    # on the node if the client we are going to monitor is a MySQL server

    package { [
            "cacti",
	    "rrdtool",
	    "net-snmp",
	    "net-snmp-utils",
	     ]:
        ensure => installed,
    }

    # MySQL configuration
    yumrepo-egwn { "mysql51": enabled => 1 }
    $mysql_rootpw = "j3Iv6oyF"
    $mysql_cactiuserpw = "7gg7dDQs"
    $mysql_cactiadminpw = "tkJ56Awr"
    include mysql2::server
    mysql2::server::configure { $hostname: skipnetworking => true }
    #mysql2::server::backup { $hostname: }
    mysql_database { "cacti": ensure => present }
    mysql_user { "cactiuser@localhost":
        ensure => present,
        password_hash => mysql_password("$mysql_cactiuserpw"),
    }
    mysql_grant { "cactiuser@localhost/cacti":
        privileges => "all",
    }
 


    # PHP Configuration (modules alphabetically)
    php { $title:
        modules  => [
	    "ldap",
            "mysql",
            "snmp",
        ],
    }

    # Apache Configuration (modules in original httpd.conf order)
    apacheconf { $title:
        require => Php[$title],
        modules => [
            "authz_host",
            #"env",
            "mime",
            "status",
            #"info",
            "dir",
            "alias",
            "rewrite",
        ],
        php => true,
    }
   
    $cacti_mysql_schema = "/usr/share/doc/cacti-$cacti_version/cacti.sql" # $cacti_version is taken via facter
    $sqlcmd = "mysql -u cactiuser -p$mysql_cactiuserpw cacti"

    exec { "$sqlcmd < $cacti_mysql_schema":
        onlyif => "ls $cacti_mysql_schema",
        unless => "$sqlcmd -e 'select id from graph_templates'", #if this table exists, the db has already been created
        path => "/bin:/usr/bin",
    }
    exec { "$sqlcmd -e \"update user_auth set password=PASSWORD('$mysql_cactiadminpw') where username='admin';\"":
        path => "/bin:/usr/bin",
    }

    #to avoid redirect to /cacti/install/index.php
    exec { "$sqlcmd -e \"update version set cacti='$cacti_version'\"": 
        path => "/bin:/usr/bin",
    }
    exec { "$sqlcmd -e \"INSERT INTO settings VALUES ('path_rrdtool','/usr/bin/rrdtool'),('path_php_binary','/usr/bin/php'),('path_snmpwalk','/usr/bin/snmpwalk'),('path_snmpget','/usr/bin/snmpget'),('path_snmpbulkwalk','/usr/bin/snmpbulkwalk'),('path_snmpgetnext','/usr/bin/snmpgetnext'),('path_cactilog','/usr/share/cacti/log/cacti.log'),('snmp_version','net-snmp'),('rrdtool_version','rrd-1.2.x');\"":
        path => "/bin:/usr/bin",
    }
    file { "/etc/httpd/conf.d/cacti.conf":
        source => "puppet:///modules/cacti/etc/httpd/conf.d/cacti.conf",
        notify  => Service["httpd"],
    }
    file { "/usr/share/cacti/include/db.php":
        content => template("cacti/db.php.erb"),
    }
}
