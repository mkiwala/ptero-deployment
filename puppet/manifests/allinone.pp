# -- Install packages ---
exec {'apt-get update':
  command => '/usr/bin/apt-get update',
}

Exec['apt-get update'] -> Package<| |>

package {'git':
  ensure => present,
}

class {'python':
  dev        => true,
  gunicorn   => true,
  version    => 'system',
  virtualenv => true,
}

class {'ptero': }

package {'python-psycopg2':
  ensure => present,
}


# --- Setup database ---
class {'postgresql::server': }

postgresql::server::db {'ptero_auth':
  user     => 'ptero_auth',
  password => hiera('allinone::auth-postgres-password'),
}


# -- Install code --
vcsrepo {'/var/www/auth':
  ensure   => present,
  provider => git,
  source   => hiera('allinone::auth-repo'),
  revision => hiera('allinone::auth-tag'),
  owner    => 'www-data',
  group    => 'www-data',
  require  => Package['git'],
  notify   => Service['gunicorn'],
}

python::virtualenv {'/var/www/auth/virtualenv':
  requirements => '/var/www/auth/requirements.txt',
  owner        => 'www-data',
  group        => 'www-data',
  systempkgs   => true,
  require      => Vcsrepo['/var/www/auth'],
  subscribe    => Vcsrepo['/var/www/auth'],
  notify       => Service['gunicorn'],
}

file {'/var/www/auth/app.py':
  owner   => 'www-data',
  group   => 'www-data',
  mode    => '644',
  source  => 'puppet:///modules/ptero/auth/app.py',
  require => Vcsrepo['/var/www/auth'],
}

# --- Setup gunicorn ---
$sig_key = hiera('allinone::auth-signature-key')
$auth_pass = hiera('allinone::auth-postgres-password')
python::gunicorn {'auth':
  dir         => '/var/www/auth',
  bind        => 'unix:/tmp/auth.socket',
  virtualenv  => '/var/www/auth/virtualenv',
  environment => {
    'SIGNATURE_KEY' => "$sig_key",
    'DATABASE_URL'  => "postgres://ptero_auth:$auth_pass@localhost/ptero_auth",
    'AUTH_URL'      => 'http://192.168.10.10',
  },
  template => 'ptero/gunicorn.erb',
  require  => [
    Python::Virtualenv['/var/www/auth/virtualenv'],
    File['/var/www/auth/app.py'],
  ],
}


# --- Setup Nginx ---
class {'nginx': }

nginx::resource::upstream {'auth':
  members => [
    'unix:/tmp/auth.socket',
  ],
}

nginx::resource::vhost {'auth':
  proxy       => 'http://auth',
}
