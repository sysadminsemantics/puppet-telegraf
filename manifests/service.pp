# == Class: telegraf::service
#
# Optionally manage the Telegraf service.
#
class telegraf::service {

  assert_private()

  if $::telegraf::manage_service {
    service { 'telegraf':
      ensure    => running,
      hasstatus => true,
      enable    => true,
      restart   => 'pkill -HUP telegraf',
      require   => Class['::telegraf::config'],
    }

    if has_key( $::telegraf::inputs, 'tcp_listener') or has_key( $::telegraf::inputs, 'udp_listener') {
      # setup cronjob to check if ports are open and restart telegraf if not
      if has_key( $::telegraf::inputs, 'tcp_listener') and has_key( $::telegraf::inputs[tcp_listener], 'service_address') {
        $tcp_port = split( $::telegraf::inputs[tcp_listener][service_address], ':')[1]
        $tcp = "/bin/fuser -s -n tcp ${tcp_port}"
      } else {
        $tcp = "/bin/true"
      }
      if has_key( $::telegraf::inputs, 'udp_listener') and has_key( $::telegraf::inputs[udp_listener], 'service_address') {
        $udp_port = split( $::telegraf::inputs[udp_listener][service_address], ':')[1]
        $udp = "/bin/fuser -s -n udp ${udp_port}"
      } else {
        $udp = "/bin/true"
      }
      $restart = "/usr/sbin/service telegraf restart"
      Package['psmisc'] ->
      cron { 'ensure telegraf is listening on local ports':
        command => "bash -c '( ${tcp} && ${udp} ) || ${restart}' >/dev/null 2>&1"
      }
    }
  }
}
