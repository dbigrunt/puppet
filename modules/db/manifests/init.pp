class db {
  #### NO FER SERVIR LA CLASSE BACKUP, ET CANVIA EL PASS DE ROOT ###
  class { '::mysql::server':
    override_options => {
      # my.cnf sections
      'mysqld' => {
        'max_connections'    => '100',
        'thread_cache_size'  => '11',
        'thread_concurrency' => '2',
        'query_cache_size'   => '4M',
        'symbolic-links'     => '0',
      }
    },
    # Commented out in order to increase the catalog compilation's time
    #databases => {
    #  'tgaes' => {
    #     ensure  => 'present',
    #     charset => 'utf8',
    #  },
    #  'mailserver' => {
    #     ensure  => 'present',
    #     charset => 'utf8',
    #  },
    #},
    #users => {
    #  'tgaes@localhost' => {
    #    ensure                   => present,
    #    max_connections_per_hour => '30',
    #    max_queries_per_hour     => '100',
    #    max_updates_per_hour     => '100',
    #    max_user_connections     => '10',
    #    password_hash            => '*A1FAB1A533264DE4F3D6B969ECB6FC3DA70034D7',
    #  },
    #  'mailuser@localhost' => {
    #    ensure                   => present,
    #    password_hash            => '*A1FAB1A533264DE4F3D6B969ECB6FC3DA70034D7',
    #  },
    #},
    # Buggy provider: https://github.com/puppetlabs/puppetlabs-mysql/pull/391
    #grants => {
    # 'tgaes@localhost/tgaes.*' => {
    #     ensure     => present,
    #     options    => ['GRANT'],
    #     privileges => ['SELECT', 'INSERT', 'UPDATE', 'DELETE'],
    #     table      => 'tgaes.*',
    #     user       => 'tgaes@localhost',
    #   },
    # },
    #grants => {
    # 'mailuser@localhost/mailserver.*' => {
    #     ensure     => present,
    #     options    => ['GRANT'],
    #     privileges => ['SELECT', 'INSERT', 'UPDATE', 'DELETE'],
    #     table      => 'mailserver.*',
    #     user       => 'mailuser@localhost',
    #   },
    # },
  }
}
