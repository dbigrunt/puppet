node 'vps38933.ovh.net' inherits default {

  include puppet::master
  include cosmetic
  include cosmetic::vim
  include dns
  include web
  include db
  include mail
  class { 'yum-cron':
    mailto => 'xavi.carrillo@gmail.com',
  }
  class { 'rkhunter':
    administrator_email    => 'xavi.carrillo@gmail.com',
    allow_ssh_root_user    => 'no',
    allowdevfiles          => [ '/dev/md/autorebuild.pid','/dev/kmsg', ],
    rkhunter_disable_tests => [ 'suspscan hidden_procs deleted_files packet_cap_apps apps os_specific' ],
      # os_specific: related to kernel modules, which we don't use
  }
  class { 'dropbox':
    users => 'root',
  }

  package { 'rdiff-backup':
    ensure => latest,
  }

  file { '/root/Dropbox/backups/vps38933/sql':
    ensure => directory,
  }

  file { '/root/Dropbox/backups/vps38933/rdiff':
    ensure => directory,
  }

  cron {
    # cada dia fem un backup de la bbdd 
    "backup sql":
      ensure      => present,
      environment => 'MAILTO=xavi.carrillo@gmail.com',
      command     => '/opt/scripts/backups/backup_sql.sh /root/Dropbox/backups/vps38933/sql/',
      user        => root,
      hour        => 2,
      minute      => 20;
    # esborrem els backups mes antics de 2 setmanes
    'rdiff-backup: clean /etc':
       ensure  => present,
       command => 'rdiff-backup --force --remove-older-than 1W /root/Dropbox/backups/vps38933/rdiff/etc',
       user    => root,
       hour    => 5,
       minute  => 20;
    'rdiff-backup: clean mail':
       ensure  => present,
       command => 'rdiff-backup --force --remove-older-than 1W /root/Dropbox/backups/vps38933/rdiff/mail',
       user    => root,
       hour    => 5,
       minute  => 20;
     'rdiff-backup: clean www':
       ensure  => present,
       command => 'rdiff-backup --force --remove-older-than 1W /root/Dropbox/backups/vps38933/rdiff/www',
       user    => root,
       hour    => 5,
       minute  => 20;
    # Backup /etc into Dropbox
    'rdiff-backup /etc':
      ensure  => present,
      command => 'rdiff-backup --print-statistics --force /etc /root/Dropbox/backups/vps38933/rdiff/etc',
      user    => 'root',
      hour    => 4,
      minute  => 10;
    # Backup /var/www into Dropbox
    'rdiff-backup /var/www':
      ensure  => present,
      command => 'rdiff-backup --print-statistics --force /var/www /root/Dropbox/backups/vps38933/rdiff/www',
      user    => 'root',
      hour    => 4,
      minute  => 30;
     # Backup /var/mail/vhosts into Dropbox
    'rdiff-backup /var/mail/vhosts':
      ensure  => present,
      command => 'rdiff-backup --print-statistics --force /var/mail/vhosts /root/Dropbox/backups/vps38933/rdiff/mail',
      user    => 'root',
      hour    => 4,
      minute  => 50;
  }

  file { '/root/.gitconfig':
    ensure  => present,
    content => "[user] \n  name = Xavi Carrillo\n  email = xavi.carrillo@gmail.com\n",
  }

}
