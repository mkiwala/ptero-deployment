class {'apt': }
class {'ptero': }


# --- External Services ---
class {'postgresql::server': }
package {'python-psycopg2':
  ensure => present,
}

class {'nginx': }

class {'redis':
  redis_bind_address => '127.0.0.1',
  redis_password     => 'never-enter',
  redis_max_memory   => '0mb',
  version            => '2.8.15',
}

class {'rabbitmq':
  delete_guest_user => true,
  service_manage    => false,
}
package {'python-librabbitmq':
  ensure => present,
}


# --- Auth ---
postgresql::server::db {$ptero::params::auth::database_name :
  user     => $ptero::params::auth::database_username,
  password => $ptero::params::auth::database_password,
}
class {'ptero::auth::web':
  require => Postgresql::Server::Db[$ptero::params::auth::database_name],
}


# --- Shell command ---
class {'ptero::shell_command::rabbitmq': }
class {'ptero::shell_command::redis': }
class {'ptero::shell_command::web':
  require => [
    Class['ptero::shell_command::rabbitmq'],
    Class['ptero::shell_command::redis'],
  ],
}
class {'ptero::shell_command::celery':
  require => [
    Class['ptero::shell_command::rabbitmq'],
    Class['ptero::shell_command::redis'],
  ],
}
