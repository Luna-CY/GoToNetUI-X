//
//  utils.swift
//  GoToNetUI-X
//
//  Created by ronghui.huo on 2020/5/9.
//  Copyright © 2020 Luna. All rights reserved.
//

import Foundation

let cliCmdPath = NSHomeDirectory() + SupportDir + "cli-go-to-net"

/**
 计算文件签名
 */
func getFileSHA1Sum(_ filepath: String) -> String {
    return ""
}

/**
 安装cli-go-to-net工具
 */
func installCliCmd() -> Bool {
    let manager = FileManager.default
    if manager.fileExists(atPath: cliCmdPath) {
        return true
    }
    
    let bundle = Bundle.main
    let sh = bundle.path(forResource: "install-cli-go-to-net.sh", ofType: nil)
    let task = Process.launchedProcess(launchPath: sh!, arguments: [""])
    task.waitUntilExit()
    if task.terminationStatus == 0 {
        NSLog("Install ss-local succeeded.")
        
        return true
    } else {
        NSLog("Install ss-local failed.")
        
        return false
    }
}

/**
 生成plist文件
 */
func generateCliCmdPList() -> Bool {
    let manager = FileManager.default
    if !manager.fileExists(atPath: cliCmdPath) {
        return false
    }
    
    let logFilePath = NSHomeDirectory() + "/Library/Logs/cli-go-to-net.log"
    let launchAgentDirPath = NSHomeDirectory() + LaunchAgentDir
    let plistFilepath = launchAgentDirPath + LaunchAgentCliCmdName
    
    if !manager.fileExists(atPath: launchAgentDirPath) {
        try! manager.createDirectory(atPath: launchAgentDirPath, withIntermediateDirectories: true, attributes: nil)
    }
    
    let oldSha1Sum = getFileSHA1Sum(plistFilepath)
    
    let arguments = [cliCmdPath, "-sh", "tsp2.luna.xin", "-sp", "443", "-la", "127.0.0.1", "-lp", "1280", "-u", "luna", "-p", "luna-ss-pass"]
    
    let dict: NSMutableDictionary = [
        "Label": "xin.luna.cli-go-to-net",
        "WorkingDirectory": NSHomeDirectory() + SupportDir,
        "StandardOutPath": logFilePath,
        "StandardErrorPath": logFilePath,
        "ProgramArguments": arguments,
    ]
    dict.write(toFile: plistFilepath, atomically: true)
    if oldSha1Sum != getFileSHA1Sum(plistFilepath) {
        NSLog("生成新的PList文件")
    }
    
    return true
}

/**
 启动cli-go-to-net服务
 */
func startCliCmdService() -> Bool {
    let bundle = Bundle.main
    let startShellPath = bundle.path(forResource: "start-cli-go-to-net.sh", ofType: nil)
    
    let launchAgentDirPath = NSHomeDirectory() + LaunchAgentDir
    let plistFilepath = launchAgentDirPath + LaunchAgentCliCmdName
    
    let task = Process.launchedProcess(launchPath: startShellPath!, arguments: [plistFilepath])
    task.waitUntilExit()
    if task.terminationStatus == 0 {
        NSLog("启动cli-go-to-net服务成功")
        
        return true
    } else {
        NSLog("启动cli-go-to-net服务失败")
        
        return false
    }
}

/**
 关闭cli-go-to-net服务
 */
func stopCliCmdService() -> Bool {
    let bundle = Bundle.main
    let stopShellPath = bundle.path(forResource: "stop-cli-go-to-net.sh", ofType: nil)
    
    let launchAgentDirPath = NSHomeDirectory() + LaunchAgentDir
    let plistFilepath = launchAgentDirPath + LaunchAgentCliCmdName
    
    let task = Process.launchedProcess(launchPath: stopShellPath!, arguments: [plistFilepath])
    task.waitUntilExit()
    if task.terminationStatus == 0 {
        NSLog("关闭cli-go-to-net服务成功")
        
        return true
    } else {
        NSLog("关闭cli-go-to-net服务失败")
        
        return false
    }
}

/**
 同步cli-go-to-net服务
 */
func syncCliCmdService(action: String) -> Bool {
    if !generateCliCmdPList() {
        NSLog("生成服务配置失败")
        
        return false
    }
    
    switch action {
    case "start":
        if !startCliCmdService() {
            return false
        }
        
        break
    case "stop":
        if !stopCliCmdService() {
            return false
        }
        
        break
    case "restart":
        if !stopCliCmdService() {
            return false
        }
        
        if !startCliCmdService() {
            return false
        }
        
        break
    default:
        return false
    }
    
    return true
}
