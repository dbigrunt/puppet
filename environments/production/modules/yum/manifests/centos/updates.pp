# Class: yum::centos:updates
#
# Description:
# This class finds the operating release and calls the yumrepo class
# to create the repo.
#

class yum::centos::updates ($repo_server = 'mirror.centos.org') inherits yum::params {

  yumrepo { 'Centos-Updates':
    descr    => 'Centos Updates',
    enabled  => '1',
    gpgcheck => '0',
    baseurl  => "http://${repo_server}/centos/\$releasever/updates/\$basearch/",
    notify   => Exec['yum_clean_all'],
  }

}

