# Phpmemcachedadmin extension for Chassis
class phpmemcachedadmin (
	$config,
	$path = '/vagrant/extensions/phpmemcachedadmin',
) {

	if ( !empty($config[disabled_extensions]) and 'chassis/phpmemcachedadmin' in $config[disabled_extensions] ) {
		$ensure = absent
	} else {
		$ensure = present
	}

	exec { 'download phpmemcachedadmin':
		command => "git clone -b 1.3.0 https://github.com/elijaa/phpmemcachedadmin.git ${path}/phpmemcachedadmin",
		require => Package['git-core'],
		path    => '/usr/bin',
		creates => "${path}/phpmemcachedadmin"
	}

	file { "${path}/phpmemcachedadmin/Config/Memcache.php":
		ensure  => $file,
		content => template('phpmemcachedadmin/Memcache.php'),
		require => Exec['download phpmemcachedadmin']
	}

	file { '/vagrant/phpmemcachedadmin':
		ensure  => $link,
		target  => '/vagrant/extensions/phpmemcachedadmin/phpmemcachedadmin',
		notify  => Service['nginx'],
		require => Exec['download phpmemcachedadmin']
	}
}
