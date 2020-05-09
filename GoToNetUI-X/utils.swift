//
//  utils.swift
//  GoToNetUI-X
//
//  Created by ronghui.huo on 2020/5/9.
//  Copyright © 2020 Luna. All rights reserved.
//

import Foundation

func installCliCmd() {
    let path = NSHomeDirectory() + SupportDir + "cli-go-to-net"
    
    let manager = FileManager.default
    if manager.fileExists(atPath: path) {
        return
    }
    
    let bundle = Bundle.main
    let sh = bundle.path(forResource: "install-cli-go-to-net.sh", ofType: nil)
    let task = Process.launchedProcess(launchPath: sh!, arguments: [""])
    task.waitUntilExit()
    if task.terminationStatus == 0 {
        NSLog("Install ss-local succeeded.")
    } else {
        NSLog("Install ss-local failed.")
    }
}
