# http://forums.sentora.org/showthread.php?tid=1132
class mail {
  package { [ 'clamav', 'clamav-update', 'clamav-server', 'spamassassin', 'amavisd-new' ]:
    ensure => installed,
  }
  group { 'vmail':
    ensure => present,
  } ->
  user { 'vmail':
    gid        => 'vmail',
    home       => '/var/mail',
    managehome => true,
  }
  file { '/etc/freshclam.conf':
    ensure => file,
    source => 'puppet:///modules/mail/etc/freshclam.conf',
  }
  file { '/etc/sysconfig/freshclam':
    ensure => file,
    source => 'puppet:///modules/mail/etc/sysconfig/freshclam',
  }
  file { '/etc/amavisd/amavisd.conf':
    ensure => file,
    source => 'puppet:///modules/mail/etc/amavisd/amavisd.conf',
  }
   
  class { 'dovecot':
    plugins                    => [ 'mysql' ],
    protocols                  => 'imap pop3',
    verbose_proctitle          => 'yes',
    auth_include               => [ 'sql' ],
    disable_plaintext_auth     => 'no',
    mail_location              => 'maildir:/var/mail/vhosts/%d/%n',
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
    clamav                => false,
    spamassassin          => false, # depends on http://dl.fedoraproject.org/pub/fedora/linux/releases/20/Everything/i386/os/Packages/s/spampd-2.30-15.noarch.rpm
    sa_skip_rbl_checks    => '0',
    spampd_children       => '4',
    # Send all emails to ClamSMTP, which sends to spampd on 10026
    #smtp_content_filter   => [ 'smtp:127.0.0.1:10025' ],
    # This is where we get emails back from spampd
    #master_services       => [ '127.0.0.1:10027 inet n  -       n       -      20       smtpd'],
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
  } ->
  exec { 'create_sender_canonical.db':
    command => '/usr/sbin/postmap hash:/etc/postfix/sender_canonical',
    creates => '/etc/postfix/sender_canonical.db',
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
  #Roundcubemail webmail
  package { 'php-xml':
    ensure => installed,
  }

  cron {
    'Update ClamAV and SpamAssassin':
      ensure  => present,
      command => '/bin/freshclam ; /bin/sa-update -D',
      user    => root,
      hour    => '3',
      minute  => '30',
  }
}
