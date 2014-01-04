node 'vps38933.ovh.net' inherits default {

  $administrator_email       = 'xavi.carrillo@gmail.com'
  $puppet_fileserver_allowed = [ '*.jcbconsulting.biz', 'vps38933.ovh.net' ] 
  $rkhunter_xinetd_allowed   = [ 'echo','ftp_psa','poppassd_psa','smtp_psa','smtps_psa', 'submission_psa' ]
  $rkhunter_disable_tests    = [ 'suspscan hidden_procs deleted_files packet_cap_apps apps os_specific' ]
  # os_specific: related to kernel modules, which we don't use

  include puppet::master
  include rkhunter
  include cosmetic
  include cosmetic::vim
  #include clamav

  include bind
  bind::server::conf { '/etc/named.conf':
    listen_on_addr    => [ 'any' ],
    listen_on_v6_addr => [ 'any' ],
    forwarders        => [ '8.8.8.8', '8.8.4.4' ],
    allow_query       => [ 'any' ],
    zones             => {
      'mundodisea.com' => [
        'type master',
        'file "mundodisea.com"',
      ],
      'jcbdns.com' => [
        'type master',
        'file "jcbdns.com"',
      ],
      'jcbconsulting.biz' => [
        'type master',
        'file "jcbconsulting.biz"',
      ],
      'tga.es' => [
        'type master',
        'file "tga.es"',
      ],
      'maricel.es' => [
        'type master',
        'file "maricel.es"',
      ],
      '188.31.176.in-addr.arpa' => [
        'type master',
        'file "188.31.176.in-addr.arpa"',
      ],
    },
  }
  bind::server::file { 'mundodisea.com':
    source => 'puppet:///modules/bind/mundodisea.com',
  }
  bind::server::file { 'jcbdns.com':
    source => 'puppet:///modules/bind/jcbdns.com',
  }
  bind::server::file { 'jcbconsulting.biz':
    source => 'puppet:///modules/bind/jcbconsulting.biz',
  }
  bind::server::file { 'tga.es':
    source => 'puppet:///modules/bind/tga.es',
  }
  bind::server::file { 'maricel.es':
    source => 'puppet:///modules/bind/maricel.es',
  }
  bind::server::file { '188.31.176.in-addr.arpa':
    source => 'puppet:///modules/bind/188.31.176.in-addr.arpa',
  }

  class { 'apache':  
    servername        => 'vps.jcbconsulting.biz',
    serveradmin       => 'xavi.carrillo@gmail.com',
    log_level         => 'warn',
    keepalive         => 'On',
    keepalive_timeout => '15',
    server_signature  => 'Off',
    server_tokens     => 'None',
  }
  include apache::mod::php
  include apache::mod::ssl
  include mysql::bindings::php
  file { '/var/www/vhosts':
    ensure  => directory,
    owner   => 'apache',
    group   => 'apache',
    recurse => true,
  }
  # Logs in /var/log/httpd/
  apache::vhost { 'mundodisea.com':
    ip            => "$::ipaddress",
    serveraliases => 'www.mundodisea.com',
    docroot       => '/var/www/vhosts/mundodisea.com',
  } 
  apache::vhost { 'tga.es':
    ip            => "$::ipaddress",
    serveraliases => 'www.tga.es',
    docroot       => '/var/www/vhosts/tga.es',
  } 
  apache::vhost { 'maricel.es':
    ip            => "$::ipaddress",
    serveraliases => 'www.maricel.es',
    docroot       => '/var/www/vhosts/maricel.es',
  } 
  apache::vhost { 'jcbconsulting.biz':
    ip            => "$::ipaddress",
    serveraliases => 'www.jcbconsulting.biz',
    docroot       => '/var/www/vhosts/jcbconsulting.biz',
  } 
  apache::vhost { 'webmail.jcbconsulting.biz':
    ip            => "$::ipaddress",
    docroot       => '/var/www/vhosts/webmail.jcbconsulting.biz',
  } 
 
  file {'/var/www/vhosts/tga.es/.htaccess':
    ensure  => present,
    content => 'AddDefaultCharset ISO-8859-1',
    owner   => 'root',
    group   => 'apache',
    mode    => '0644',
  }


  class { '::mysql::server':
    override_options => { 
      # my.cnf sections
      'mysqld' => {
        'max_connections'    => '100',
        'thread_cache_size'  => '11',
        'thread_concurrency' => '2',
        'query_cache_size'   => '4M',
        'symbolic-links'     => '0',
      }
    },
    databases => {
      'tgaes' => {
         ensure  => 'present',
         charset => 'utf8',
      },
      'mailserver' => {
         ensure  => 'present',
         charset => 'utf8',
      },
    },
    users => {
      'tgaes@localhost' => {
        ensure                   => present,
        max_connections_per_hour => '30',
        max_queries_per_hour     => '100',
        max_updates_per_hour     => '100',
        max_user_connections     => '10',
        password_hash            => '*A1FAB1A533264DE4F3D6B969ECB6FC3DA70034D7',
      },
      'mailuser@localhost' => {
        ensure                   => present,
        password_hash            => '*A1FAB1A533264DE4F3D6B969ECB6FC3DA70034D7',
      },
 
    },
    # Buggy provider: https://github.com/puppetlabs/puppetlabs-mysql/pull/391
    #grants => {
    # 'tgaes@localhost/tgaes.*' => {
    #     ensure     => present,
    #     options    => ['GRANT'],
    #     privileges => ['SELECT', 'INSERT', 'UPDATE', 'DELETE'],
    #     table      => 'tgaes.*',
    #     user       => 'tgaes@localhost',
    #   },
    # },
    #grants => {
    # 'mailuser@localhost/mailserver.*' => {
    #     ensure     => present,
    #     options    => ['GRANT'],
    #     privileges => ['SELECT', 'INSERT', 'UPDATE', 'DELETE'],
    #     table      => 'mailserver.*',
    #     user       => 'mailuser@localhost',
    #   },
    # },
  }


  #### NO FER SERVIR LA CLASSE BACKUP, ET CANVIA EL PASS DE ROOT ###

  # Scan for viruses
#  clamav::scan { "${name}":
#    directory => '/var/www/vhosts',
#  }

  group { 'vmail':
    ensure => present,
  } ->
  user { 'vmail':
    gid        => 'vmail',
    home       => '/var/mail',
    managehome => true,
  }
  class { 'dovecot':
    plugins                    => [ 'mysql' ],
    protocols                  => 'imap pop3',
    verbose_proctitle          => 'yes',
    auth_include               => 'sql',
    disable_plaintext_auth     => 'yes',
    mail_location              => 'maildir:/var/mail/vhosts/%d/%n',
    #mail_location              => 'maildir:~/Maildir',
    auth_listener_userdb_mode  => '0660',
    auth_listener_userdb_group => 'vmail',
    auth_listener_postfix      => true,
    auth_mechanisms            => 'plain login',
    ssl                        => false,
    postmaster_address         => 'postmaster@jcbconsulting.biz',
    hostname                   => 'jcbconsulting.biz',
    lda_mail_plugins           => '$mail_plugins',
    auth_sql_userdb_static     => 'uid=vmail gid=vmail home=/var/mail/vhosts/%d/%n',
    log_timestamp              => '%Y-%m-%d %H:%M:%S ',
  }
	
  dovecot::file { 'dovecot-sql.conf.ext':
    source => 'puppet:///modules/mail/dovecot-sql.conf.ext',
    owner  => 'vmail',
    group  => 'dovecot',
    mode   => '0640',
  }

  class { 'postfix::server':
    myhostname              => 'jcbconsulting.biz',
    mydomain                => 'jcbconsulting.biz',
    mydestination           => "${myhostname}, localhost, $::fqdn",
    inet_interfaces         => 'all',
    message_size_limit      => '15360000', # 15MB
    mail_name               => 'JCB mail daemon',
    virtual_mailbox_domains => [
      'mysql:/etc/postfix/mysql-virtual-mailbox-domains.cf',
    ],
    virtual_mailbox_maps    => [
      'mysql:/etc/postfix/mysql-virtual-mailbox-maps.cf',
    ],
    virtual_alias_maps      => [
      'mysql:/etc/postfix/mysql-virtual-alias-maps.cf',
    ],
    virtual_transport         => 'dovecot',
    smtpd_sender_restrictions => [
      'permit_mynetworks',
      'reject_unknown_sender_domain',
    ],
    smtpd_recipient_restrictions => [
      'permit_sasl_authenticated',
      'permit_mynetworks',
      'reject_unauth_destination',
    ],
    smtpd_sasl_auth       => true,
    #sender_canonical_maps => 'regexp:/etc/postfix/sender_canonical',
    sender_canonical_maps => 'hash:/etc/postfix/sender_canonical',
    #ssl                   => 'jcbconsulting.biz',
    submission            => true,
    postgrey              => true,
    clamav                => true, # depends on https://github.com/thias/puppet-modules/tree/master/modules-wip/clamav
    spamassassin          => true, # depends on http://dl.fedoraproject.org/pub/fedora/linux/releases/20/Everything/i386/os/Packages/s/spampd-2.30-15.noarch.rpm
    sa_skip_rbl_checks    => '0',
    spampd_children       => '4',
    # Send all emails to ClamSMTP, which sends to spampd on 10026
    smtp_content_filter   => 'smtp:127.0.0.1:10025',
    # This is where we get emails back from spampd
    master_services       => [ '127.0.0.1:10027 inet n  -       n       -      20       smtpd'],
  }

  postfix::file { 'mysql-virtual-mailbox-domains.cf':
    source => 'puppet:///modules/mail/mysql-virtual-mailbox-domains.cf',
  }
  postfix::file { 'mysql-virtual-mailbox-maps.cf':
    source => 'puppet:///modules/mail/mysql-virtual-mailbox-maps.cf',
  }
  postfix::file { 'mysql-virtual-alias-maps.cf':
    source => 'puppet:///modules/mail/mysql-virtual-alias-maps.cf',
  }
  postfix::file { 'sender_canonical':
    source => 'puppet:///modules/mail/sender_canonical',
  }


  # Mails on /var/vmail/vhosts/domain/user/
  #file { '/var/mail/vhosts':
  #  ensure  => directory,
  #  recurse => true,
  #  owner   => 'vmail',
  #  group   => 'vmail',
  #}
  file { '/etc/dovecot':
    ensure  => directory,
    recurse => true,
    owner   => 'vmail',
    group   => 'dovecot',
  }

  file { '/etc/logrotate.d/named':
    ensure  => file,
    owner   => 'root',
    group   => 'named',
    mode    => '0644',
    content => file('/etc/puppet/files/etc/logrotate.d/named'),
  }

  #Roundcubemail webmail
  package { 'php-xml':
    ensure => installed,
  }

  cron {
    # Si algun domini caduca en 30 dies o menys, ens avisa. Ojo, els .es no els mira
    'whois':
      ensure      => present,
      environment => 'MAILTO=/dev/null',
      command     => '/opt/scripts/whois.sh',
      user        => root,
      hour        => 3,
      minute      => 10;

    # cada dia fem un backup de la bbdd 
    #"backup sql":
    #  ensure      => present,
    #  command     => "/opt/scripts/backup_sql.sh",
    #  user        => root,
    #  hour        => 2,
    #  minute      => 20;

    # esborrem els backups mes antics de 2 setmanes
    #"esborra-rdiff":
    #  ensure  => present,
    #  command => "rdiff-backup --force --remove-older-than 2W /var/backup/rdiff/remot/ks391417.kimsufi.com/",
    #  user    => root,
    #  hour    => 5,
    #  minute  => 20;

    # Backup servidor namesti
    #"rdiff-backup namesti":
    # ensure  => present,
    #  command => "rdiff-backup --print-statistics --exclude=/lost+found --exclude=/var/log --exclude=/proc --exclude=/sys --exclude=/usr/lib  --exclude=/usr/lib64 --exclude=/var/backup/rdiff  --exclude=/var/named/run-root/proc  --exclude-special-files --force ks391417.kimsufi.com::/  /var/backup/rdiff/remot/ks391417.kimsufi.com",
    #  user    => root,
    #  hour    => 5,
    #  minute  => 30;
  }

  file {'/home/xcarrillo/.gitconfig':
    ensure  => present,
    content => "[user] \n  name = Xavi Carrillo\n  email = xavi.carrillo@gmail.com\n",
    owner   => 'xcarrillo',
    group   => 'xcarrillo',
    mode    => '0664',
  }

}
