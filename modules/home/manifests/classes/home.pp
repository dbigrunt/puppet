class home::vimrc {
    user { ... }
    file { "/home/${user}/.vimrc":
    ensure => present,
    owner  => ${user}
    group  => ${user}
    source => "puppet:///modules/home/vimrc",
  }
}
