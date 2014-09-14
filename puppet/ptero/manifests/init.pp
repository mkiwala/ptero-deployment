class ptero() {
  include ptero::params

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
