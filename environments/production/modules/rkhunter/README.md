example of how to call this module on a node:
```
  class { 'rkhunter':
    administrator_email    => 'xavi.carrillo@gmail.com',
    allow_ssh_root_user    => 'no',
    allowdevfiles          => [ '/dev/md/autorebuild.pid','/dev/kmsg', ],
    rkhunter_xinetd_allowed   = [ 'echo','ftp_psa','poppassd_psa','smtp_psa','smtps_psa', 'submission_psa' ]
    rkhunter_disable_tests => [ 'suspscan hidden_procs deleted_files packet_cap_apps apps os_specific' ],
      # os_specific: related to kernel modules, which we don't use
  }
```

