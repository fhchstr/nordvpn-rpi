$config_root = '/etc/nordvpn'
$credentials_file = "${config_root}/credentials.txt"

$username = lookup('nordvpn_username')
$password = lookup('nordvpn_password')

file {
  $config_root:
    ensure => directory,
    mode   => '0750',
    owner  => 'root',
    group  => 'root',;

  $credentials_file:
    ensure  => file,
    mode    => '0400',
    owner   => 'root',
    group   => 'root',
    content => "${username}\n${password}\n",;
}

-> class { '::nordvpn':
  config_root      => $config_root,
  credentials_file => $credentials_file,
}
-> sysctl { 'net.ipv4.ip_forward':
  prefix => '90',
  value  => 1,
}
-> class { '::iptables': }
