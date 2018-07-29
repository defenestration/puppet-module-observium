    }
    owner   => $rrd_owner,
      $default_packages = 'observium'
  $mysql_user                = undef,
  $mysql_db                  = undef,
    validate_array($devices)
    owner   => $config_owner,
  cron { 'discovery-new':
#
    command => "${base_path}/discovery.php -h all >> /dev/null 2>&1",
  $rrd_owner                 = 'root',
        name    => $my_packages,
    }
    path    => $config_path,
    user    => $cron_discovery_new_user,
    command     => 'php includes/update/update.php',
  $cron_poller_minute        = '*/5',
  $cron_discovery_new_user   = 'root',
    mode   => '0755',

    ensure  => present,
  $mysql_password            = undef,
    user    => $cron_discovery_all_user,
    group  => 'root',
      }
      }
        $my_packages = $packages
    command => "${base_path}/discovery.php -h new >> /dev/null 2>&1",
  $config_owner              = 'root',
}
    minute  => $cron_discovery_all_minute,

      fail("Module observium is supported on osfamily Debian. Your osfamily is identified as ${::osfamily}")
    default: {
    name   => $base_path,
    mode    => $rrd_mode,
  $snmp_version              = 'v2c',
      } ~>
    group   => $rrd_group,
  $cron_discovery_new_minute = '*/5',
        ensure  => installed,

  $rrd_group                 = 'root',
    refreshonly => true, 
    validate_hash($users)
  $cron_discovery_all_user   = 'root',
  cron { 'discovery-all':

    mode    => $config_mode,
  file { 'observium_path':
  }
    user    => $cron_poller_user,
  if $users {
  $rrd_mode                  = '0755',
  }
  $users                     = undef,
    content => template('observium/config.php.erb'),

      } else {

    group   => $config_group,
    # require => Package['observium_packages'],ss
class observium (
  $config_mode               = '0755',
  $packages                  = 'USE_DEFAULTS',
  $http_port                 = '80',
    }
  $rrd_path                  = '/opt/observium/rrd',
    ensure => directory,

      package { 'observium_packages':

  $devices                   = undef,
    'Debian': {
    minute  => $cron_poller_minute,
  $poller_threads            = '1',
    path    => $rrd_path,
    command => "${base_path}/poller-wrapper.py ${poller_threads} >> /dev/null 2>&1",
        ensure => present,
      }
  $cron_poller_user          = 'root',
  }
    'RedHat': {
  exec { 'update_db':
      if $packages == 'USE_DEFAULTS' {
    cwd         => $base_path,
      exec { "extract_observium":
  }
  $communities               = ['public'],
  }
  $mysql_host                = undef,
  }
  $config_path               = '/opt/observium/config.php',
        command => "/usr/bin/tar zxvf ${main_dir}/observium-community-latest.tar.gz -C $main_dir",
    minute  => $cron_discovery_new_minute,
  }
# == Class: observium
  $servername                = $::fqdn,
    owner  => 'root',
        $my_packages = $default_packages
  case $::osfamily {
  cron { 'poller':
) {

    ensure  => directory,
  }
  if $devices {
    observium::device { $devices: }
  $cron_discovery_all_hour   = '*/6',
  include observium::apache
  $main_dir                  = '/opt',
    notify  => Exec['update_db'],
  $config_group              = 'root',
    require => File['observium_path'],
    hour    => $cron_discovery_all_hour,
    path        => '/bin:/usr/bin:/usr/local/bin',

# This module manages Observium
    create_resources('observium::user', $users)
  file { 'observium_rrd_base':
        source => "http://www.observium.org/observium-community-latest.tar.gz",
  }
  file { 'observium_config':
#
      file { "$main_dir/observium-community-latest.tar.gz":

  $cron_discovery_all_minute = '33',
  $base_path                 = '/opt/observium',
  }