//
//  utils.swift
//  GoToNetUI-X
//
//  Created by ronghui.huo on 2020/5/9.
//  Copyright © 2020 Luna. All rights reserved.
//

import Foundation

class ProxyConfigUtil : NSObject {
    
    static let `default` = ProxyConfigUtil()
    
    private let cli = SupportDir + "cli-go-to-net"
    
    private let plist = "xin.luna.cli-go-to-net.plist"
    
    private let manager = FileManager.default
    
    private let bundle = Bundle.main
    
    private override init() {
        super.init()
    }
    
    /**
     安装cli-go-to-net
     */
    func install() -> Bool {
        if self.manager.fileExists(atPath: self.cli + "-" + CliVersion) {
            return true
        }
        
        let path = self.bundle.path(forResource: "install-cli-go-to-net.sh", ofType: nil)
        let task = Process.launchedProcess(launchPath: path!, arguments: [CliVersion])
        
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
        if !self.manager.fileExists(atPath: self.cli) {
            return false
        }
        
        let logFilePath = NSHomeDirectory() + "/Library/Logs/xin.luna.cli-go-to-net.log"
        let plistFilepath = LaunchAgentDir + self.plist
        
        if !self.manager.fileExists(atPath: LaunchAgentDir) {
            try! self.manager.createDirectory(atPath: LaunchAgentDir, withIntermediateDirectories: true, attributes: nil)
        }
        
        let selected = UserDefaults.standard.string(forKey: "selectedServerName")!
        let config = ServerConfigManagerUtil.default.getServerConfig(id: selected)
        if nil == config {
            return false
        }
        
        let localAddr = UserDefaults.standard.string(forKey: "socks.listen")
        let localPort = UserDefaults.standard.integer(forKey: "socks.port")
        
        let arguments = [self.cli, "-sh", config!.hostname, "-sp", String(config!.serverPort), "-la", localAddr, "-lp", String(localPort), "-u", config!.username, "-p", config!.password]
        
        let dict: NSMutableDictionary = [
            "Label": "xin.luna.cli-go-to-net",
            "WorkingDirectory": SupportDir,
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
        
        let plistFilepath = LaunchAgentDir + self.plist
        
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
        
        let plistFilepath = LaunchAgentDir + self.plist
        
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
            if "manual" != UserDefaults.standard.string(forKey: "runningMode") && !NetworkConfigUtil.default.set("manual") {
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
            
            if "auto" == UserDefaults.standard.string(forKey: "runningMode") && !NetworkConfigUtil.default.set("auto") {
                return false
            }
            
            if "global" == UserDefaults.standard.string(forKey: "runningMode") && !NetworkConfigUtil.default.set("global") {
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
            
            if "auto" == UserDefaults.standard.string(forKey: "runningMode") && !NetworkConfigUtil.default.set("auto") {
                return false
            }
            
            if "global" == UserDefaults.standard.string(forKey: "runningMode") && !NetworkConfigUtil.default.set("global") {
                return false
            }
            
            break
        default:
            return false
        }
        
        return true
    }
}
