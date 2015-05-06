# == Class: clamav::freshclam
#
# Configure freshclam to update clamav virus definitions
#
# === Parameters:
#
#  [*db_dir*]
#   Path to the database directory.
#   WARNING: It must match clamd.conf's directive!
#    Defaults: '/var/lib/clamav'
#
#  [*update_logfile*]
#   Path to the log file (make sure it has proper permissions)
#    Defaults: '/var/log/clamav/freshclam.log'
#
#  [*logfile_max_size*]
#   Maximum size of the log file.
#   Value of 0 disables the limit.
#   You may use 'M' or 'm' for megabytes (1M = 1m = 1048576 bytes)
#   and 'K' or 'k' for kilobytes (1K = 1k = 1024 bytes).
#   in bytes just don't use modifiers. If LogFileMaxSize is enabled,
#   log rotation (the LogRotate option) will always be enabled.
#    Defaults: '2M'
#
#  [*log_timestamp*]
#   Log time with each message.
#    Defaults: 'yes'
#
#  [*verbose*]
#   Enable verbose logging.
#    Defaults: 'yes'
#
#  [*log_syslog*]
#   Use system logger (can work together with UpdateLogFile).
#    Defaults: 'yes'
#
#  [*log_facility*]
#   Specify the type of syslog messages - please refer to 'man syslog'
#   for facility names.
#    Defaults: 'LOG_LOCAL6'
#
#  [*log_rotate*]
#   Enable log rotation. Always enabled when LogFileMaxSize is enabled.
#    Defaults: 'yes'
#
#  [*pidfile*]
#   This option allows you to save the process identifier of the daemon
#    Defaults: '/var/run/freshclam.pid'
#
#  [*db_user*]
#   By default when started freshclam drops privileges and switches to the
#   "clamav" user. This directive allows you to change the database owner.
#    Defaults: 'clamav'
#
#  [*dns_db_info*]
#   Use DNS to verify virus database version. Freshclam uses DNS TXT records
#   to verify database and software versions. With this directive you can change
#   the database verification domain.
#   WARNING: Do not touch it unless you're configuring freshclam to use your
#   own database verification domain.
#    Defaults: 'current.cvd.clamav.net'
#
#  [*db_mirror*]
#   See http://www.iana.org/cctld/cctld-whois.htm for the full list.
#   You can use db.XY.ipv6.clamav.net for IPv6 connections.
#    Defaults: 'db.fr.clamav.net'
#
#  [*max_update_attempts*]
#   How many attempts to make before giving up, per mirror.
#    Defaults: 5
#
#  [*scripted_updates*]
#   With this option you can control scripted updates. It's highly recommended
#   to keep it enabled.
#    Defaults: 'yes'
#
#  [*compress_local_db*]
#   By default freshclam will keep the local databases (.cld) uncompressed to
#   make their handling faster. With this option you can enable the compression;
#   the change will take effect with the next database update.
#    Defaults: 'no'
#
#  [*db_custom_url*]
#   With this option you can provide custom sources (http:// or file://) for
#   database files. This option can be used multiple times.
#    Defaults: []
#
#  [*private_mirrors*]
#   This option allows you to easily point freshclam to private mirrors.
#   If PrivateMirror is set, freshclam does not attempt to use DNS
#   to determine whether its databases are out-of-date, instead it will
#   use the If-Modified-Since request or directly check the headers of the
#   remote database files. For each database, freshclam first attempts
#   to download the CLD file. If that fails, it tries to download the
#   CVD file. This option overrides DatabaseMirror, DNSDatabaseInfo
#   and ScriptedUpdates.
#    Defaults: []
#
#  [*check_db_state_freq*]
#   Number of database checks per day.
#    Defaults: 12
#
#  [*proxy_server*]
#   If http proxy server is needed, the proxy's server name.
#    Defaults: ''
#
#  [*proxy_port*]
#   If http proxy server is needed, the proxy's port.
#    Defaults: ''
#
#  [*proxy_username*]
#   If http proxy server is needed, the proxy's username.
#    Defaults: ''
#
#  [*proxy_password*]
#   If http proxy server is needed, the proxy's password.
#    Defaults: ''
#
#  [*user_agent*]
#   If your servers are behind a firewall/proxy which applies User-Agent
#   filtering you can use this option to force the use of a different
#   User-Agent header.
#   Default: clamav/version_number
#    Defaults: ''
#
#  [*local_ip*]
#   Use aaa.bbb.ccc.ddd as client address for downloading databases. Useful for
#   multi-homed systems.
#    Defaults: '', which use default system routing.
#
#  [*debug*]
#   Enable debug messages in libclamav.
#    Defaults: 'yes'
#
#  [*connect_timeout*]
#   Timeout in seconds when connecting to database server.
#    Defaults: 60
#
#  [*receive_timeout*]
#   Timeout in seconds when reading from database server.
#    Defaults: 60
#
#  [*test_new_db*]
#   With this option enabled, freshclam will attempt to load new
#   databases into memory to make sure they are properly handled
#   by libclamav before replacing the old ones.
#    Defaults: 'yes'
#
#  [*bytecode*]
#   This option enables downloading of bytecode.cvd, which includes additional
#   detection mechanisms and improvements to the ClamAV engine.
#   Defaults: 'yes'
#
#  [*extra_db*]
#   Download an additional 3rd party signature database distributed through
#   the ClamAV mirrors. Here you can find a list of available databases:
#   http://www.clamav.net/download/cvd/3rdparty
#    Defaults: []
#
#  [*enable*]
#    Enable service
#
#  [*minute*]
#    Minute of cron, default fqdn_rand(59).
#
#  [*hour*]
#    Hour of cron, default fqdn_rand(23)
#
#  [*command*]
#    Command to run. Default: '/usr/bin/freshclam'
#
class clamav::freshclam (
  $enable              = true,
  $minute              = fqdn_rand(59),
  $hour                = fqdn_rand(23),
  $command             = '/usr/bin/freshclam',
  $db_dir              = '/var/lib/clamav',
  $update_logfile      = '/var/log/clamav/freshclam.log',
  $logfile_max_size    = '2M',
  $log_timestamp       = 'yes',
  $verbose             = 'yes',
  $log_syslog          = 'yes',
  $log_facility        = 'LOG_LOCAL6',
  $log_rotate          = 'yes',
  $pidfile             = '/var/run/freshclam.pid',
  $db_user             = 'clamav',
  $dns_db_info         = 'current.cvd.clamav.net',
  $db_mirror           = 'db.fr.clamav.net',
  $max_update_attempts = 5,
  $scripted_updates    = 'yes',
  $compress_local_db   = 'no',
  $db_custom_url       = [],
  $private_mirrors     = [],
  $check_db_state_freq = 12,
  $proxy_server        = '',
  $proxy_port          = '',
  $proxy_username      = '',
  $proxy_password      = '',
  $user_agent          = '',
  $local_ip            = '',
  $debug               = 'yes',
  $connect_timeout     = 60,
  $receive_timeout     = 60,
  $test_new_db         = 'yes',
  $bytecode            = 'yes',
  $extra_db            = []
) {
  include clamav::params

  file { '/etc/clamav/freshclam.conf':
    ensure  => present,
    owner   => $clamav::params::user,
    mode    => '0400',
    content => template('clamav/freshclam.conf.erb'),
  }

  $cron_ensure = $enable ? {
    true    => 'present',
    default => 'absent',
  }
  cron { 'clamav-freshclam':
    ensure  => $cron_ensure,
    command => $command,
    minute  => $minute,
    hour    => $hour,
    require => File['/etc/clamav/freshclam.conf'],
  }
}
