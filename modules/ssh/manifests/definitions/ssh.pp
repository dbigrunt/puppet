class ssh {

	package {["openssh","openssh-server","openssh-clients"]:
		ensure => installed,
		before => Service["sshd"],
		provider => "yum"
	}

	service {"sshd":
		ensure => running,
        hasstatus => true,
	}

        exec { "mkdir -p /etc/ssh/keys":
		creates => "/etc/ssh/keys"
	}

}

class ssh::conf {

	$ssh_default="custom"
	$rootloginperm_default="yes"

    if ( ! $sshconf ) {
        $sshconf = $ssh_default
    }

    if ( ! $rootloginperm ) {
        $rootloginperm = $rootloginperm_default
    }

    file { "/etc/ssh/sshd_config":
        content => template("ssh/sshd_$sshconf.erb"),
        owner => 'root',
        group => 'root',
        mode => 640,
        notify => Service["sshd"],
    }

}

define ssh::authkey ($conf=prod) {

    file {	"/etc/ssh/keys/$name":
        source => "puppet:///modules/ssh/authkeys/$name-$conf",
        ensure => present,
        notify => Service["sshd"],
        owner => 'root',
        group => 'root',
        mode => 640,
        require => Exec["mkdir -p /etc/ssh/keys"]
    }
}


