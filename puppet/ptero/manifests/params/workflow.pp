class ptero::params::workflow {
  $database_type = hiera('workflow-database-type', 'postgres')
  $database_host = hiera('workflow-database-host', 'localhost')
  $database_username = hiera('workflow-database-username')
  $database_password = hiera('workflow-database-password')
  $database_name = hiera('workflow-database-username')
  $database_url = "$database_type://$database_username:$database_password@$database_host/$database_name"

  $target_directory = hiera('workflow-target-directory', '/var/www/workflow')
  $repo = hiera('workflow-repo')
  $tag = hiera('workflow-tag')

  $host = hiera('workflow-host')
  $port = hiera('workflow-port')
  $url = "http://$host:$port"
}

