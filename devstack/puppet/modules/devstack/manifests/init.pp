class devstack {
    exec { 'apt-update':
        command => '/usr/bin/apt-get update'; }

    Exec["apt-update"] -> Package <| |>

    package { 'git': ensure => present }

    exec { 'git clone devstack':
        require => Package['git'],
        user => 'vagrant', group => 'vagrant',
        cwd     => '/home/vagrant',
        creates => '/home/vagrant/devstack',
        command => '/usr/bin/git clone https://github.com/openstack-dev/devstack.git'; }

    file { '/home/vagrant/devstack/local.conf':
        require => Exec['git clone devstack'],
        owner   => 'vagrant', group => 'vagrant',
        mode    => '0644',
        content => template('devstack/local.conf.erb'),
    }

    exec { 'stack.sh':
        require => File['/home/vagrant/devstack/local.conf'],
        user => 'vagrant', group => 'vagrant',
        cwd     => '/home/vagrant/devstack',
        timeout => 0,
        environment => ["HOME=/home/vagrant"],
        command => '/home/vagrant/devstack/stack.sh';}
}
