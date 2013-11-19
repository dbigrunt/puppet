# Class: yum::centos::base
#
# Description:
# This class finds the operating release and calls the yumrepo class
# to create the repo.
#

class yum::centos::base ($repo_server = 'mirror.centos.org') {

  yumrepo { 'Centos-Base':
    descr    => "Centos Base ${::operatingsystemrelease}",
    enabled  => '1',
    gpgcheck => '0',
    baseurl  => "http://${repo_server}/centos/\$releasever/os/\$basearch/",
    notify   => Exec['yum_clean_all'],
  }

}

