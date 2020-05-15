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
let UserConfigDir = NSHomeDirectory() + "/.config/" + AppName + "/"

let LaunchAgentDir = "/Library/LaunchAgents/"
let LaunchAgentCliCmdName = "xin.luna.cli-go-to-net.plist"
let ServerConfigFileName = "server-config.json"
let GFWListFileName = "gfwlist.txt"
let UserRulesFileName = "user-rules.txt"
let PACFileName = "proxy.pac"

let NotifyPreferencesChange = Notification.Name("NotifyPreferencesChange")

let NotifyServerConfigListChange = Notification.Name("NotifyServerConfigListChange")

let NotifyPACRuleChange = Notification.Name("NotifyPACRuleChange")
let NotifyPACUpdate = Notification.Name("NotifyPACUpdate")
