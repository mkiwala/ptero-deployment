# --- Setup database ---
class {'postgresql::server': }

postgresql::server::db {'ptero_auth':
  user     => 'ptero_auth',
  password => hiera('allinone::auth-postgres-password'),
}

# nginx
# gunicorn
# ptero-auth
