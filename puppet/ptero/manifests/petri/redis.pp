class ptero::petri::redis() {
  require ptero::params

  redis::instance {'petri-redis':
    redis_port         => $ptero::params::petri::redis_port,
    redis_bind_address => '127.0.0.1',
    redis_password     => $ptero::params::petri::redis_password,
  }
}
