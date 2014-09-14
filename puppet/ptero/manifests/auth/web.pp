class ptero::auth::web() {

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
      'DATABASE_URL'  =>
        "postgres://ptero_auth:$auth_pass@localhost/ptero_auth",
      'AUTH_URL'      => 'http://192.168.10.10',
    },
    require     => Postgresql::Server::Db['ptero_auth'],
  }

}
