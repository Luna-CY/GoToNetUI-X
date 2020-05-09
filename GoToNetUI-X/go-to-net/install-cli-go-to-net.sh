#!/usr/bin/env sh

app="GoToNetUI-X"
rp="$HOME/Library/Application Support/$app"

mkdir -p "$rp"

cd "$(dirname "${BASH_SOURCE[0]}")"
cp -f ./cli-go-to-net "$rp/cli-go-to-net"

echo done
