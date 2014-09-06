class devstack {
    exec { 'apt-get update':
        command => '/usr/bin/apt-get update'; }

    exec { 'apt-get install git':
        require => Exec['apt-get update'],
        command => '/usr/bin/apt-get -y install git'; }

    exec { 'git clone devstack':
        require => Exec['apt-get install git'],
        user => 'vagrant', group => 'vagrant',
        cwd     => '/home/vagrant',
        creates => '/home/vagrant/devstack',
        command => '/usr/bin/git clone https://github.com/openstack-dev/devstack.git'; }

    file { '/home/vagrant/devstack/local.conf':
        require => Exec['git clone devstack'],
        owner => 'vagrant', group => 'vagrant',
        mode => '0644',
        source => 'puppet:///modules/devstack/local.conf';}

    exec { 'stack.sh':
        require => File['/home/vagrant/devstack/local.conf'],
        user => 'vagrant', group => 'vagrant',
        cwd     => '/home/vagrant/devstack',
        timeout => 0,
        environment => ["HOME=/home/vagrant"],
        command => '/home/vagrant/devstack/stack.sh';}
}
