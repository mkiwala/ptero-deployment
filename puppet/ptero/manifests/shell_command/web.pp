class ptero::shell_command::web() {
  $sc_rabbit_vhost = hiera('sc-rabbit-vhost')
  $sc_rabbit_user = hiera('sc-rabbit-user')
  $sc_rabbit_password = hiera('sc-rabbit-password')

  $sc_redis_port = hiera('sc-redis-port')
  $sc_redis_password = hiera('sc-redis-password')

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

}
