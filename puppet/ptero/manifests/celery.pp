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
      source   => $source,
      revision => $revision,
      owner    => $owner,
      group    => $group,
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

  if ! defined(File['/var/run/celery']) {
    file {'/var/run/celery':
      ensure  => 'directory',
      owner   => 'root',
      group   => $group,
      mode    => '2775',
      require => Group[$group],
    }
  }

  if ! defined(File['/var/log/celery']) {
    file {'/var/log/celery':
      ensure  => 'directory',
      owner   => 'root',
      group   => $group,
      mode    => '2775',
      require => Group[$group],
    }
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
