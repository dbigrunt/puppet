node 'vps38933.ovh.net' inherits default {

  include puppet::master
  include cosmetic
  include cosmetic::vim
  include dns
  include web
  include db
  include mail
  include collectd
  class { 'yum-cron':
    mailto => 'xavi.carrillo@gmail.com',
  }
  class { 'rkhunter':
    ensure                 => absent,
    cronjob                => absent,
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
  file { '/etc/sudoers.d/xcarrillo':
    content => 'xcarrillo  ALL=(ALL) NOPASSWD:/usr/bin/yum update',
    mode    => '0440',
  }
  service { 'rsyslog':
    ensure => 'running',
    enable => true,
  }
  cron {
    "backup sql":
      ensure      => present,
      environment => 'MAILTO=xavi.carrillo@gmail.com',
      command     => '/opt/scripts/backups/backup_sql.sh /root/Dropbox/backups/vps38933/sql/',
      user        => root,
      hour        => 2,
      minute      => 20;
    'rdiff-backup':
       ensure  => present,
       command => '/usr/local/bin/backup',
       user    => root,
       hour    => 4,
       minute  => 20;
  }
  file { '/root/.gitconfig':
    ensure  => present,
    content => "[user] \n  name = Xavi Carrillo\n  email = xavi.carrillo@gmail.com\n",
  }
}
