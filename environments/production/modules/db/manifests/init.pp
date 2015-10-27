class db {
#  class { 'mysql':
#    client_package_name => 'mariadb',
#    server_package_name => 'mariadb-server',
#  }
  include mysql::client
  #### NO FER SERVIR LA CLASSE BACKUP, ET CANVIA EL PASS DE ROOT ###
  class { 'mysql::server':
    # my.cnf sections
    override_options     => {
      'mysqld' => {
        'max_connections'    => '100',
        'thread_cache_size'  => '11',
        'thread_concurrency' => '2',
        'query_cache_size'   => '4M',
        'symbolic-links'     => '0',
      }
    },
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
