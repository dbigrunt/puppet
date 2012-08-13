node 'falcon.jcbconsulting.biz' inherits base {

    $puppet_fileserver_allowed = [ '*.mundodisea.com', '*.jcbconsulting.biz', 'ks391417.kimsufi.com' ] 

    include puppet::master

    include clamav
    clamav::scan { "$name":
        directory => "/var/www/vhosts",
    }

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
        '---',
      ]
    }


    cron {
        "backup sql clean":
          environment => "MAILTO=di4blo@gmail.com",
          command => "find /var/backup/rdiff/local/mysql/ -type f -mtime +7 -exec rm -f {} \;",
          user    => root,
          hour    => 2,
          minute  => 40,
          ensure  => present;

        ### esborrem els mails d'spam que estan bouncejan ###
        "qmailclean":
          command => "/opt/scripts/qmail/qmailclean.sh",
          user    => root,
          hour    => 2,
          minute  => 50,
          ensure  => present;

        # Si algun domini caduca en 30 dies o menys, ens avisa. Ojo, els .es no els mira
        "whois":
          command => "/opt/scripts/whois.sh",
          user    => root,
          hour    => 3,
          minute  => 10,
          ensure  => present;

        # esborrem els backups mes antics de 2 setmanes
        "esborra-rdiff":
          command => "/opt/scripts/rdiff-esborra.sh /var/backup/rdiff/remot/ks391417.kimsufi.com 2W",
          user    => root,
          hour    => 5,
          minute  => 20,
          ensure  => present;

        # Backup servidor namesti
        "rdiff-backup namesti":
          command => "rdiff-backup --print-statistics --exclude=/lost+found --exclude=/var/log --exclude=/proc --exclude=/sys --exclude=/usr/backup --exclude-special-files --exclude-other-filesystems --force ks391417.kimsufi.com::/  /var/backup/rdiff/remot/ks391417.kimsufi.com",
          user    => root,
          hour    => 5,
          minute  => 30,
          ensure  => present;

        ## cada dia fem un backup de la bbdd i esborrem els mes vells de 7dies
        "backup sql":
          command => "/opt/scripts/backup_sql.sh",
          user    => root,
          hour    => 2,
          minute  => 20,
          ensure  => present;

        ### Logins Orange FTP ###
        "logins orange ftp":
          command => "/opt/scripts/logins_ftp.sh orange jcaguilera@zedis.com",
          user    => root,
          hour    => 23,
          minute  => 58,
          ensure  => present;
    }
}
