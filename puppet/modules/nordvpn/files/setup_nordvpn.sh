#!/bin/bash
# Download and unpack the OpenVPN configuration files provided by NordVPN.
# This script automates most of the setup procedure documented at
# https://support.nordvpn.com/Connectivity/Linux/1047409422/How-can-I-connect-to-NordVPN-using-Linux-Terminal.htm

if [[ $# != 2 ]]; then
  echo "usage: $0 conf_dir credentials_file"
  exit 1
fi

DST_DIR=$(realpath "$1")
CREDS_PATH=$(realpath "$2")

if [[ ! -d "$DST_DIR" ]]; then
  echo "${DST_DIR}: no such directory."
  exit 1
fi

if [[ ! -f "$CREDS_PATH" ]]; then
  echo "${CREDS_PATH}: no such file."
  exit 1
fi

SRC_URL="https://downloads.nordcdn.com/configs/archives/servers/ovpn.zip"
SRC_FILE=$(basename "$SRC_URL")
CHECKSUM_PATH="${DST_DIR}/${SRC_FILE}.checksum"

# Delete the downloaded file on exit.
trap "rm -f ${DST_DIR}/${SRC_FILE}" EXIT

echo 'Installing dependencies.'
apt -y install ca-certificates openvpn unzip wget

cd "$DST_DIR"
echo 'Downloading OpenVPN configuration files.'
wget "$SRC_URL"
sha256sum --check "$CHECKSUM_PATH"
if [[ $? -eq 0 ]]; then
  echo 'The currently installed OpenVPN configuration files are already at the latest version.'
  exit 0
fi
sha256sum "$SRC_FILE" > "$CHECKSUM_PATH"
unzip "$SRC_FILE"

echo 'Updating the OpenVPN configuration files to use the credentials file.'
for f in $(find "$DST_DIR" -name '*.ovpn'); do
  sed -i "s|auth-user-pass|auth-user-pass ${CREDS_PATH}|" "$f"
done
