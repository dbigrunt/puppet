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
  include clamav


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

  file { '/var/www/vhosts':
    ensure => directory,
    owner  => 'apache',
    group  => 'apache',
  }

  apache::vhost { 'mundodisea.com':
    serveraliases   => 'www.mundodisea.com',
    docroot         => '/var/www/vhosts/mundodisea.com',
    docroot_owner   => 'apache',
    docroot_group   => 'apache',
    redirect_source => ['/dokuwiki'],
    redirect_dest   => ['https://mundodisea.com/dokuwiki',],

    #directories => [
    #  { path => '/path/to/directory', ssl_options => '+ExportCertData' }
    #  { path => '/path/to/different/dir', ssl_options => [ '-StdEnvVars', '+ExportCertData'] },
    #],
	  #error_documents => [
    #  { 'error_code' => '503', 'document' => '/service-unavail' },
    #  { 'error_code' => '407', 'document' => 'https://example.com/proxy/login' },
    #],
  } 

  clamav::scan { "${name}":
    directory => '/var/www/vhosts',
  }

  #file { '/var/www/tga.es/httpdocs/.htaccess':
    #ensure  => present,
    #owner   => 'root',
    #group   => 'root',
    #mode    => '0644',
    #content => file('/etc/puppet/files/var/www/vhosts/tga.es/httpdocs/.htaccess'),
  #}

  file { '/etc/logrotate.d/named':
    ensure  => file,
    owner   => 'root',
    group   => 'named',
    mode    => '0644',
    content => file('/etc/puppet/files/etc/logrotate.d/named'),
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
}
