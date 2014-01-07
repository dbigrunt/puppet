class mail {
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
    disable_plaintext_auth     => 'no',
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
}
