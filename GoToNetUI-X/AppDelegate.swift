//
//  AppDelegate.swift
//  GoToNetUI-X
//
//  Created by Luna on 2020/5/9.
//  Copyright © 2020 Luna. All rights reserved.
//

import Foundation
import Cocoa
import SwiftUI

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
    
    var statusBarItem: NSStatusItem!
    
    @IBOutlet weak var mainMenu: NSMenu!
    
    /**
     Main Func
     */
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        if !self.initTools() {
            self.startServiceItem.isEnabled = false
        }
        self.registerGlobalConfig()
        
        self.statusBarItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.squareLength)
        self.statusBarItem.menu = mainMenu
        
        if let button = self.statusBarItem.button {
            button.image = NSImage(named: "IconOff")
        }
        
        self.pacModeItem.state = "auto" == UserDefaults.standard.string(forKey: "runningMode") ? .on : .off
        self.globalModeItem.state = "global" == UserDefaults.standard.string(forKey: "runningMode") ? .on : .off
        self.manualModeItem.state = "manual" == UserDefaults.standard.string(forKey: "runningMode") ? .on : .off
        
        self.flushServerConfigList()
        
        let selected = UserDefaults.standard.integer(forKey: "selectedServerName")
        if -1 == selected {
            self.startServiceItem.action = nil
        } else if UserDefaults.standard.bool(forKey: "startServiceOnProgram") {
            if !syncCliCmdService(action: "start") {
                NSLog("启动服务失败")
                
                return
            }
            
            self.setStartState()
        }
        
        NotificationCenter.default.addObserver(forName: NotifyServerConfigListChange, object: nil, queue: nil, using: { note in
            self.flushServerConfigList()
        })
    }
    
    /**
     退出应用菜单项动作
     */
    @IBAction func quitAppAction(_ sender: Any) {
        if syncCliCmdService(action: "stop") {
            UserDefaults.standard.set(false, forKey: "isStarted")
            NSApplication.shared.terminate(self)
        }
    }
    
    /**
     启动服务菜单项对象
     */
    @IBOutlet weak var startServiceItem: NSMenuItem!
    
    /**
     启动服务菜单项动作
     */
    @IBAction func startServiceAction(_ sender: Any) {
        if UserDefaults.standard.bool(forKey: "isStarted") {
            return
        }
        
        if !syncCliCmdService(action: "start") {
            NSLog("启动服务失败")
            
            return
        }
        
        self.setStartState()
    }
    
    /**
     关闭服务菜单项对象
     */
    @IBOutlet weak var closeServiceItem: NSMenuItem!
    
    /**
     关闭服务菜单项动作
     */
    @IBAction func closeServiceAction(_ sender: Any) {
        if !UserDefaults.standard.bool(forKey: "isStarted") {
            return
        }
        
        if !syncCliCmdService(action: "stop") {
            NSLog("关闭服务失败")
            
            return
        }
        
        self.setStopState()
    }
    
    /**
     切换为pac模式菜单项
     */
    @IBOutlet weak var pacModeItem: NSMenuItem!
    
    /**
     切换为pac模式菜单项动作
     */
    @IBAction func pacModeAction(_ sender: Any) {
        if UserDefaults.standard.bool(forKey: "isStarted") {
            if !NetworkConfigUtil.default.setAutoProxy(true) {
                return
            }
            
            UserDefaults.standard.set("auto", forKey: "runningMode")
            
            self.globalModeItem.state = .off
            self.manualModeItem.state = .off
            
            self.pacModeItem.state = .on
        } else {
            UserDefaults.standard.set("auto", forKey: "runningMode")
            
            self.globalModeItem.state = .off
            self.manualModeItem.state = .off
            
            self.pacModeItem.state = .on
        }
    }
    
    /**
     切换为全局模式菜单项
     */
    @IBOutlet weak var globalModeItem: NSMenuItem!
    
    /**
     切换为全局模式菜单项动作
     */
    @IBAction func globalModeAction(_ sender: Any) {
        if UserDefaults.standard.bool(forKey: "isStarted") {
            if !NetworkConfigUtil.default.setGlobalProxy(true) {
                return
            }
            
            UserDefaults.standard.set("global", forKey: "runningMode")
            
            self.pacModeItem.state = .off
            self.manualModeItem.state = .off
            
            self.globalModeItem.state = .on
        } else {
            UserDefaults.standard.set("global", forKey: "runningMode")
            
            self.pacModeItem.state = .off
            self.manualModeItem.state = .off
            
            self.globalModeItem.state = .on
        }
    }
    
    /**
     切换为手动模式菜单项
     */
    @IBOutlet weak var manualModeItem: NSMenuItem!
    
    /**
     切换为手动模式菜单项动作
     */
    @IBAction func manualModeAction(_ sender: Any) {
        if UserDefaults.standard.bool(forKey: "isStarted") {
            if !NetworkConfigUtil.default.setManualProxy() {
                return
            }
            
            UserDefaults.standard.set("manual", forKey: "runningMode")
            
            self.pacModeItem.state = .off
            self.globalModeItem.state = .off
            
            self.manualModeItem.state = .on
        } else {
            UserDefaults.standard.set("manual", forKey: "runningMode")
            
            self.pacModeItem.state = .off
            self.globalModeItem.state = .off
            
            self.manualModeItem.state = .on
        }
    }
    
    /**
     服务器列表菜单项
     */
    @IBOutlet weak var serverConfigListItem: NSMenuItem!
    @IBOutlet weak var serverConfigListBegin: NSMenuItem!
    @IBOutlet weak var serverConfigListEnd: NSMenuItem!
    
    /**
     打开日志控制台
     */
    @IBAction func openLogControl(_ sender: NSMenuItem) {
        let ws = NSWorkspace.shared
        if let appUrl = ws.urlForApplication(withBundleIdentifier: "com.apple.Console") {
            try! ws.launchApplication(at: appUrl
                ,options: NSWorkspace.LaunchOptions.default
                ,configuration: [NSWorkspace.LaunchConfigurationKey.arguments: "cli-go-to-net.log"])
        }
    }
    
    /**
     初始化命令行工具
     */
    func initTools() -> Bool {
        if !installCliCmd() {
            return false
        }
        
        return true
    }
    
    /**
     注册全局配置字典
     */
    func registerGlobalConfig() {
        let defaults = UserDefaults.standard
        defaults.register(defaults: [
            "isStarted": false,
            "startServiceOnProgram": false,
            "runningMode": "manual",
            "selectedServerName": NSNumber(value: -1),
            "localAddr": "127.0.0.1",
            "localPort": NSNumber(value: 1280),
            "gfwList": "https://raw.githubusercontent.com/gfwlist/gfwlist/master/gfwlist.txt",
        ])
    }
    
    /**
     刷新服务器配置列表
     */
    func flushServerConfigList() {
        guard let submenu = self.serverConfigListItem.submenu else { return }

        var beginIndex = submenu.index(of: self.serverConfigListBegin) + 1
        let endIndex = submenu.index(of: self.serverConfigListEnd)
        
        for index in (beginIndex..<endIndex).reversed() {
            submenu.removeItem(at: index)
        }
        
        let selected = UserDefaults.standard.integer(forKey: "selectedServerName")
        var isFound = false
        var hasValidConfig = false
        
        let serverConfigList = ServerConfigManager.default.getServerConfigList()
        for (index, serverConfig) in serverConfigList.enumerated() {
            let item = NSMenuItem()
            item.title = serverConfig.name
            
            if selected == index {
                item.state = .on
                isFound = true
            }
            
            if serverConfig.isValid() {
                item.action = #selector(AppDelegate.selectServer)
                hasValidConfig = true
            }
            
            submenu.insertItem(item, at: beginIndex)
            beginIndex += 1
        }
        
        if !isFound && -1 != selected {
            UserDefaults.standard.set(NSNumber(value: -1), forKey: "selectedServerName")
            self.setStopState()
        }
        
        if !hasValidConfig {
            self.startServiceItem.action = nil
        }
    }
    
    /**
     选择服务器配置
     */
    @IBAction func selectServer(_ sender: NSMenuItem) {
        guard let submenu = self.serverConfigListItem.submenu else { return }
        
        UserDefaults.standard.set(submenu.index(of: sender) - 2, forKey: "selectedServerName")
        self.startServiceItem.action = #selector(AppDelegate.startServiceAction)
        
        if !syncCliCmdService(action: "restart") {
            UserDefaults.standard.set(false, forKey: "isStarted")
            self.setStopState()
            
            return
        } else {
            UserDefaults.standard.set(true, forKey: "isStarted")
            
            self.setStartState()
        }
        
        self.flushServerConfigList()
    }
    
    func setStartState() {
        UserDefaults.standard.set(true, forKey: "isStarted")
        
        self.startServiceItem.isEnabled = false
        self.startServiceItem.isHidden = true
        
        self.closeServiceItem.isEnabled = true
        self.closeServiceItem.isHidden = false
        
        if let button = self.statusBarItem.button {
            button.image = NSImage(named: "IconOn")
        }
    }
    
    /**
     设置关闭状态
     */
    func setStopState() {
        UserDefaults.standard.set(false, forKey: "isStarted")
        
        self.closeServiceItem.isEnabled = false
        self.closeServiceItem.isHidden = true
        
        self.startServiceItem.isEnabled = true
        self.startServiceItem.isHidden = false
        
        if let button = self.statusBarItem.button {
            button.image = NSImage(named: "IconOff")
        }
    }
}

