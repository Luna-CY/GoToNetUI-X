//
//  PrivoxyConfigUtil.swift
//  GoToNetUI-X
//
//  Created by ronghui.huo on 2020/5/15.
//  Copyright © 2020 Luna. All rights reserved.
//

import Foundation

class PrivoxyConfigUtil : NSObject {
    
    static let `default` = PrivoxyConfigUtil()
    
    private let bundle = Bundle.main
    
    private let manager = FileManager.default
    
    private let defaults = UserDefaults.standard
    
    private let cli = SupportDir + "privoxy"
    
    private let plist = "xin.luna.privoxy.plist"
    
    private var isStarted = false
    
    private override init() {
        super.init()
    }
    
    /**
     安装privoxy命令
     */
    func install() -> Bool {
        if self.manager.fileExists(atPath: self.cli) {
            return true
        }
        
        let path = self.bundle.path(forResource: "install-privoxy.sh", ofType: nil)
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
        if !self.manager.fileExists(atPath: self.cli) {
            return false
        }
        
        let logFilePath = NSHomeDirectory() + "/Library/Logs/xin.lua.privoxy.log"
        let plistFilepath = LaunchAgentDir + self.plist
        
        if !self.manager.fileExists(atPath: LaunchAgentDir) {
            try! self.manager.createDirectory(atPath: LaunchAgentDir, withIntermediateDirectories: true, attributes: nil)
        }
        
        let arguments = [self.cli, "--no-daemon", "privoxy.config"]
        
        let dict: NSMutableDictionary = [
            "Label": "xin.luna.privoxy",
            "WorkingDirectory": SupportDir,
            "StandardOutPath": logFilePath,
            "StandardErrorPath": logFilePath,
            "ProgramArguments": arguments,
        ]
        
        dict.write(toFile: plistFilepath, atomically: true)
        
        let templatePath = self.bundle.path(forResource: "privoxy.template.config", ofType: nil)
        
        // Read template file
        var template = try! String(contentsOfFile: templatePath!, encoding: .utf8)
        
        template = template.replacingOccurrences(of: "{http}", with: self.defaults.string(forKey: "privoxy.listen")! + ":" + String(self.defaults.integer(forKey: "privoxy.port")))
        template = template.replacingOccurrences(of: "{socks5}", with: defaults.string(forKey: "socks.listen")! + ":" + String(defaults.integer(forKey: "socks.port")))
        
        // Write to file
        let data = template.data(using: .utf8)
        let filepath = SupportDir + "privoxy.config"
        
        try! data?.write(to: URL(fileURLWithPath: filepath), options: .atomic)
        
        return true
    }
    
    /**
     启动服务
     */
    private func start() {
        if !self.generate() {
            NSLog("生成privoxy配置失败")
            
            return
        }
        
        let startShellPath = self.bundle.path(forResource: "start-privoxy.sh", ofType: nil)
        
        let task = Process.launchedProcess(launchPath: startShellPath!, arguments: [LaunchAgentDir + self.plist])
        task.waitUntilExit()
        if task.terminationStatus == 0 {
            self.isStarted = true
            NSLog("启动privoxy服务成功")
        } else {
            NSLog("启动privoxy服务失败")
        }
    }
    
    /**
     关闭服务
     */
    private func stop() {
        let stopShellPath = self.bundle.path(forResource: "stop-privoxy.sh", ofType: nil)
        
        let task = Process.launchedProcess(launchPath: stopShellPath!, arguments: [LaunchAgentDir + self.plist])
        task.waitUntilExit()
        if task.terminationStatus == 0 {
            self.isStarted = false
            NSLog("关闭privoxy服务成功")
        } else {
            NSLog("关闭privoxy服务失败")
        }
    }
    
    /**
     同步服务状态
     */
    public func sync() {
        if !UserDefaults.standard.bool(forKey: "isStarted") && self.isStarted {
            self.stop()
        }
        
        if UserDefaults.standard.bool(forKey: "isStarted") && !self.isStarted {
            self.start()
        }
        
        if UserDefaults.standard.bool(forKey: "isStarted") && self.isStarted {
            self.stop()
            self.start()
        }
    }
}
