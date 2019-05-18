package { 'nginx-install':
  ensure => 'installed'
}

exec { 'nginx-run':
  command  => 'sudo service nginx start',
  provider => 'shell'
}

group { 'group-create':
  ensure => 'present'
}

user { 'user-create':
  ensure => 'present',
  groups => 'web'
}
