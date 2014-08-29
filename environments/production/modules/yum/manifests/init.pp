# Class: yum
#
# Description:
# This class finds the operating and calls the specific subclass's
# to create the repo.
#
# Repos available but not installed:
# yum::rhel::optional
# yum::thirdparty::epel

class yum {


  case $::operatingsystem {
    'RedHat': {
      include yum::rhel::base
    }
    'CentOS': {
      include yum::centos::base
      include yum::centos::updates
    }
  }

  #include yum::thirdparty::puppetlabs
  package { 'puppetlabs-release' :
    ensure => latest,
  }

  exec { 'yum_clean_all':
    command     => '/usr/bin/yum clean all',
    refreshonly => true,
  }

}
