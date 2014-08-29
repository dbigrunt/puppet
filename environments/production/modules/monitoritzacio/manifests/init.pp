class monitoritzacio {

  package { [ 'nagios-common',
              'nagios-plugins',
              'nagios-plugins-perl',
              'perl-Sys-Statistics-Linux' ]:
                ensure => installed,
          }
  ->
  file { '/usr/lib64/nagios/plugins/check_linux_stats.pl':
    mode   => '0750',
    source => 'puppet:///modules/monitoritzacio/check_linux_stats.pl',
  }

}

#include monitoritzacio
