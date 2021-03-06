# == Class: qdr
#
# Full description of class qdr here.
#
# === Parameters
#
# [*connectors*]
#   (optional) An array of hashes containing connector configuration
#   Defaults to []
#
# [*ssl_profiles*]
#   (optional) An array of hashes containing the ssl profiles
#   Defaults to []
#
# [*ensure_package*]
#   (optional) The state of the qdr packages
#   Defaults to 'installed'
#
# [*ensure_service*]
#   (optional) The state of the qdr service
#   Defaults to 'running'
#
# [*enable_service*]
#   (optional) The administrative status of the qdr service
#   Defaults to 'true'
#
# [*extra_listeners*]
#  (optional) An array of hashes containing extra listener configuration
#  Defaults to []
#
# [*listener_addr*]
#   (optional) Service host name
#   Defaults to '127.0.0.1'
#
# [*listener_auth_peer*]
#   (optional)
#   Defaults to false
#
# [*listener_idle_timeout*]
#   (optional)
#   Defaults to '16'
#
# [*listener_max_frame_size*]
#   (optional) Maximum frame size used for a message delivery over the
#   connection
#   Defaults to '16384'
#
# [*listener_port*]
#   (optional) Service port number (AMQP)
#   Defaults to '5672'
#
# [*listener_require_encrypt*]
#   (optional) Require the connection to the peer to be encrypted
#   Defaults to false
#
# [*listener_require_ssl*]
#   (optional) Require the use of SSL or TLS on the connection
#   Defaults to false
#
# [*listener_sasl_mech*]
#   (optional) List of accepted SASL auth mechanisms
#   Defaults to 'ANONYMOUS'
#
# [*listener_ssl_cert_db*]
#   (optional) Path to certificate db
#   Defaults to undef
#
# [*listener_ssl_cert_file*]
#   (optional) Path to certificat file
#   Defaults to undef
#
# [*listener_ssl_key_file*]
#   (optional) Path to private key file
#   Defaults to undef
#
# [*listener_ssl_pw_file*]
#   (optional) Path to password file for certificate key
#   Defaults to undef
#
# [*listener_ssl_password*]
#   (optional) Password to be supplied
#   Defaults to undef
#
# [*listener_trusted_certs*]
#   (optional) Path to file containing trusted certificates
#   Defaults to 'UNSET'
#
# [*autolink_addresses*]
#   (optional) An array of hashes containing the autoLink addresses
#   Defaults to []
#
# [*extra_addresses*]
#  (optional) An array of hashes containing extra address configuration
#  Defaults to []
#
# [*log_module*]
#   (optional) The log module to configure
#   Defaults to 'DEFAULT'
#
# [*log_enable*]
#   (optional) Log level for a module
#   Defaults to 'debug+'
#
# [*log_output*]
#   (optional) Target destination for log message
#   Defaults to '/var/log/qdrouterd/qdrouterd.log'
#
# [*router_debug_dump*]
#   (optional) Path to file for debugging information
#   Defaults to '/var/log/qdrouterd'
#
# [*router_hello_interval*]
#   (optional) Router HELLO message interval in seconds
#   Defaults to '1'
#
# [*router_hello_max_age*]
#   (optional) Neighbor router age timeout in seconds
#   Defaults to '3'
#
# [*router_id*]
#   (optional) Router unique identifer
#   Defaults to 'Router.fqdn"
#
# [*router_mode*]
#   (optional) Operational mode for Router (standalone, edge or interconnected)
#   Defaults to 'standalone'
#
# [*router_ra_interval*]
#   (optional) Router advertisement interval
#   Defaults to '30'
#
# [*router_ra_interval_flux*]
#   (optional) Router advertisement interval during topology changes
#   Defaults to '4'
#
# [*router_remote_ls_max_age*]
#   (optional) Router advertisement aging interval
#   Defaults to '60'
#
# [*router_sasl_name*]
#   (optional) Name of SASL configuration
#   Defaults to 'qdrouterd'
#
# [*router_sasl_path*]
#   (optional) Path to the SASL configuration file
#   Defaults to '/etc/sasl2'
#
# [*router_worker_threads*]
#   (optional) Number of threads create to process message traffic
#   Defaults to $::processorcount
#
class qdr(
  $connectors                 = [],
  $ssl_profiles               = [],
  $ensure_package             = 'installed',
  $ensure_service             = 'running',
  $enable_service             = true,
  $extra_listeners            = [],
  $listener_addr              = '127.0.0.1',
  $listener_auth_peer         = false,
  $listener_idle_timeout      = '16',
  $listener_max_frame_size    = '16384',
  $listener_port              = '5672',
  $listener_require_encrypt   = false,
  $listener_require_ssl       = false,
  $listener_sasl_mech         = 'ANONYMOUS',
  $listener_ssl_cert_db       = undef,
  $listener_ssl_cert_file     = undef,
  $listener_ssl_key_file      = undef,
  $listener_ssl_pw_file       = undef,
  $listener_ssl_password      = undef,
  $listener_trusted_certs     = 'UNSET',
  $autolink_addresses         = [],
  $extra_addresses            = [],
  $log_enable                 = 'debug+',
  $log_module                 = 'DEFAULT',
  $log_output                 = '/var/log/qdrouterd/qdrouterd.log',
  $router_debug_dump          = '/var/log/qdrouterd',
  $router_hello_interval      = '1',
  $router_hello_max_age       = '3',
  $router_id                  = "Router.${::fqdn}",
  $router_mode                = 'standalone',
  $router_ra_interval         = '30',
  $router_ra_interval_flux    = '4',
  $router_remote_ls_max_age   = '60',
  $router_sasl_name           = 'qdrouterd',
  $router_sasl_path           = '/etc/sasl2',
  $router_worker_threads      = $::os_workers,
) inherits qdr::params {

  validate_legacy(Stdlib::Absolutepath, 'validate_absolute_path', $router_debug_dump)
  validate_legacy(Stdlib::Absolutepath, 'validate_absolute_path', $router_sasl_path)
  validate_legacy(String, 'validate_string', $router_sasl_name)
  validate_legacy(Enum['standalone', 'edge', 'interior'], 'validate_re', $router_mode,
    ['^(standalone$|edge$|interior$)'])
  validate_legacy(String, 'validate_string', $router_id)
  validate_legacy(String, 'validate_string', $listener_addr)
  validate_legacy(Integer, 'validate_re', $listener_port, ['\d+'])
  validate_legacy(String, 'validate_string', $listener_sasl_mech)

  $listener_auth_peer_bool = qdr::fixTruthy($listener_auth_peer)
  $listener_require_encrypt_bool = qdr::fixTruthy($listener_require_encrypt)
  $listener_require_ssl_bool = qdr::fixTruthy($listener_require_ssl)

# TODO (ansmith) - manage repo via openstack-extras
#  if $::operatingsystem == 'Ubuntu' {
#      include apt
#
#      Class['apt::update'] -> Package<| provider == 'apt' |>
#
#      apt::ppa { 'ppa:qpid/testing' : }
#  }

  include qdr::install
  include qdr::config
  include qdr::service

  Class['qdr::install']
    -> Class['qdr::config']
      -> Class['qdr::service']

}

function qdr::fixTruthy($truthyvar) >> Boolean {
  if $truthyvar.is_a(String) {
    validate_legacy(Enum['yes', 'no'], 'validate_re', $truthyvar, ['^(yes$|no$)'])
    warning('Usage of yes/no has been deprecated. Use boolean instead')
    if $truthyvar == 'yes' {
      return true
    } elsif $truthyvar == 'no' {
      return false
    }
  } else {
    validate_legacy(Boolean, 'validate_bool', $truthyvar)
    return $truthyvar
  }
}
