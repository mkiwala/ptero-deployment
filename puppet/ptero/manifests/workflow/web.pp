class ptero::workflow::web {
  require ptero::params

  ptero::web{'workflow':
    code_dir                     => $ptero::params::workflow::target_directory,
    source                       => $ptero::params::workflow::repo,
    revision                     => $ptero::params::workflow::tag,
    listen_port                  => $ptero::params::workflow::port,
    app                          => 'puppet:///modules/ptero/workflow/app.py',
    environment                  => {
      'PTERO_WORKFLOW_DB_STRING' => $ptero::params::workflow::database_url,
    },
  }
}

