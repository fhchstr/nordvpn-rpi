# nordvpn-rpi

`nordvpn-rpi` sets up a Raspberry Pi as a VPN gateway using NordVPN servers. A NordVPN subscription is required. Go to https://nordvpn.com to create an account. The setup has been tested on a Raspberry Pi 3 Model B with 16 GB of storage. `nordvpn-rpi` uses [puppet](https://puppet.com) to configure the Raspberry Pi. Puppet is an open-source tool to automate the configuration of servers.

To set up your Raspberry Pi using `nordvpn-rpi`, clone this repository on your Raspberry Pi, enter your NordVPN credentials in `config.yaml` and execute `setup.sh` as root. The installation takes a few minutes to complete.

```
$ git clone https://github.com/fhchstr/nordvpn-rpi
$ vim nordvpn-rpi/config.yaml
$ sudo nordvpn-rpi/setup.sh
```

`nordvpn-rpi` assumes that it is running on a fresh installation of Raspberry Pi OS. It installs and configure the items listed below. If you already have custom configurations for any of the following items, running `setup.sh` might break them.

Installed packages:

* ca-certificates
* openvpn
* puppet
* unzip
* wget

System configuration

* Disable IPv6

## Features

The implementation isn't finished yet. Here's the list of implemented features:

* Installation of the OpenVPN client.
* Installation of the OpenVPN configuration files provided by NordVPN.

Here's the list of not yet implemented features:

* Web interface to pick the VPN server to connect to
* Recursive DNS resolver
* Pi-Hole
* Configuration of packet forwarding
