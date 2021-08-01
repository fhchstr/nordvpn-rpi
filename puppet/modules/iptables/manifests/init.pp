class iptables {

  Firewall {
    before  => Class['iptables::post'],
    require => Class['iptables::pre'],
  }

  class { ['firewall', 'iptables::pre', 'iptables::post']: }

  # If requested, purge unmanaged firewall rules and chains.
  if lookup('purge_other_iptable_rules') {
    resources {
      'firewall':      purge => true;
      'firewallchain': purge => true;
    }

    # Since internal chains can't (and shouldn't) be deleted, declare them explicitly.
    firewallchain {
      'INPUT:filter:IPv4':   ensure => present;
      'FORWARD:filter:IPv4': ensure => present;
      'OUTPUT:filter:IPv4':  ensure => present;
      'INPUT:filter:IPv6':   ensure => present;
      'FORWARD:filter:IPv6': ensure => present;
      'OUTPUT:filter:IPv6':  ensure => present;
    }
  }
}
