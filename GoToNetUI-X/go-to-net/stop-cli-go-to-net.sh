#!/bin/bash

launchctl stop xin.luna.cli-go-to-net
launchctl unload "$1"
