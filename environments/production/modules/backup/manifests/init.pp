class backup {
  # First install the binaries: http://www.dropboxwiki.com/tips-and-tricks/install-dropbox-centos-gui-required
  class { 'dropbox':
    users => 'root',
  }
  package { 'rdiff-backup':
    ensure => latest,
  }
  file { ['/root/Dropbox',
          '/root/Dropbox/backups',
          '/root/Dropbox/backups/sql',
          '/root/Dropbox/backups/rdiff' ]:
    ensure => directory,
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
       ensure     => present,
       command    => '/usr/local/bin/backup',
       user       => root,
       hour       => 4,
       minute     => 20;
  }
}
