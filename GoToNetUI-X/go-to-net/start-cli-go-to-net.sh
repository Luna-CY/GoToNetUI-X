#!/bin/bash

chmod 644 "$1"
launchctl load -wF "$1"
launchctl start xin.luna.cli-go-to-net
