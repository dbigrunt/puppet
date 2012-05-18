class profile {

	file {"/etc/profile.d/$name.sh":
		ensure => present,
		owner => 'root',
		group => 'root',
		source => "puppet:///modules/profile/profile.d/$name.sh",
	}

}
