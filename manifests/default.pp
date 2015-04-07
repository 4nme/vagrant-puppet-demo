class { "apache":
	mpm_module => 'prefork',
}

class { "::apache::mod::php":	
}

apache::mod { 'rewrite': }

Exec {
	path => ["/usr/bin", "/usr/local/bin"],
}

package{'sendmail':
	ensure => 'present',
}

exec{ "update":
	command => "apt-get update",	
}

Exec["update"] -> Package <| |>

apache::vhost{"local.example.com":	
	port 	=> '80',
	docroot => '/var/vagrant_hosts/vgdemo',
	directories => [{
					path => '/var/vagrant_hosts/vgdemo',
					options => 'All',										
					allow_override => ['All'],
					custom_fragment => 'Order allow,deny
					Allow from all',
					},],	
}

class { '::mysql::server':
  root_password		=> 'root',
  restart			=> true,  
}

class {'mysql::bindings' :
    php_enable 			=> true,    
    require 			=> Class['::mysql::server'],
}

include mysql::bindings::php

package { 'php5-curl': 
	ensure => 'present',
	require => Class['mysql::bindings'],
}