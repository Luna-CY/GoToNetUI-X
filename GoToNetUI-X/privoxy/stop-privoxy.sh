#!/usr/bin/env sh

launchctl stop xin.luna.privoxy
launchctl unload "$HOME/Library/LaunchAgents/xin.luna.privoxy.plist"
