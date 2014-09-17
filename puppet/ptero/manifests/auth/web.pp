class ptero::auth::web() {
  require ptero::params

  ptero::web{'auth':
    code_dir    => $ptero::params::auth::target_directory,
    source      => $ptero::params::auth::repo,
    revision    => $ptero::params::auth::tag,
    listen_port => $ptero::params::auth::port,
    app         => 'puppet:///modules/ptero/auth/app.py',
    environment => {
      'SIGNATURE_KEY' => $ptero::params::auth::signature_key,
      'DATABASE_URL'  => $ptero::params::auth::database_url,
      'AUTH_URL'      => $ptero::params::auth::url,
    },
  }
}
