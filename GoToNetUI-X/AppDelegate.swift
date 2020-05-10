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
        
        // Create the status item
        self.statusBarItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.squareLength)
        self.statusBarItem.menu = mainMenu
        
        if let button = self.statusBarItem.button {
            button.image = NSImage(named: "IconOff")
        }
    }
    
    /**
     退出应用菜单项动作
     */
    @IBAction func quitAppAction(_ sender: Any) {
        NSApplication.shared.terminate(self)
    }
    
    /**
     启动服务菜单项对象
     */
    @IBOutlet weak var startServiceItem: NSMenuItem!
    
    /**
     启动服务菜单项动作
     */
    @IBAction func startServiceAction(_ sender: Any) {
        if !syncCliCmdService() {
            NSLog("启动服务失败")
            
            return
        }
        
        self.startServiceItem.isEnabled = false
        self.startServiceItem.isHidden = true
        
        self.closeServiceItem.isEnabled = true
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
        self.closeServiceItem.isEnabled = false
        self.closeServiceItem.isHidden = true
        
        self.startServiceItem.isEnabled = true
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
            "runningMode": "pac",
            "selectedServerId": "",
            "localSocketPort": NSNumber(value: 1280 as UInt16)
        ])
    }
}

