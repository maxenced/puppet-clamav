# == Class:clamav::daemon
#
# Setup clamd daemon
#
# === Parameters:
#
#  [*db_dir*]
#   Path to the database directory.
#   WARNING: It must match clamd.conf's directive!
#    Defaults: '/var/lib/clamav'
#
#  [*logfile*]
#   Path to the log file (make sure it has proper permissions)
#    Defaults: '/var/log/clamav/clamd.log'
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
#    Defaults: '/var/run/clamd.pid'
#
#  [*user*]
#    User to run as. Defaults: 'root'
#
#  [*debug*]
#   Enable debug messages in libclamav.
#    Defaults: 'yes'
#
#  [*bytecode*]
#   This option enables downloading of bytecode.cvd, which includes additional
#   detection mechanisms and improvements to the ClamAV engine.
#   Defaults: 'yes'
#
#  [*enable*]
#   Enable daemon. Default: true
#
#  [*scan_mail*]
#   Scan mails. Default: false
#
#  [*scan_archive*]
#   Scan archives. Default: false
#
#  [*log_clean*]
#   Log clean files ? Default: false
#
#  [*archive_block_encrypted*]
#   Consider encrypted archives as virus. Default: false
#
#  [*follow_dir_symlink*]
#   Follow symlink on directory. Default: false
#
#  [*follow_file_symlink*]
#   Follow symlink on files. Default: false
#
#  [*max_dir_recursion*]
#   Max depth to scan.
#
#  [*max_threads*]
#   Max number of scan in parrallel. Default: $::processorcount
#
#  [*self_check_interval*]
#   Check if new version of database has been retrieve every Xs. Default: 3600
#
#  [*scan_pe*]
#   PE stands for Portable Executable - it's an executable file format used in
#   all 32 and 64-bit versions of Windows operating systems. This option allows
#   ClamAV to perform a deeper analysis of executable files and it's also
#   required for decompression of popular executable packers such as UPX.
#   Default: true
#
#  [*keep_tmp*]
#    Keep temporary files. Default: false
#
#  [*cross_fs*]
#   Scan across different FS. Default: false
#
#  [*command*]
#   Path to binary. Default: '/usr/sbin/clamd'
#
#  [*package_name*]
#   Name of package to install to provide clamd. Default: clamav-daemon
#
#  [*exclude_path*]
#   List of path to exclude
#
#===  Authors
#
# Maxence Dunnewind <tech@typhon.com>
#
class clamav::daemon (
  $enable                  = true,
  $package_name            = 'clamav-daemon',
  $scan_mail               = false,
  $scan_archive            = false,
  $archive_block_encrypted = false,
  $max_dir_recursion       = 15,
  $follow_dir_symlink      = false,
  $follow_file_symlink     = false,
  $scan_pe                 = true,
  $max_threads             = $::processorcount,
  $keep_tmp                = false,
  $log_clean               = false,
  $cross_fs                = false,
  $command                 = '/usr/sbin/clamd',
  $db_dir                  = '/var/lib/clamav',
  $logfile                 = '/var/log/clamav/clamd.log',
  $logfile_max_size        = '2M',
  $log_timestamp           = 'yes',
  $verbose                 = 'yes',
  $log_syslog              = 'yes',
  $log_facility            = 'LOG_LOCAL6',
  $log_rotate              = 'yes',
  $pidfile                 = '/var/run/clamd.pid',
  $user                    = 'root',
  $debug                   = 'yes',
  $bytecode                = 'yes',
  $exclude_path            = [],
  $self_check_interval     = 3600
){
  include clamav

  package { $package_name:
    ensure => present
  }

  file { '/etc/clamav/clamd.conf':
    ensure  => present,
    content => template('clamav/clamd.conf.erb'),
    require => Package[$package_name]
  }

  file { '/etc/default/clamav-daemon':
    ensure  => present,
    content => template('clamav/default.erb'),
    require => Package[$package_name]
  }

  service { 'clamav-daemon':
    ensure    => running,
    enable    => true,
    subscribe => [
      File['/etc/clamav/clamd.conf'],
      File['/etc/default/clamav-daemon']
    ]
  }

}
