class iptables {

  Firewall {
    before  => Class['iptables::post'],
    require => Class['iptables::pre'],
  }

  class { ['firewall', 'iptables::pre', 'iptables::post']: }

  # Set up forwarding through the VPN tunnel.
  # sudo iptables -t nat -A POSTROUTING -o tun0 -j MASQUERADE
  firewall { '101 SNAT through tun0':
    proto    => 'all',
    chain    => 'POSTROUTING',
    table    => 'nat',
    outiface => 'tun0',
    jump     => 'MASQUERADE',
  }
  # sudo iptables -A FORWARD -i eth0 -o tun0 -j ACCEPT
  -> firewall { '102 forward eth0 through tun0':
    proto    => 'all',
    chain    => 'FORWARD',
    iniface  => 'eth0',
    outiface => 'tun0',
    action   => 'accept'
  }

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
      # Those chains are created by the forwarding rules.
      'PREROUTING:nat:IPv4':  ensure => present;
      'INPUT:nat:IPv4':       ensure => present;
      'POSTROUTING:nat:IPv4': ensure => present;
      'OUTPUT:nat:IPv4':      ensure => present;

    }
  }
}
