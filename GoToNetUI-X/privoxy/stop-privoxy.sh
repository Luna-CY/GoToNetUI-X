#!/usr/bin/env sh

launchctl stop xin.luna.privoxy.plist
launchctl unload "$HOME/Library/LaunchAgents/xin.luna.privoxy.plist"
