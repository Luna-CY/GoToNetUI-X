//
//  constants.swift
//  GoToNetUI-X
//
//  Created by Luna on 2020/5/9.
//  Copyright © 2020 Luna. All rights reserved.
//

import Foundation

let AppName = "GoToNetUI-X"
let SupportDir = "/Library/Application Support/" + AppName + "/"
let UserConfigDir = "/.config/" + AppName + "/"

let LaunchAgentDir = "/Library/LaunchAgents/"
let LaunchAgentCliCmdName = "xin.luna.cli-go-to-net.plist"
let ServerConfigFileName = "server-config.json"

let NotifyServerConfigListChange = Notification.Name(rawValue: "NotifyServerConfigListChange")
