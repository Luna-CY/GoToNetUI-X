#!/usr/bin/env sh

app="GoToNetUI-X"
rp="/Library/Application Support/$app"

sudo mkdir -p "$rp"

cd "$(dirname "${BASH_SOURCE[0]}")"
sudo cp -f ./network-helper "$rp/network-helper"
sudo chown root:admin "$rp/network-helper"
sudo chmod a+rx "$rp/network-helper"
sudo chmod +s "$rp/network-helper"

echo done
