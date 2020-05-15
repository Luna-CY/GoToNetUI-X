#!/usr/bin/env sh

app="GoToNetUI-X"
rp="$HOME/Library/Application Support/$app"

mkdir -p "$rp"

cd "$(dirname "${BASH_SOURCE[0]}")"
cp -f ./privoxy "$rp/privoxy"

echo done
