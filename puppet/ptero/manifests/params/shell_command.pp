class ptero::params::shell_command {
  $rabbitmq_host = hiera('sc-rabbit-host', 'localhost')
  $rabbitmq_port = hiera('sc-rabbit-port', 5672)
  $rabbitmq_vhost = hiera('sc-rabbit-vhost')
  $rabbitmq_username = hiera('sc-rabbit-user')
  $rabbitmq_password = hiera('sc-rabbit-password')
  $rabbitmq_full_user = "$rabbitmq_username@$rabbitmq_vhost"
  $rabbitmq_url = "amqp://$rabbitmq_username:$rabbitmq_password@$rabbitmq_host:$rabbitmq_port/$rabbitmq_vhost"

  $redis_host = hiera('sc-redis-host', 'localhost')
  $redis_port = hiera('sc-redis-port')
  $redis_password = hiera('sc-redis-password')
  $redis_url = "redis://:$redis_password@$redis_host:$redis_port"

  $target_directory = hiera('sc-target-directory', '/var/www/shell-command')
  $repo = hiera('sc-repo')
  $tag = hiera('sc-tag')

  $host = hiera('sc-host', $::ipaddress)
  $port = hiera('sc-port')
  $url = "http://$host:$port"
}
