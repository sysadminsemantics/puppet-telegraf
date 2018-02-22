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
      $lsof = "/usr/bin/lsof -n -P"
      if has_key( $::telegraf::inputs, 'tcp_listener') and has_key( $::telegraf::inputs[tcp_listener], 'service_address') {
        $tcp = "-i TCP@${::telegraf::inputs[tcp_listener][service_address]}"
      } else {
        $tcp = ""
      }
      if has_key( $::telegraf::inputs, 'udp_listener') and has_key( $::telegraf::inputs[udp_listener], 'service_address'){
        $udp = "-i UDP@${::telegraf::inputs[udp_listener][service_address]}"
      } else {
        $udp = ""
      }
      $restart = "/usr/sbin/service telegraf restart"
      if "" != $tcp or "" != $udp {
        Package['lsof'] ->
        cron { 'ensure telegraf is listening on local ports':
          command => "bash -c '${lsof} ${tcp} ${udp} || ${restart}' >/dev/null 2>&1"
        }
      }
    }
  }
}
