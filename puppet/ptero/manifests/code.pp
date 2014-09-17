define ptero::code (
  $source,
  $revision,
  $owner,
  $group,
) {

  if ! defined(Vcsrepo[$title]) {
    vcsrepo {$title:
      ensure   => present,
      provider => git,
      source   => $source,
      revision => $revision,
      owner    => $owner,
      group    => $group,
      require  => Package['git'],
    }
  }

  if ! defined(Python::Virtualenv["$title/virtualenv"]) {
    python::virtualenv {"$title/virtualenv":
      requirements => "$title/requirements.txt",
      owner        => $owner,
      group        => $group,
      systempkgs   => true,
      require      => Vcsrepo[$title],
      subscribe    => Vcsrepo[$title],
    }
  }
}
