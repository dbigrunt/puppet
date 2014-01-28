class dns {
  include bind
  bind::server::conf { '/etc/named.conf':
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
      'tga.es' => [
        'type master',
        'file "tga.es"',
      ],
      'maricel.es' => [
        'type master',
        'file "maricel.es"',
      ],
      '188.31.176.in-addr.arpa' => [
        'type master',
        'file "188.31.176.in-addr.arpa"',
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
  bind::server::file { 'tga.es':
    source => 'puppet:///modules/dns/tga.es',
  }
  bind::server::file { 'maricel.es':
    source => 'puppet:///modules/dns/maricel.es',
  }
  bind::server::file { '188.31.176.in-addr.arpa':
    source => 'puppet:///modules/dns/188.31.176.in-addr.arpa',
  }
  file { '/etc/logrotate.d/named':
    ensure  => file,
    owner   => 'root',
    group   => 'named',
    mode    => '0644',
    source => 'puppet:///modules/dns/logrotate-named',
  }
}
