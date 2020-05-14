//
//  utils.swift
//  GoToNetUI-X
//
//  Created by ronghui.huo on 2020/5/9.
//  Copyright © 2020 Luna. All rights reserved.
//

import Foundation

let cliCmdPath = NSHomeDirectory() + SupportDir + "cli-go-to-net"

class ProxyConfigUtil : NSObject {
    
    static let `default` = ProxyConfigUtil()
    
    private let cli = NSHomeDirectory() + SupportDir + "cli-go-to-net"
    
    private let manager = FileManager.default
    
    private let bundle = Bundle.main
    
    private override init() {
        super.init()
    }
    
    /**
     安装cli-go-to-net
     */
    func install() -> Bool {
        if self.manager.fileExists(atPath: self.cli) {
            return true
        }
        
        let path = self.bundle.path(forResource: "install-cli-go-to-net.sh", ofType: nil)
        let task = Process.launchedProcess(launchPath: path!, arguments: [""])
        
        task.waitUntilExit()
        if task.terminationStatus == 0 {
            return true
        } else {
            return false
        }
    }
    
    /**
     生成plist配置
     */
    private func generate() -> Bool {
        if !self.manager.fileExists(atPath: cliCmdPath) {
            return false
        }
        
        let logFilePath = NSHomeDirectory() + "/Library/Logs/cli-go-to-net.log"
        let launchAgentDirPath = NSHomeDirectory() + LaunchAgentDir
        let plistFilepath = launchAgentDirPath + LaunchAgentCliCmdName
        
        if !self.manager.fileExists(atPath: launchAgentDirPath) {
            try! self.manager.createDirectory(atPath: launchAgentDirPath, withIntermediateDirectories: true, attributes: nil)
        }
        
        let selected = UserDefaults.standard.string(forKey: "selectedServerName")!
        let config = ServerConfigManager.default.getServerConfig(id: selected)
        if nil == config {
            return false
        }
        
        let localAddr = UserDefaults.standard.string(forKey: "localAddr")
        let localPort = UserDefaults.standard.integer(forKey: "localPort")
        
        let arguments = [cliCmdPath, "-sh", config!.hostname, "-sp", String(config!.serverPort), "-la", localAddr, "-lp", String(localPort), "-u", config!.username, "-p", config!.password]
        
        let dict: NSMutableDictionary = [
            "Label": "xin.luna.cli-go-to-net",
            "WorkingDirectory": NSHomeDirectory() + SupportDir,
            "StandardOutPath": logFilePath,
            "StandardErrorPath": logFilePath,
            "ProgramArguments": arguments,
        ]
        
        dict.write(toFile: plistFilepath, atomically: true)
        
        return true
    }
    
    /**
     启动服务
     */
    private func start() -> Bool {
        let startShellPath = self.bundle.path(forResource: "start-cli-go-to-net.sh", ofType: nil)
        
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
    
    private func stop() -> Bool {
        let stopShellPath = self.bundle.path(forResource: "stop-cli-go-to-net.sh", ofType: nil)
        
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
    
    func sync(action: String) -> Bool {
        switch action {
        case "stop":
            if "auto" == UserDefaults.standard.string(forKey: "runningMode") && !NetworkConfigUtil.default.setAuto(false) {
                return false
            }
            
            if "global" == UserDefaults.standard.string(forKey: "runningMode") && !NetworkConfigUtil.default.setGlobal(false) {
                return false
            }
            
            if !self.stop() {
                return false
            }
            
            break
        case "start":
            if "" == UserDefaults.standard.string(forKey: "selectedServerName")! {
                _ = self.stop()
                
                return false
            }
            
            if !self.generate() {
                NSLog("生成服务配置失败")
                
                return false
            }
            
            if !self.start() {
                return false
            }
            
            if "auto" == UserDefaults.standard.string(forKey: "runningMode") && !NetworkConfigUtil.default.setAuto(true) {
                return false
            }
            
            if "global" == UserDefaults.standard.string(forKey: "runningMode") && !NetworkConfigUtil.default.setGlobal(true) {
                return false
            }
            
            break
        case "restart":
            if "" == UserDefaults.standard.string(forKey: "selectedServerName")! {
                _ = self.stop()
                
                return false
            }
            
            if !self.generate() {
                NSLog("生成服务配置失败")
                
                return false
            }
            
            if !self.stop() {
                return false
            }
            
            if !self.start() {
                return false
            }
            
            if "auto" == UserDefaults.standard.string(forKey: "runningMode") && !NetworkConfigUtil.default.setAuto(true) {
                return false
            }
            
            if "global" == UserDefaults.standard.string(forKey: "runningMode") && !NetworkConfigUtil.default.setGlobal(true) {
                return false
            }
            
            break
        default:
            return false
        }
        
        return true
    }
}
