class {'apt': }

class {'ptero': }

# --- Setup database ---
package {'python-psycopg2':
  ensure => present,
}

class {'postgresql::server': }

postgresql::server::db {'ptero_auth':
  user     => 'ptero_auth',
  password => hiera('auth-postgres-password'),
}


# --- Setup Nginx ---
class {'nginx': }


# --- Setup Redis ---
class {'redis':
  redis_bind_address => '127.0.0.1',
  redis_password     => 'never-enter',
  redis_max_memory   => '0mb',
  version            => '2.8.15',
}


# --- Setup RabbitMQ ---
class {'rabbitmq':
  delete_guest_user => true,
  service_manage    => false,
}


class {'ptero::auth::web': }


# -- Shell command ---
class {'ptero::shell_command::rabbitmq': }

$sc_redis_port = hiera('sc-redis-port')
$sc_redis_password = hiera('sc-redis-password')
redis::instance {'sc-redis':
  redis_port         => $sc_redis_port,
  redis_bind_address => '127.0.0.1',
  redis_password     => $sc_redis_password,
}

class {'ptero::shell_command::web': }
class {'ptero::shell_command::celery': }
