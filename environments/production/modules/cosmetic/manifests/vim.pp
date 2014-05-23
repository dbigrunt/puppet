class cosmetic::vim ($colorscheme = 'koehler') {

  package { [
    'vim-minimal',
    'vim-enhanced',
    'vim-common',] :
      ensure => latest,
  }

  file {'/etc/vimrc':
    content => template('cosmetic/vimrc.erb'),
  }

}

