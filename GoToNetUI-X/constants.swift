//
//  constants.swift
//  GoToNetUI-X
//
//  Created by Luna on 2020/5/9.
//  Copyright © 2020 Luna. All rights reserved.
//

import Foundation

let AppName = "GoToNetUI-X"
let SupportDir = NSHomeDirectory() + "/Library/Application Support/" + AppName + "/"
let UserConfigDir = NSHomeDirectory() + "/.config/" + AppName + "/"
let LaunchAgentDir = NSHomeDirectory() + "/Library/LaunchAgents/"

let NotifyPreferencesChange = Notification.Name("NotifyPreferencesChange")
let NotifyServerConfigListChange = Notification.Name("NotifyServerConfigListChange")
let NotifyPACRuleChange = Notification.Name("NotifyPACRuleChange")
let NotifyPACUpdate = Notification.Name("NotifyPACUpdate")

let AppVersion = "v1.0.0"
let CliVersion = "v1.0.0"
