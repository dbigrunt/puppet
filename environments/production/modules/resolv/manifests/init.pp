class resolv(
  $domainname = "$domain",
  $searchpath,
  $nameservers,
  $options,
) {
  file { '/etc/resolv.conf':
    content => template('resolv/resolv.erb'),
  }
}
