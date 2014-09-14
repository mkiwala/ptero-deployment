class ptero::shell_command::rabbitmq() {
  $sc_rabbit_vhost = hiera('sc-rabbit-vhost')
  $sc_rabbit_user = hiera('sc-rabbit-user')
  $sc_rabbit_password = hiera('sc-rabbit-password')

  rabbitmq_vhost {$sc_rabbit_vhost :
    ensure => present,
  }

  rabbitmq_user {$sc_rabbit_user :
    password => $sc_rabbit_password,
  }

  rabbitmq_user_permissions {"$sc_rabbit_user@$sc_rabbit_vhost":
    configure_permission => '.*',
    read_permission      => '.*',
    write_permission     => '.*',
  }
}
