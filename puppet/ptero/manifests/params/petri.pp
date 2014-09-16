class ptero::params::petri {
  $database_type = hiera('petri-database-type', 'postgres')
  $database_host = hiera('petri-database-host', 'localhost')
  $database_username = hiera('petri-database-username')
  $database_password = hiera('petri-database-password')
  $database_name = hiera('petri-database-username')
  $database_url = "$database_type://$database_username:$database_password@$database_host/$database_name"

  $rabbitmq_host = hiera('petri-rabbit-host', 'localhost')
  $rabbitmq_port = hiera('petri-rabbit-port', 5672)
  $rabbitmq_vhost = hiera('petri-rabbit-vhost')
  $rabbitmq_username = hiera('petri-rabbit-user')
  $rabbitmq_password = hiera('petri-rabbit-password')
  $rabbitmq_full_user = "$rabbitmq_username@$rabbitmq_vhost"
  $rabbitmq_url = "amqp://$rabbitmq_username:$rabbitmq_password@$rabbitmq_host:$rabbitmq_port/$rabbitmq_vhost"

  $redis_host = hiera('petri-redis-host', 'localhost')
  $redis_port = hiera('petri-redis-port')
  $redis_password = hiera('petri-redis-password')
  $redis_url = "redis://:$redis_password@$redis_host:$redis_port"

  $target_directory = hiera('petri-target-directory', '/var/www/petri')
  $repo = hiera('petri-repo')
  $tag = hiera('petri-tag')

  $host = hiera('petri-host')
  $port = hiera('petri-port')
  $url = "http://$host:$port"

  $num_orchestrators = hiera('petri-num-orchestrators')
}
