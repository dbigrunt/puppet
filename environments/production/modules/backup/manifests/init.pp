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
  file { '/usr/local/bin/backup_sql.sh':
    mode   => '0750',
    source => 'puppet:///modules/backup/backup_sql.sh',
  }
  file { '/usr/local/bin/backup':
    mode   => '0750',
    source => 'puppet:///modules/backup/backup',
  }
  cron {
    "backup sql":
       ensure      => present,
       environment => 'MAILTO=xavi.carrillo@gmail.com',
       command     => '/usr/local/bin/backup_sql.sh /root/Dropbox/backups/sql',
       user        => root,
       hour        => 2,
       minute      => 20;
    'rdiff-backup':
       ensure      => present,
       command     => '/usr/local/bin/backup',
       user        => root,
       hour        => 4,
       minute      => 20;
  }
}
