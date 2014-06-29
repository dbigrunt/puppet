class web {
  class { 'apache':
    servername        => 'vps.jcbconsulting.biz',
    serveradmin       => 'xavi.carrillo@gmail.com',
    log_level         => 'warn',
    keepalive         => 'On',
    keepalive_timeout => '15',
    server_signature  => 'Off',
    server_tokens     => 'None',
  }
  augeas { "php.ini":
    notify  => Service[httpd],
    require => Package[php],
    context => "/files/etc/php.ini/PHP",
    changes => [
      "set engine On",
      "set file_uploads On",
      "set post_max_size 10M",
      "set upload_max_filesize 10M",
      "set register_globals Off",
      "set safe_mode Off",
      "set max_execution_time 30",
      "set max_input_time 60",
      "set mysql.allow_persistent On",
      "set mysql.connect_timeout 60",
      "set date.timezone Europe/Madrid",
      "set memory_limit 128M",
    ];
  }
  file { '/var/www/vhosts':
    ensure  => directory,
    owner   => 'apache',
    group   => 'apache',
    recurse => true,
  }
  # Logs in /var/log/httpd/
  apache::vhost { 'mundodisea.com':
    ip            => "$::ipaddress",
    serveraliases => 'www.mundodisea.com',
    docroot       => '/var/www/vhosts/mundodisea.com',
    aliases => [
      { alias     => '/webmail', path => '/var/www/html/webmail' },
    ],
  }
  apache::vhost { 'maricel.es':
    ip            => "$::ipaddress",
    serveraliases => 'www.maricel.es',
    docroot       => '/var/www/vhosts/maricel.es',
    aliases => [
      { alias     => '/webmail', path => '/var/www/html/webmail' },
    ],
  }
  apache::vhost { 'jcbconsulting.biz':
    ip            => "$::ipaddress",
    serveraliases => 'www.jcbconsulting.biz',
    docroot       => '/var/www/vhosts/jcbconsulting.biz',
  }
  apache::vhost { 'webmail.jcbconsulting.biz':
    ip            => "$::ipaddress",
    docroot       => '/var/www/vhosts/webmail.jcbconsulting.biz',
  }
  include apache::mod::ssl
  include apache::mod::php
  class { 'mysql::bindings':
    php_enable => true,
  }
  include mysql::bindings::php
}
