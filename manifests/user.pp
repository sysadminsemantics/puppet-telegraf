class telegraf::user {
  user {'telegraf':
    ensure => 'present',
    home   => '/etc/telegraf',
    shell  => '/bin/false'
  }
}
