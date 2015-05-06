# == Class: clamav::scan
#
# Setup a scan
#
# === Parameter:
#
# [*action_error*]
#   Shell command to run if an error occurs during scanning. Does nothing by
#   default.
#
# [*action_ok*]
#   Shell command to execute if a scan returns ok. Does nothing by default.
#
# [*action_virus*]
#   Shell command to run if a virus is detected. Does nothing by default.
#
# [*copy*]
#   Copy infected files into DIRECTORY. Directory must be writable
#   for the 'clam' user or unprivileged user running clamscan.
#
# [*enable*]
#   Should this scan be enabled? Defaults to true.
#
# [*exclude*]
#   Regular expression that, when matched, excludes a file from being scanned.
#
# [*exclude_dir*]
#   Regular expression that, when matched, excludes a directory from being
#   scanned.
#
# [*hour*]
#   Hour (in cron format) to run the scan. Defaults to a consistently random
#   hour based on the fqdn of the host. Has no impact if enable=false.
#
# [*include*]
#   Regular expression that, when matched, will include a file to be scanned.
#
# [*include_dir*]
#   Regular expression that, when matched, will include a directory to be
#   scanned.

# [*minute*]
#   Minute (in cron format) to run the scan. Defaults to a consistently random
#   minute based on the fqdn of the host. Has no impact if enable=false.
#
# [*month*]
#   Month (in cron format) to run the scan. Runs every month by default.
#
# [*monthday*]
#   Month day (in cron format) to run the scan. Runs every month day by
#   default.
#
# [*move*]
#   Move infected files into DIRECTORY. Directory must be writable
#   for the 'clam' user or unprivileged user running clamscan.
#
# [*quiet*]
#   Be quiet (only print error messages).
#
# [*multi*]
#   Use multi threading ? Only useful if in daemon mode
#
# [*daemon*]
#   Use clamdscan instead of clamscan. You need to enable clamd with clamav::daemon.
#   Default: false
#
# [*recursive*]
# [*scan*]
# [*scanlog*]
# [*weekday*]
#
define clamav::scan (
  $action_error = '',
  $action_ok    = '',
  $action_virus = '',
  $enable       = true,
  $hour         = fqdn_rand(23,$name),
  $minute       = fqdn_rand(59,$name),
  $month        = undef,
  $monthday     = undef,
  $copy         = false,
  $exclude      = [ ],
  $exclude_dir  = [ ],
  $flags        = '',
  $include      = [ ],
  $include_dir  = [ ],
  $move         = '',
  $quiet        = true,
  $recursive    = false,
  $scan         = [ ],
  $scanlog      = "/var/log/clamav/scan_${title}",
  $weekday      = undef,
  $daemon       = false,
  $multi        = false
) {
  if $move != '' { validate_absolute_path($move) }

  include clamav
  $scancmd = "/etc/clamav/scans/${name}"

  file { $scancmd:
    ensure  => present,
    owner   => $clamav::params::user,
    mode    => '0500',
    content => template('clamav/scan.sh.erb'),
    require => Class['Clamav'],
  }

  # setup our scheduled job to run this scan
  $cron_ensure = $enable ? {
    true    => 'present',
    default => 'absent',
  }
  cron { "clamav-scan-${name}":
    ensure   => $cron_ensure,
    command  => $scancmd,
    hour     => $hour,
    minute   => $minute,
    month    => $month,
    monthday => $monthday,
    weekday  => $weekday,
    require  => File[$scancmd],
  }
}
