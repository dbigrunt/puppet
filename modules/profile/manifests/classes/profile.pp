class profile::history {
        $profile_history_default="standard"

        if ( ! $profile_history ) {
                $profile_history = $profile_history_default
        }


        file {"/etc/profile.d/history.sh":
                ensure => present,
		owner => 'root',
		group => 'root',
                source => "puppet:///modules/profile/history/history_$profile_history.sh",
        }
}

define profile::dfile {
	file{"/etc/profile.d/$name.sh":
		ensure => present,
		owner => 'root',
		group => 'root',
		source => "puppet:///modules/profile/profile.d/$name.sh",
	}

}
	
