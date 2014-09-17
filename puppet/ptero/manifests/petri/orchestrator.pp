class ptero::petri::orchestrator(
  $owner = 'celery',
  $group = 'celery',
) {
  require ptero

  $code_dir = $ptero::params::petri::target_directory

  if ! defined(User[$owner]) {
    user {$owner:
      ensure   => present,
      provider => 'useradd',
      gid      => $group,
      require  => Group[$group],
    }
  }

  if ! defined(Group[$group]) {
    group {$group:
      ensure => present,
    }
  }

  if ! defined(Ptero::Code[$code_dir]) {
    ptero::code{$code_dir:
      source   => $ptero::params::petri::repo,
      revision => $ptero::params::petri::tag,
      owner    => 'www-data',
      group    => 'www-data',
    }
  }

  class { 'circus': }

  $circus_command = "$ptero::params::petri::target_directory/virtualenv/bin/python"
  $circus_args = "ptero_petri/implementation/orchestrator/main.py"
  $circus_working_dir = $ptero::params::petri::target_directory
  $circus_numprocesses = "$ptero::params::petri::num_orchestrators"
  $circus_uid = $owner
  $circus_gid = $group
  $circus_environment = {
    'PTERO_PETRI_AMQP_HOST'                => $ptero::params::petri::rabbitmq_host,
    'PTERO_PETRI_AMQP_PORT'                => $ptero::params::petri::rabbitmq_port,
    'PTERO_PETRI_AMQP_VHOST'               => $ptero::params::petri::rabbitmq_vhost,
    'PTERO_PETRI_AMQP_RETRY_DELAY'         => 2,
    'PTERO_PETRI_AMQP_CONNECTION_ATTEMPTS' => 10,
    'PTERO_PETRI_AMQP_PREFETCH_COUNT'      => 10,
    'PTERO_PETRI_AMQP_HEARTBEAT_INTERVAL'  => 600,
    'PTERO_PETRI_REDIS_HOST'               => $ptero::params::petri::redis_host,
    'PTERO_PETRI_REDIS_PORT'               => $ptero::params::petri::redis_port,
    'PTERO_PETRI_HOST'                     => $ptero::params::petri::ip,
    'PTERO_PETRI_PORT'                     => $ptero::params::petri::port,
    'PYTHONPATH'                           => $code_dir,
  }

  file {'/etc/circus/conf.d/orchestrator.ini':
    owner        => 'root',
    group        => 'root',
    mode         => '644',
    content      => template('ptero/orchestrator-circus.ini.erb'),
    require      => File['/etc/circus/conf.d'],
    notify       => Service['circus'],
  }
}
