define ptero::web (
  $code_dir,
  $source,
  $revision,
  $app,
  $listen_port,
  $owner = 'www-data',
  $group = 'www-data',
  $environment = false,
) {

# -- Install code --
  vcsrepo {$code_dir:
    ensure   => present,
    provider => git,
    source   => $source,
    revision => $revision,
    owner    => $owner,
    group    => $group,
    require  => Package['git'],
    notify   => Service['gunicorn'],
  }

  python::virtualenv {"$code_dir/virtualenv":
    requirements => "$code_dir/requirements.txt",
    owner        => $owner,
    group        => $group,
    systempkgs   => true,
    require      => Vcsrepo[$code_dir],
    subscribe    => Vcsrepo[$code_dir],
    notify       => Service['gunicorn'],
  }

  file {"$code_dir/app.py":
    owner   => $owner,
    group   => $group,
    mode    => '644',
    source  => $app,
    require => Vcsrepo[$code_dir],
    notify  => Service['gunicorn'],
  }

# --- Setup gunicorn ---
  python::gunicorn {$title:
    dir         => $code_dir,
    bind        => "unix:$code_dir/socket",
    virtualenv  => "$code_dir/virtualenv",
    environment => $environment,
    template    => 'ptero/gunicorn.erb',
    subscribe   => [
      Vcsrepo[$code_dir],
      Python::Virtualenv["$code_dir/virtualenv"],
    ],
    require     => [
      Python::Virtualenv["$code_dir/virtualenv"],
      File["$code_dir/app.py"],  # XXX HMM
    ],
  }

# --- Setup nginx ---
  nginx::resource::upstream { $title :
    members => [
      "unix:$code_dir/socket",
    ],
  }

  nginx::resource::vhost { $title :
    listen_port => $listen_port,
    proxy       => "http://$title",
  }
}
