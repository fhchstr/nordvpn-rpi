class iptables {

  Firewall {
    before  => Class['iptables::post'],
    require => Class['iptables::pre'],
  }

  class { ['firewall', 'iptables::pre', 'iptables::post']: }

  # Purge unmanaged firewall rules and chains.
  resources {
    'firewall':      purge => true;
    'firewallchain': purge => true;
  }

  # Since internal chains can't be (and shouldn't be) deleted, declare them explicitly.
  firewallchain {
    'INPUT:filter:IPv4':   ensure => present;
    'FORWARD:filter:IPv4': ensure => present;
    'OUTPUT:filter:IPv4':  ensure => present;
    'INPUT:filter:IPv6':   ensure => present;
    'FORWARD:filter:IPv6': ensure => present;
    'OUTPUT:filter:IPv6':  ensure => present;
  }
}
