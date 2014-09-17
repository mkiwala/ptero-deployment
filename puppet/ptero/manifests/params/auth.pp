class ptero::params::auth {
  $signature_key = hiera('auth-signature-key')

  $database_type = hiera('auth-database-type', 'postgres')
  $database_host = hiera('auth-database-host', 'localhost')
  $database_username = hiera('auth-database-username', 'ptero_auth')
  $database_password = hiera('auth-postgres-password')
  $database_name = hiera('auth-database-username', 'ptero_auth')
  $database_url = "$database_type://$database_username:$database_password@$database_host/$database_name"

  $target_directory = hiera('auth-target-directory', '/var/www/auth')
  $repo = hiera('auth-repo')
  $tag = hiera('auth-tag')

  $host = hiera('auth-host', $::ipaddress)
  $port = hiera('auth-port')
  $url = "http://$host:$port"
}
