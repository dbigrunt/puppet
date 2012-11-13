node 'falcon.jcbconsulting.biz' inherits base {

        																				   # os_specific: related to kernel modules, which we don't use
	$administrator_email       = 'di4blo@gmail.com'
    $puppet_fileserver_allowed = [ '*.mundodisea.com', '*.jcbconsulting.biz', 'ks391417.kimsufi.com' ] 
    $rkhunter_disable_tests    = [ 'suspscan hidden_procs deleted_files packet_cap_apps apps os_specific' ]
    $rkhunter_xinetd_allowed   = [ 'echo','ftp_psa','poppassd_psa','smtp_psa','smtps_psa', 'submission_psa' ]

    include puppet::master

    include clamav
    clamav::scan { "$name":
        directory => "/var/www/vhosts",
    }

    include rkhunter

    import "/etc/puppet/manifests/tga.es.pp"

#En un futur fer classe named, o inclus considerar powerdns
#Recordar que aquest logrotate s'ha fet perque hem afegit estadistiques a /etc/named.conf:
#logging {
#
#    channel debug_log {
#        file "/var/log/debug.log";
#        severity debug 3;
#        print-category yes;
#        print-severity yes;
#        print-time yes;
#    };
#
#    channel query_log {
#        file "/var/log/query.log";
#        severity dynamic;
#        print-category yes;
#        print-severity yes;
#        print-time yes;
#    };
#
#    category resolver { debug_log; };
#    category security { debug_log; };
#    category queries { query_log; };
#
#};


    file { "/etc/logrotate.d/named":
        ensure  => file,
        owner   => "root",
        group   => "named",
        mode    => 644,
        content => file("/etc/puppet/files/etc/logrotate.d/named"),
    }

    file { "/etc/logrotate.d/psa-ftp":
        ensure  => file,
        owner   => "root",
        group   => "root",
        mode    => 644,
        content => file("/etc/puppet/files/etc/logrotate.d/psa-ftp"),
    }

    file { "/etc/logrotate.d/psa-maillog":
        ensure  => file,
        owner   => "root",
        group   => "root",
        mode    => 644,
        content => file("/etc/puppet/files/etc/logrotate.d/psa-maillog"),
    }

#    include nginx
#
#    nginx::site { "mundodisea":
#        domain => "mundodisea.com",
#        aliases => ["www.mundodisea.com"],
#        default_vhost => true,
#        root => "/var/www/vhosts/mundodisea.com/httpdocs/",
#        owner => "mundodisea",
#        group => "apache",
#        ssl => false,
#        #ssl_certificate => "/etc/nginx/cert/uggedal.com.pem",
#        #ssl_certificate_key => "/etc/nginx/cert/uggedal.com.key",
#    }

    import "/etc/puppet/modules/motd/manifests/definitions/motd.pp"
    motd::populate { "$domain": 
      messages => [ 
        'Afegir mailbox: /usr/local/psa/bin/mail.sh -c gerand77@laseu.net -passwd XXX -cp_access true -mailbox true -passwd_type plain -mbox_quota 2G',
        '---',
        'Thu Sep 16 13:52:29 CEST 2010: fundacion-estudio.es y colegio-estudio.com han estat migrats a un server seu (subdominis encara aqui)',
        '---',
        'Tue Oct  4 10:18:30 CEST 2011: Canviats els timeouts del proftpd a 0 perque a zedis no els hi resseteji la connexio',
        '---',
        '=== Subdominis de colegio-estudio ===',
        'Si es toca algun subdomini de colegio-estudio via Plesk, fer un backup del DNS perque sobreescriu tots els canvis fets a ma i mirar que vagin tots',
        '- Un cop creat el subdomini a plesk, editar /var/www/vhosts/colegio-estudio.com/subdomains/cienciaestudio/conf/vhost.conf',
        'amb Redirect        /       https://sites.google.com/a/colegio-estudio.com/cienciaestudio/',
        '- Editar el VirtualHost a /var/www/vhosts/colegio-estudio.com/conf/httpd.include',
        'amb un       Include /var/www/vhosts/colegio-estudio.com/subdomains/cienciaestudio/conf/vhost.conf',
        '(ho hauria de fer el plesk pero no ho fa)',
        '---',
        'bodegasplv.com necessita PHP >= 5.2. Esta instalat com a CGI a /var/www/vhosts/bodegasplv.com/cgi-bin/ i activat via htaccess',
        'pero ja no esta al nostre servidor. Desactivat el 9/10/2012',
        '---',
        '10/10/2012: .Afegit motorelectricopasion.com  Info a doku.php?id=personal:negocis&#motorelectricopasioncom',
        '---',
        '18/10/2012: Esborrat /var/tmp perque el 24/sep el sistema va ser compromes via apache (probablement Plesk).76Gb de warez. memodipper trobat xo no aconsegueix root',
        'He desinstalat gcc', 
        '---',
        '20/10/2012: Despres dactualitzar Plesk, la llicencia no es valida. Com que OVH no contesta decideixo instalar lighttpd',
        'el php-cgi (es el que fa servir lighttpd) ara es un symlink a la ultima versio que vaig compilar per motorelectricopasion: /usr/bin/php-cgi -> php5.4.7-cgi',
        '22/10/2012: Actualitzen la llicencia i torno a posar Apache',
        '23/10/2012: /usr/local/psa/var/log/maillog no es rotava. Afegeixo /etc/logrotate.d/psa-maillog, que funciona, pero maillog ja no sactualitza mes',
      ]
    }


    cron {

        # Si algun domini caduca en 30 dies o menys, ens avisa. Ojo, els .es no els mira
        "whois":
          environment => "MAILTO=di4blo@gmail.com",
          command     => "/opt/scripts/whois.sh",
          user        => root,
          hour        => 3,
          minute      => 10,
          ensure      => present;

       # cada dia fem un backup de la bbdd 
        "backup sql":
          command     => "/opt/scripts/backup_sql.sh",
          user        => root,
          hour        => 2,
          minute      => 20,
          ensure      => present;

        # esborrem els mails d'spam que estan bouncejan ###
        "qmailclean":
          command => "/opt/scripts/qmail/qmailclean.sh",
          user    => root,
          hour    => 2,
          minute  => 50,
          ensure  => present;

        # esborrem els backups mes antics de 2 setmanes
        "esborra-rdiff":
          command => "rdiff-backup --force --remove-older-than 2W /var/backup/rdiff/remot/ks391417.kimsufi.com/",
          user    => root,
          hour    => 5,
          minute  => 20,
          ensure  => present;

        # Backup servidor namesti
        "rdiff-backup namesti":
          command => "rdiff-backup --print-statistics --exclude=/lost+found --exclude=/var/log --exclude=/proc --exclude=/sys --exclude=/var/backup/rdiff  --exclude=/var/named/run-root/proc  --exclude-special-files --force ks391417.kimsufi.com::/  /var/backup/rdiff/remot/ks391417.kimsufi.com",
          user    => root,
          hour    => 5,
          minute  => 30,
          ensure  => present;

        # Logins Orange FTP
        "logins orange ftp":
          command => "/opt/scripts/logins_ftp.sh orange jcaguilera@zedis.com",
          user    => root,
          hour    => 23,
          minute  => 58,
          ensure  => present;
    }
}
