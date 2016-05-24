# Internal: Install logrotate and configure it to read from /etc/logrotate.d
#
# Examples
#
#   include logrotate
class logrotate (
  $logrotate_config_template = undef,
) {
  package { 'logrotate':
    ensure => latest,
  }

  File {
    owner   => 'root',
    group   => 'root',
    require => Package['logrotate'],
  }

  if $::facts['lsbdistcodename'] == trusty {
    $logrotate_conf = 'puppet:///modules/logrotate/etc/logrotate_trusty.conf'
  } elsif $::facts['osfamily'] == 'RedHat' {
    $logrotate_conf = 'puppet:///modules/logrotate/etc/logrotate_redhat.conf'
  } else {
    $logrotate_conf = 'puppet:///modules/logrotate/etc/logrotate.conf'
  }
  $_logrotate_conf = pick($logrotate_config_template, $logrotate_conf)
  file {
    '/etc/logrotate.conf':
      ensure  => file,
      mode    => '0444',
      source  => $_logrotate_conf;
    '/etc/logrotate.d':
      ensure  => directory,
      mode    => '0755';
    '/etc/cron.daily/logrotate':
      ensure  => file,
      mode    => '0555',
      source  => 'puppet:///modules/logrotate/etc/cron.daily/logrotate';
  }

  case $::osfamily {
    'Debian': {
      include logrotate::defaults::debian
    }
    'RedHat': {
      include logrotate::defaults::redhat
    }
    'SuSE': {
      include logrotate::defaults::suse
    }
    default: { }
  }
}
