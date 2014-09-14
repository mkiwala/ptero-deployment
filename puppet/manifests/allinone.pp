# -- Install packages ---
exec {'apt-get update':
  command => '/usr/bin/apt-get update',
}

Exec['apt-get update'] -> Package<| |>

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
  listen_port => 80,
  app         => 'puppet:///modules/ptero/auth/app.py',
  environment => {
    'SIGNATURE_KEY' => "$sig_key",
    'DATABASE_URL'  => "postgres://ptero_auth:$auth_pass@localhost/ptero_auth",
    'AUTH_URL'      => 'http://192.168.10.10',
  },
  require     => Postgresql::Server::Db['ptero_auth'],
}
