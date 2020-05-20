#!/usr/bin/env sh

app="GoToNetUI-X"
rp="$HOME/Library/Application Support/$app"

mkdir -p "$rp"

cd "$(dirname "${BASH_SOURCE[0]}")"
rm -f "$rp/cli-go-to-net"
cp -f ./cli-go-to-net "$rp/cli-go-to-net-$1"
ln -s "$rp/cli-go-to-net-$1" "$rp/cli-go-to-net"

echo done
