class cosmetic {
  File {
    owner => 'root',
    group => 'root',
  }
  file { '/etc/profile.d/bash_profile.sh':
    source => 'puppet:///modules/cosmetic/bash_profile.sh',
  }
  file { '/etc/profile.d/git-prompt.sh':
    source => 'puppet:///modules/cosmetic/git-prompt.sh',
  }
  file { '/etc/profile.d/history.sh':
    source => 'puppet:///modules/cosmetic/history.sh',
  }
}
 
