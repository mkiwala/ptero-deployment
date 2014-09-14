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


# --- Auth ---
$sig_key = hiera('auth-signature-key')
$auth_pass = hiera('auth-postgres-password')
ptero::web{'auth':
  code_dir    => '/var/www/auth',
  source      => hiera('auth-repo'),
  revision    => hiera('auth-tag'),
  listen_port => hiera('auth-port'),
  app         => 'puppet:///modules/ptero/auth/app.py',
  environment => {
    'SIGNATURE_KEY' => "$sig_key",
    'DATABASE_URL'  => "postgres://ptero_auth:$auth_pass@localhost/ptero_auth",
    'AUTH_URL'      => 'http://192.168.10.10',
  },
  require     => Postgresql::Server::Db['ptero_auth'],
}


# -- Shell command ---
$sc_rabbit_vhost = hiera('sc-rabbit-vhost')
$sc_rabbit_user = hiera('sc-rabbit-user')
$sc_rabbit_password = hiera('sc-rabbit-password')
rabbitmq_vhost {$sc_rabbit_vhost :
  ensure => present,
}

rabbitmq_user {$sc_rabbit_user :
  password => $sc_rabbit_password,
}

rabbitmq_user_permissions {"$sc_rabbit_user@$sc_rabbit_vhost":
  configure_permission => '.*',
  read_permission      => '.*',
  write_permission     => '.*',
}


$sc_redis_port = hiera('sc-redis-port')
$sc_redis_password = hiera('sc-redis-password')
redis::instance {'sc-redis':
  redis_port         => $sc_redis_port,
  redis_bind_address => '127.0.0.1',
  redis_password     => $sc_redis_password,
}

ptero::web{'shell-command':
  code_dir    => '/var/www/shell-command',
  source      => hiera('sc-repo'),
  revision    => hiera('sc-tag'),
  listen_port => hiera('sc-port'),
  app         => 'puppet:///modules/ptero/shell-command/app.py',
  require     => [
    Class['rabbitmq'],
    Redis::Instance['sc-redis'],
  ],
  environment => {
    'CELERY_BROKER_URL'     =>
      "amqp://$sc_rabbit_user:$sc_rabbit_password@localhost/$sc_rabbit_vhost",
    'CELERY_RESULT_BACKEND' =>
      "redis://:$sc_redis_password@localhost:$sc_redis_port",
  },
}

ptero::celery{'shell-command':
  code_dir => '/var/www/shell-command',
  source   => hiera('sc-repo'),
  revision => hiera('sc-tag'),
  app      => 'ptero_shell_command_fork.implementation.celery_app:app',
  environment => {
    'CELERY_BROKER_URL'     =>
      "amqp://$sc_rabbit_user:$sc_rabbit_password@localhost/$sc_rabbit_vhost",
    'CELERY_RESULT_BACKEND' =>
      "redis://:$sc_redis_password@localhost:$sc_redis_port",
    'PYTHONPATH'            => '/var/www/shell-command',
  },
}
