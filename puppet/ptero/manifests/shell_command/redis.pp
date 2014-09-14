class ptero::shell_command::redis() {
  $sc_redis_port = hiera('sc-redis-port')
  $sc_redis_password = hiera('sc-redis-password')

  redis::instance {'sc-redis':
    redis_port         => $sc_redis_port,
    redis_bind_address => '127.0.0.1',
    redis_password     => $sc_redis_password,
  }
}
