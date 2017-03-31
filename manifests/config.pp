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

  # Temporary (tm) fix to potential massive growth of log files. Overwrite debian package's default logrotate conf and hack it to force hourly run
  file {
  '/etc/logrotate.d/telegraf':
    ensure  => present,
    content => template('telegraf/logrotate.conf.erb'),
    mode    => '0644',
    owner   => 'root',
    group   => 'root';
  '/etc/cron.hourly/telegraf':
    ensure  => present,
    content => template('telegraf/cron.hourly.erb'),
    mode    => '0755',
    owner   => 'root',
    group   => 'root';
  # Ownership for newer telegraf installations incorrect, therefore it is unable to write logs, this ensures correct permissions
  '/var/log/telegraf':
    ensure  => present,
    mode    => '0755',
    owner   => 'telegraf',
    group   => 'telegraf',
    notify  => Service['telegraf'];
  }

}
