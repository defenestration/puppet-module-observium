# == Class: observium
#
# This module manages Observium
#
class observium (
  $base_path                 = '/opt/observium',
  $config_path               = '/opt/observium/config.php',
  $config_mode               = '0755',
  $config_owner              = 'root',
  $config_group              = 'root',
  $communities               = ['public'],
  $devices                   = undef,
  $http_port                 = '80',
  $mysql_host                = undef,
  $mysql_db                  = undef,
  $mysql_user                = undef,
  $mysql_password            = undef,
  $packages                  = 'USE_DEFAULTS',
  $poller_threads            = '1',
  $rrd_path                  = '/opt/observium/rrd',
  $rrd_mode                  = '0755',
  $rrd_owner                 = 'root',
  $rrd_group                 = 'root',
  $servername                = $::fqdn,
  $snmp_version              = 'v2c',
  $users                     = undef,
  $cron_discovery_all_hour   = '*/6',
  $cron_discovery_all_minute = '33',
  $cron_discovery_all_user   = 'root',
  $cron_discovery_new_minute = '*/5',
  $cron_discovery_new_user   = 'root',
  $cron_poller_minute        = '*/5',
  $cron_poller_user          = 'root',
) {

  include observium::apache

  file { 'observium_path':
    ensure => directory,
    name   => $base_path,
    owner  => 'root',
    group  => 'root',
    mode   => '0755',
  }

  case $::osfamily {
    'Debian': {
      $default_packages = 'observium'
      if $packages == 'USE_DEFAULTS' {
        $my_packages = $default_packages
      } else {
        $my_packages = $packages
      }
      package { 'observium_packages':
        ensure  => installed,
        name    => $my_packages,
      }
    }
    'RedHat': {
      file { "$base_path/observium-community-latest.tar.gz":
        ensure => present,
        content => "http://www.observium.org/observium-community-latest.tar.gz",
      }
      exec { "extract observium"
        command => "tar zxvf observium-community-latest.tar.gz",
      }
    }
    default: {
      fail("Module observium is supported on osfamily Debian. Your osfamily is identified as ${::osfamily}")
    }
  }

  if $users {
    validate_hash($users)
    create_resources('observium::user', $users)
  }

  if $devices {
    validate_array($devices)
    observium::device { $devices: }
  }

  file { 'observium_config':
    ensure  => present,
    path    => $config_path,
    mode    => $config_mode,
    owner   => $config_owner,
    group   => $config_group,
    content => template('observium/config.php.erb'),
    require => Package['observium_packages'],
    notify  => Exec['update_db'],
  }

  file { 'observium_rrd_base':
    ensure  => directory,
    path    => $rrd_path,
    mode    => $rrd_mode,
    owner   => $rrd_owner,
    group   => $rrd_group,
    require => File['observium_path'],
  }

  exec { 'update_db':
    path        => '/bin:/usr/bin:/usr/local/bin',
    command     => 'php includes/update/update.php',
    cwd         => $base_path,
    refreshonly => true,
  }

  cron { 'discovery-all':
    command => "${base_path}/discovery.php -h all >> /dev/null 2>&1",
    user    => $cron_discovery_all_user,
    minute  => $cron_discovery_all_minute,
    hour    => $cron_discovery_all_hour,
  }

  cron { 'discovery-new':
    command => "${base_path}/discovery.php -h new >> /dev/null 2>&1",
    user    => $cron_discovery_new_user,
    minute  => $cron_discovery_new_minute,
  }

  cron { 'poller':
    command => "${base_path}/poller-wrapper.py ${poller_threads} >> /dev/null 2>&1",
    user    => $cron_poller_user,
    minute  => $cron_poller_minute,
  }
}
