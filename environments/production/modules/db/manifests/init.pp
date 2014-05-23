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
