define ptero::celery (
  $code_dir,
  $source,
  $revision,
  $app,
  $environment = false,
  $owner  = 'celery',
  $group  = 'celery',
) {
  $virtualenv = "$code_dir/virtualenv"

  user {$owner:
    ensure   => present,
    provider => 'useradd',
    gid      => $group,
    require  => Group[$group],
  }

  group {$group:
    ensure => present,
  }

  if ! defined(Vcsrepo[$code_dir]) {
    vcsrepo {$code_dir:
      ensure   => present,
      provider => git,
      source   => $source,
      revision => $revision,
      owner    => $owner,
      group    => $group,
      require  => Package['git'],
    }
  }

  if ! defined(Python::Virtualenv[$virtualenv]) {
    python::virtualenv {$virtualenv:
      requirements => "$code_dir/requirements.txt",
      owner        => $owner,
      group        => $group,
      systempkgs   => true,
      require      => Vcsrepo[$code_dir],
      subscribe    => Vcsrepo[$code_dir],
    }
  }

  file {"/etc/init.d/celeryd-$title":
    owner   => 'root',
    group   => 'root',
    mode    => '755',
    content => template('ptero/init.d.celeryd.erb'),
    require   => [
      User[$owner],
      Group[$group],
    ],
  }

  file {'/var/run/celery':
    ensure  => 'directory',
    owner   => 'root',
    group   => $group,
    mode    => '2775',
    require => Group[$group],
  }

  file {'/var/log/celery':
    ensure  => 'directory',
    owner   => 'root',
    group   => $group,
    mode    => '2775',
    require => Group[$group],
  }

  service {"celeryd-$title":
    ensure    => running,
    require   => [
      File["/etc/init.d/celeryd-$title"],
      Python::Virtualenv[$virtualenv],
      User[$owner],
      Group[$group],
    ],
    subscribe => [
      File["/etc/init.d/celeryd-$title"],
      Python::Virtualenv[$virtualenv],
    ],
  }

}
