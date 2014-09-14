class ptero() {
  class {'python':
    dev        => true,
    gunicorn   => true,
    version    => 'system',
    virtualenv => true,
  }

  package {'git':
    ensure => present,
  }
}
