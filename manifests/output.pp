# == Define: telegraf::output
#
# A puppet wrapper for the output files
#
# === Parameters
# [*options*]
#   Options for use the the output template
#
# [*sections*]
#   Some outputs take multiple sections

define telegraf::output (
  $plugin_type = undef,
  $options    = undef,
  $sections   = undef,
) {
  include telegraf

  if $options {
    validate_hash($options)
  }

  if $sections {
    validate_hash($sections)
  }

  Class['telegraf::config'] ->
  Class['telegraf::service']
}
