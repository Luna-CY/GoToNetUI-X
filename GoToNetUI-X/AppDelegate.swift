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
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        self.initTools()
        self.registerGlobalConfig()
        
        // Create the status item
        self.statusBarItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.squareLength)
        self.statusBarItem.menu = mainMenu
        
        if let button = self.statusBarItem.button {
            button.image = NSImage(named: "IconOff")
        }
    }
    
    @IBAction func quitAppItem(_ sender: Any) {
        NSApplication.shared.terminate(self)
    }
    
    
    @IBOutlet weak var startServiceItem: NSMenuItem!
    @IBAction func startServiceAction(_ sender: Any) {
        self.startServiceItem.isEnabled = false
        self.startServiceItem.isHidden = true
        
        self.closeServiceItem.isEnabled = true
        self.closeServiceItem.isHidden = false
        
        if let button = self.statusBarItem.button {
            button.image = NSImage(named: "IconOn")
        }
    }
    
    
    @IBOutlet weak var closeServiceItem: NSMenuItem!
    @IBAction func closeServiceAction(_ sender: Any) {
        self.closeServiceItem.isEnabled = false
        self.closeServiceItem.isHidden = true
        
        self.startServiceItem.isEnabled = true
        self.startServiceItem.isHidden = false
        
        if let button = self.statusBarItem.button {
            button.image = NSImage(named: "IconOff")
        }
    }
    
    @IBOutlet weak var pacModeItem: NSMenuItem!
    @IBAction func pacModeAction(_ sender: Any) {
        self.globalModeItem.state = .off
        self.manualModeItem.state = .off
        
        self.pacModeItem.state = .on
    }
    
    @IBOutlet weak var globalModeItem: NSMenuItem!
    @IBAction func globalModeAction(_ sender: Any) {
        self.pacModeItem.state = .off
        self.manualModeItem.state = .off
        
        self.globalModeItem.state = .on
    }
    
    @IBOutlet weak var manualModeItem: NSMenuItem!
    @IBAction func manualModeAction(_ sender: Any) {
        self.pacModeItem.state = .off
        self.globalModeItem.state = .off
        
        self.manualModeItem.state = .on
    }
    
    func initTools() {
        installCliCmd()
    }
    
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

