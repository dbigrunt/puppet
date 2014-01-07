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
  include dns
  include web
  include db
  include mail

  cron {
    # Si algun domini caduca en 30 dies o menys, ens avisa. Ojo, els .es no els mira
    'whois':
      ensure      => present,
      environment => 'MAILTO=xavi.carrillo@gmail.com',
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
