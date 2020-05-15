#!/usr/bin/env sh

chmod 644 "$HOME/Library/LaunchAgents/xin.luna.privoxy.plist"
launchctl load -wF "$HOME/Library/LaunchAgents/xin.luna.privoxy.plist"
launchctl start xin.luna.privoxy
