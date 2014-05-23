class yum::thirdparty::epel($repo_server = 'dl.fedoraproject.org') inherits yum::params {

  yumrepo { 'epel':
    descr    => "Extra Packages for Enterprise Linux $majdistrelease",
    enabled  => '1',
    gpgcheck => '0',
    baseurl  => "http://${repo_server}/pub/epel/${::operatingsystemmajrelease}/\$basearch",
    notify   => Exec['yum_clean_all'],
  }

}

