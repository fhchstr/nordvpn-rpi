class nordvpn (
  $config_root      = undef,
  $credentials_file = undef
) {

  if $config_root == undef {
    fail('config_root must be set')
  }
  if $credentials_file == undef {
    fail('credentials_file must be set')
  }

  # Disable IPv6, as instructed at https://support.nordvpn.com/Connectivity/Linux/1047409422/How-can-I-connect-to-NordVPN-using-Linux-Terminal.htm
  sysctl {
    default: prefix => '50';
    'net.ipv6.conf.all.disable_ipv6': value => 1;
    'net.ipv6.conf.default.disable_ipv6': value => 1;
    'net.ipv6.conf.lo.disable_ipv6': value => 1;
    # 'net.ipv6.conf.tun0.disable_ipv6': value => 1; TODO: The tun0 interface doesn't exist yet. Puppet fails.
  }
  -> class { 'nordvpn::tools': }
}
