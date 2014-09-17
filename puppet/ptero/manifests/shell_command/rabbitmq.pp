class ptero::shell_command::rabbitmq() {
  require ptero::params

  rabbitmq_vhost {$ptero::params::shell_command::rabbitmq_vhost :
    ensure => present,
  }

  rabbitmq_user {$ptero::params::shell_command::rabbitmq_username :
    password => $ptero::params::shell_command::rabbitmq_password,
  }

  rabbitmq_user_permissions {$ptero::params::shell_command::rabbitmq_full_user :
    configure_permission => '.*',
    read_permission      => '.*',
    write_permission     => '.*',
  }
}
