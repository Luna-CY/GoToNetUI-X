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
class AppDelegate: NSObject, NSApplicationDelegate, NSUserNotificationCenterDelegate {
    
    var statusBarItem: NSStatusItem!
    
    @IBOutlet weak var mainMenu: NSMenu!
    
    /**
     Main Func
     */
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        NSUserNotificationCenter.default.delegate = self
        
        self.registerGlobalConfig()
        self.installTools()
        
        self.statusBarItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.squareLength)
        self.statusBarItem.menu = mainMenu
        
        if let button = self.statusBarItem.button {
            button.image = NSImage(named: "IconOff")
        }
        
        self.pacModeItem.state = "auto" == UserDefaults.standard.string(forKey: "runningMode") ? .on : .off
        self.globalModeItem.state = "global" == UserDefaults.standard.string(forKey: "runningMode") ? .on : .off
        self.manualModeItem.state = "manual" == UserDefaults.standard.string(forKey: "runningMode") ? .on : .off
        
        self.flushServerConfigList()
        
        if 0 == ServerConfigManagerUtil.default.getServerConfigList().count {
            self.startServiceItem.action = nil
            UserDefaults.standard.set("", forKey: "selectedServerName")
        } else if "" == UserDefaults.standard.string(forKey: "selectedServerName")! {
            self.startServiceItem.action = nil
        } else if UserDefaults.standard.bool(forKey: "startServiceOnProgram") {
            if !ProxyConfigUtil.default.sync(action: "start") {
                NSLog("启动服务失败")
                
                return
            }
            
            self.setStartState()
            
            WebServerUtil.default.sync()
            if UserDefaults.standard.bool(forKey: "privoxy.enable") {
                PrivoxyConfigUtil.default.sync()
            }
        }
        
        self.registerObserver()
    }
    
    /**
     退出应用菜单项动作
     */
    @IBAction func quitAppAction(_ sender: Any) {
        if UserDefaults.standard.bool(forKey: "isStarted") {
            if ProxyConfigUtil.default.sync(action: "stop") {
                UserDefaults.standard.set(false, forKey: "isStarted")
            }
            
            WebServerUtil.default.sync()
            if UserDefaults.standard.bool(forKey: "privoxy.enable") {
                PrivoxyConfigUtil.default.sync()
            }
        }
        
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
        if !ProxyConfigUtil.default.sync(action: "start") {
            NSLog("启动服务失败")
            
            return
        }
        
        self.setStartState()
        
        WebServerUtil.default.sync()
        if UserDefaults.standard.bool(forKey: "privoxy.enable") {
            PrivoxyConfigUtil.default.sync()
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
        if !ProxyConfigUtil.default.sync(action: "stop") {
            NSLog("关闭服务失败")
            
            return
        }
        
        self.setStopState()
        
        WebServerUtil.default.sync()
        if UserDefaults.standard.bool(forKey: "privoxy.enable") {
            PrivoxyConfigUtil.default.sync()
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
        if UserDefaults.standard.bool(forKey: "isStarted") {
            if !NetworkConfigUtil.default.set("auto") {
                return
            }
            
            UserDefaults.standard.set("auto", forKey: "runningMode")
            WebServerUtil.default.sync()
            
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
            if !NetworkConfigUtil.default.set("global") {
                NSLog("切换全局代理模式失败")
                
                return
            }
            
            UserDefaults.standard.set("global", forKey: "runningMode")
            WebServerUtil.default.sync()
            
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
            if !NetworkConfigUtil.default.set("manual") {
                return
            }
            
            UserDefaults.standard.set("manual", forKey: "runningMode")
            WebServerUtil.default.sync()
            
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
     打开服务器配置编辑窗口
     */
    @IBAction func openServerEditor(_ sender: NSMenuItem) {
        WindowControllerUtil.default.openServerEditorWindow(self)
    }
    
    /**
     打开偏好设置面板
     */
    @IBAction func openPreferences(_ sender: NSMenuItem) {
        WindowControllerUtil.default.openPreferencesWindow(self)
    }
    
    @IBOutlet weak var updatePACMenuItem: NSMenuItem!
    
    /**
     触发PAC规则更新
     */
    @IBAction func updatePAC(_ sender: NSMenuItem) {
        sender.action = nil
        sender.title = "更新PAC规则列表中..."
        
        ProxyAutoConfigUtil.default.sync(true)
    }
    
    /**
     异步同步pac更新状态
     */
    private func updatePACStatus() {
        self.updatePACMenuItem.title = "更新PAC规则"
        self.updatePACMenuItem.action = #selector(AppDelegate.updatePAC)
    }
    
    var customPACWindowController : CustomPACWindowController!
    
    /**
     自定义pac规则
     */
    @IBAction func customPAC(_ sender: NSMenuItem) {
        WindowControllerUtil.default.openCustomPACWindow(self)
    }
    
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
     打开关于窗口
     */
    @IBAction func about(_ sender: Any) {
        WindowControllerUtil.default.openAboutWindow(self)
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
            "selectedServerName": "",
            "socks.listen": "127.0.0.1",
            "socks.port": NSNumber(value: 1280),
            "pac.port": NSNumber(value: 1281),
            "privoxy.enable": true,
            "privoxy.listen": "127.0.0.1",
            "privoxy.port": NSNumber(value: 1282),
            "gfwList": "https://raw.githubusercontent.com/gfwlist/gfwlist/master/gfwlist.txt",
            "ignoreHosts": "127.0.0.1, localhost, 192.168.0.0/16, 10.0.0.0/8, FE80::/64, ::1, FD00::/8",
        ])
    }
    
    private func installTools() {
        if !ProxyConfigUtil.default.install() {
            let message = NSUserNotification()
            message.title = "异常错误"
            message.subtitle = "安装代理客户端失败"
            NSUserNotificationCenter.default.deliver(message)
            
            self.startServiceItem.isEnabled = false
        }
        
        if !PrivoxyConfigUtil.default.install() {
            let message = NSUserNotification()
            message.title = "异常错误"
            message.subtitle = "安装HTTP服务器失败"
            NSUserNotificationCenter.default.deliver(message)
            
            self.startServiceItem.isEnabled = false
        }
        
        if !NetworkConfigUtil.default.install() {
            let message = NSUserNotification()
            message.title = "异常错误"
            message.subtitle = "安装网络配置工具失败"
            NSUserNotificationCenter.default.deliver(message)
            
            self.startServiceItem.isEnabled = false
        }
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
        
        let selected = UserDefaults.standard.string(forKey: "selectedServerName")!
        var isFound = false
        var hasValidConfig = false
        
        let serverConfigList = ServerConfigManagerUtil.default.getServerConfigList()
        for (_, serverConfig) in serverConfigList.enumerated() {
            let item = NSMenuItem()
            item.identifier = NSUserInterfaceItemIdentifier(serverConfig.id)
            item.title = serverConfig.name
            
            if selected == serverConfig.id {
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
        
        if !isFound && "" != selected {
            UserDefaults.standard.set("", forKey: "selectedServerName")
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
        UserDefaults.standard.set(sender.identifier?.rawValue, forKey: "selectedServerName")
        self.startServiceItem.action = #selector(AppDelegate.startServiceAction)
        
        if !ProxyConfigUtil.default.sync(action: "restart") {
            UserDefaults.standard.set(false, forKey: "isStarted")
            self.setStopState()
            
            return
        }
        
        UserDefaults.standard.set(true, forKey: "isStarted")
        self.setStartState()
        
        WebServerUtil.default.sync()
        if UserDefaults.standard.bool(forKey: "privoxy.enable") {
            PrivoxyConfigUtil.default.sync()
        }
        
        self.flushServerConfigList()
    }
    
    func setStartState() {
        UserDefaults.standard.set(true, forKey: "isStarted")
        
        self.startServiceItem.isHidden = true
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
        
        self.closeServiceItem.isHidden = true
        self.startServiceItem.isHidden = false
        
        if let button = self.statusBarItem.button {
            button.image = NSImage(named: "IconOff")
        }
    }
    
    /**
     始终显示通知
     */
    func userNotificationCenter(_ center: NSUserNotificationCenter, shouldPresent notification: NSUserNotification) -> Bool {
        return true
    }
    
    /**
     注册观察者
     */
    private func registerObserver() {
        NotificationCenter.default.addObserver(forName: NotifyServerConfigListChange, object: nil, queue: nil, using: { note in
            self.flushServerConfigList()
        })
        
        NotificationCenter.default.addObserver(forName: NotifyPACUpdate, object: nil, queue: nil, using: { note in
            self.updatePACStatus()
        })
        
        NotificationCenter.default.addObserver(forName: NotifyPreferencesChange, object: nil, queue: nil, using: { note in
            if UserDefaults.standard.bool(forKey: "isStarted") {
                NetworkConfigUtil.default.sync()
                ProxyAutoConfigUtil.default.sync(false)
                WebServerUtil.default.sync()
                if UserDefaults.standard.bool(forKey: "privoxy.enable") {
                    PrivoxyConfigUtil.default.sync()
                }
            }
        })
        
        NotificationCenter.default.addObserver(forName: NotifyPACRuleChange, object: nil, queue: nil, using: { note in
            ProxyAutoConfigUtil.default.sync(false)
            WebServerUtil.default.sync()
        })
    }
}

