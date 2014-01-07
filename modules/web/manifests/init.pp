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
  }
  apache::vhost { 'tga.es':
    ip            => "$::ipaddress",
    serveraliases => 'www.tga.es',
    docroot       => '/var/www/vhosts/tga.es',
  }
  apache::vhost { 'maricel.es':
    ip            => "$::ipaddress",
    serveraliases => 'www.maricel.es',
    docroot       => '/var/www/vhosts/maricel.es',
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
  file {'/var/www/vhosts/tga.es/.htaccess':
    ensure  => present,
    content => 'AddDefaultCharset ISO-8859-1',
    owner   => 'root',
    group   => 'apache',
    mode    => '0644',
  }
  include apache::mod::ssl
  include apache::mod::php
  include mysql::bindings::php
}
