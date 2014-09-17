class ptero::shell_command::web() {
  require ptero::params

  ptero::web{'shell-command':
    code_dir    => $ptero::params::shell_command::target_directory,
    source      => $ptero::params::shell_command::repo,
    revision    => $ptero::params::shell_command::tag,
    listen_port => $ptero::params::shell_command::port,
    app         => 'puppet:///modules/ptero/shell-command/app.py',
    environment => {
      'CELERY_BROKER_URL'     => $ptero::params::shell_command::rabbitmq_url,
      'CELERY_RESULT_BACKEND' => $ptero::params::shell_command::redis_url,
    },
  }

}
