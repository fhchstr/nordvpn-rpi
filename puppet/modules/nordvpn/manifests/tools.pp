class nordvpn::tools {

  $tools_root = '/opt/nordvpn-rpi'

  file {
    $tools_root:
      ensure => directory,
      mode   => '0750',
      owner  => 'root',
      group  => 'root',;

    "${tools_root}/setup_nordvpn.sh":
      ensure => file,
      mode   => '0550',
      owner  => 'root',
      group  => 'root',
      content => file('nordvpn/setup_nordvpn.sh'),;
  }
  -> exec { 'Setup OpenVPN with NordVPN config':
    command => "${tools_root}/setup_nordvpn.sh ${::nordvpn::config_root} ${::nordvpn::credentials_file}",
    require => File["${tools_root}/setup_nordvpn.sh"],
  }

  cron { 'Weekly NordVPN config update':
    hour    => 3,
    minute  => 10,
    weekday => 1,  # Tuesday
    user    => 'root',
    command => "${tools_root}/setup_nordvpn.sh ${::nordvpn::config_root} ${::nordvpn::credentials_file}",
  }
}
