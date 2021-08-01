#!/bin/bash
#
# Entry point to setup everything. The script is idempotent; it can be executed
# multiple times without negative impact.

SCRIPT_PATH="$(cd -- "$(dirname "$0")" > /dev/null 2>&1; pwd -P)"

if [[ $(id -u) -ne 0 ]]; then
  echo "$0 must be run as root. Try running it again using sudo."
  exit 1
fi

if [[ $(grep -c 'CHANGEME' "${SCRIPT_PATH}/config.yaml") -ne 0 ]]; then
  echo "You must update ${SCRIPT_PATH}/config.yaml before running $0"
  exit 1
fi

main() {
    setup_puppet
    apply_puppet
}

setup_puppet() {
    echo 'Installing puppet...'
    apt -y install puppet

    echo 'Installing puppet modules...'
    cd "${SCRIPT_PATH}/puppet/modules"
    git clone https://github.com/thias/puppet-sysctl
    mv puppet-sysctl sysctl
}

apply_puppet() {
    echo "Setting up everything..."
    puppet apply \
      --modulepath "${SCRIPT_PATH}/puppet/modules" \
      --hiera_config "${SCRIPT_PATH}/puppet/hiera.yaml" \
      "${SCRIPT_PATH}/puppet/setup.pp"
}

main
