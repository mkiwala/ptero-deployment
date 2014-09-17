class ptero::petri::rabbitmq() {
  require ptero::params

  rabbitmq_vhost {$ptero::params::petri::rabbitmq_vhost :
    ensure => present,
  }

  rabbitmq_user {$ptero::params::petri::rabbitmq_username :
    password => $ptero::params::petri::rabbitmq_password,
  }

  rabbitmq_user_permissions {$ptero::params::petri::rabbitmq_full_user :
    configure_permission => '.*',
    read_permission      => '.*',
    write_permission     => '.*',
  }
}
