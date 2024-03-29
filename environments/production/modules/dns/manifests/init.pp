class dns {
  include bind
  bind::server::conf { '/etc/named.conf':
    recursion         => 'no',
    listen_on_addr    => [ 'any' ],
    listen_on_v6_addr => [ 'any' ],
    forwarders        => [ '8.8.8.8', '8.8.4.4' ],
    allow_query       => [ 'any' ],
    zones             => {
      'mundodisea.com' => [
        'type master',
        'file "mundodisea.com"',
      ],
      'jcbdns.com' => [
        'type master',
        'file "jcbdns.com"',
      ],
      'jcbconsulting.biz' => [
        'type master',
        'file "jcbconsulting.biz"',
      ],
      'hastaelfindelmundo.net' => [
        'type master',
        'file "hastaelfindelmundo.net"',
      ],
      '5.222.92.in-addr.arpa' => [
        'type master',
        'file "PTR"',
      ],
    },
  }
  bind::server::file { 'mundodisea.com':
    source => 'puppet:///modules/dns/mundodisea.com',
  }
  bind::server::file { 'jcbdns.com':
    source => 'puppet:///modules/dns/jcbdns.com',
  }
  bind::server::file { 'jcbconsulting.biz':
    source => 'puppet:///modules/dns/jcbconsulting.biz',
  }
  bind::server::file { 'hastaelfindelmundo.net':
    source => 'puppet:///modules/dns/hastaelfindelmundo.net',
  }
  bind::server::file { 'PTR':
    source => 'puppet:///modules/dns/PTR',
  }
  file { '/etc/logrotate.d/named':
    ensure  => file,
    owner   => 'root',
    group   => 'named',
    mode    => '0644',
    source  => 'puppet:///modules/dns/logrotate-named',
  }
  file { '/etc/sysconfig/named':
    ensure  => file,
    source  => 'puppet:///modules/dns/sysconfig',
  }

}
