# == Class: observium::apache
#
class observium::apache {

  include apache
  include apache::params
  include apache::mod::php
  ensure_resource( 'apache::mod',  'rewrite' )
  # ensure_resource( 'apache::mod', ' php' )

  apache::vhost { 'observium':
    priority           => '10',
    port               => $observium::http_port,
    docroot            => "${observium::base_path}/html",
    logroot            => "${observium::base_path}/logs",
    servername         => $observium::servername,
    # configure_firewall => false,
    override           => 'All',
  }
}
