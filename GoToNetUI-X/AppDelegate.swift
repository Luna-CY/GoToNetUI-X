//
//  AppDelegate.swift
//  GoToNetUI-X
//
//  Created by Luna on 2020/5/9.
//  Copyright © 2020 Luna. All rights reserved.
//

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
        
        self.flushServerConfigList()
        
        let selected = UserDefaults.standard.string(forKey: "selectedServerName")
        if "" == selected {
            self.startServiceItem.action = nil
        }
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
        
        UserDefaults.standard.set(true, forKey: "isStarted")
        
        self.startServiceItem.action = nil
        self.startServiceItem.isHidden = true
        
        self.closeServiceItem.action = #selector(AppDelegate.closeServiceAction)
        self.closeServiceItem.isHidden = false
        
        if let button = self.statusBarItem.button {
            button.image = NSImage(named: "IconOn")
        }
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
        
        UserDefaults.standard.set(false, forKey: "isStarted")
        
        self.closeServiceItem.action = nil
        self.closeServiceItem.isHidden = true
        
        self.startServiceItem.action = #selector(AppDelegate.startServiceAction)
        self.startServiceItem.isHidden = false
        
        if let button = self.statusBarItem.button {
            button.image = NSImage(named: "IconOff")
        }
    }
    
    /**
     切换为pac模式菜单项
     */
    @IBOutlet weak var pacModeItem: NSMenuItem!
    
    /**
     切换为pac模式菜单项动作
     */
    @IBAction func pacModeAction(_ sender: Any) {
        self.globalModeItem.state = .off
        self.manualModeItem.state = .off
        
        self.pacModeItem.state = .on
    }
    
    /**
     切换为全局模式菜单项
     */
    @IBOutlet weak var globalModeItem: NSMenuItem!
    
    /**
     切换为全局模式菜单项动作
     */
    @IBAction func globalModeAction(_ sender: Any) {
        self.pacModeItem.state = .off
        self.manualModeItem.state = .off
        
        self.globalModeItem.state = .on
    }
    
    /**
     切换为手动模式菜单项
     */
    @IBOutlet weak var manualModeItem: NSMenuItem!
    
    /**
     切换为手动模式菜单项动作
     */
    @IBAction func manualModeAction(_ sender: Any) {
        self.pacModeItem.state = .off
        self.globalModeItem.state = .off
        
        self.manualModeItem.state = .on
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
    @IBAction func openLogControl(_ sender: Any) {
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
            "runningMode": "manual",
            "selectedServerName": "",
            "localAddr": "127.0.0.1",
            "localPort": NSNumber(value: 1280 as UInt16),
        ])
    }
    
    /**
     刷新服务器配置列表
     */
    func flushServerConfigList() {
        guard let submenu = self.serverConfigListItem.submenu else { return }

        let beginIndex = submenu.index(of: self.serverConfigListBegin) + 1
        let endIndex = submenu.index(of: self.serverConfigListEnd)
        
        for index in (beginIndex..<endIndex).reversed() {
            submenu.removeItem(at: index)
        }
        
        let selected = UserDefaults.standard.string(forKey: "selectedServerName")
        
        let serverConfigList = ServerConfigManager.default.getServerConfigList()
        for (_, serverConfig) in serverConfigList {
            let item = NSMenuItem()
            item.title = serverConfig.name
            item.state = selected == serverConfig.name ? .on : .off
            item.isEnabled = true
            
            item.action = #selector(AppDelegate.selectServer)
            
            submenu.insertItem(item, at: beginIndex)
        }
    }
    
    /**
     选择服务器配置
     */
    @IBAction func selectServer(_ sender: NSMenuItem) {
        UserDefaults.standard.set(sender.title, forKey: "selectedServerName")
        self.startServiceItem.action = #selector(AppDelegate.startServiceAction)
        
        if !syncCliCmdService(action: "restart") {
            UserDefaults.standard.set(false, forKey: "isStarted")
            
            self.closeServiceItem.isEnabled = false
            self.closeServiceItem.isHidden = true
            
            self.startServiceItem.isEnabled = true
            self.startServiceItem.isHidden = false
            
            if let button = self.statusBarItem.button {
                button.image = NSImage(named: "IconOff")
            }
            
            return
        } else {
            UserDefaults.standard.set(true, forKey: "isStarted")
            
            self.startServiceItem.isEnabled = false
            self.startServiceItem.isHidden = true
            
            self.closeServiceItem.isEnabled = true
            self.closeServiceItem.isHidden = false
            
            if let button = self.statusBarItem.button {
                button.image = NSImage(named: "IconOn")
            }
        }
        
        sender.state = .on
    }
}

