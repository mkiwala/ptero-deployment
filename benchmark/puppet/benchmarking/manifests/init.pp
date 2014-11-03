class benchmarking() {
    package {'jq':
        ensure => present,
    }

    package{'bc':
        ensure => present,
    }

    file {'/usr/local/bin/benchmark_start':
        ensure  => present,
        owner   => root,
        group   => root,
        mode    => '0555',
        source  => 'puppet:///modules/benchmarking/benchmark_start',
    }

    file {'/usr/local/bin/benchmark_sleep':
        ensure  => present,
        owner   => root,
        group   => root,
        mode    => '0555',
        source  => 'puppet:///modules/benchmarking/benchmark_sleep',
    }

    file {'/usr/local/bin/benchmark_stop':
        ensure  => present,
        owner   => root,
        group   => root,
        mode    => '0555',
        source  => 'puppet:///modules/benchmarking/benchmark_stop',
    }
}
