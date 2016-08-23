# == Class: telegraf::config
#
# Templated generation of telegraf.conf
#
class telegraf::config inherits telegraf {

  assert_private()

  file { $::telegraf::config_file:
    ensure  => file,
    content => template('telegraf/telegraf.conf.erb'),
    mode    => '0640',
    owner   => 'telegraf',
    group   => 'telegraf',
    notify  => Class['::telegraf::service'],
    require => Class['::telegraf::install'],
  }

  file { '/etc/telegraf/telegraf.d/':
    ensure  => directory,
    mode    => '0775',
    owner   => 'telegraf',
    group   => 'telegraf',
    require =>  Class['::telegraf::install'],
  }

  file { '/etc/incron.d/telegraf.cron':
    ensure  => present,
    content => file('telegraf/telegraf.cron'),
    mode    => '0755',
    owner   => 'telegraf',
    group   => 'telegraf',
    require => Class['::telegraf::install'],
  }

}
