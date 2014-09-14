class ptero::shell_command::celery() {
  $sc_rabbit_vhost = hiera('sc-rabbit-vhost')
  $sc_rabbit_user = hiera('sc-rabbit-user')
  $sc_rabbit_password = hiera('sc-rabbit-password')

  $sc_redis_port = hiera('sc-redis-port')
  $sc_redis_password = hiera('sc-redis-password')

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

}
