class ptero::shell_command::celery() {
  require ptero::params

  ptero::celery{'shell-command':
    code_dir => $ptero::params::shell_command::target_directory,
    source   => $ptero::params::shell_command::repo,
    revision => $ptero::params::shell_command::tag,
    app      => 'ptero_shell_command_fork.implementation.celery_app:app',
    environment => {
      'CELERY_BROKER_URL'     => $ptero::params::shell_command::rabbitmq_url,
      'CELERY_RESULT_BACKEND' => $ptero::params::shell_command::redis_url,
      'PYTHONPATH'            => $ptero::params::shell_command::target_directory,
    },
  }
}
