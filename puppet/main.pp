package { 'nginx':
  ensure   => 'installed',
  provider => 'apt'
}

exec { 'nginx-run':
  command  => 'sudo service nginx start',
  provider => 'shell'
}

group { 'essence':
  ensure => 'present'
}

user { 'essence':
  ensure => 'present',
  groups => 'essence'
}
