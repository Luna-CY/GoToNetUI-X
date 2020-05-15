//
//  PreferencesWindowController.swift
//  GoToNetUI-X
//
//  Created by Luna on 2020/5/14.
//  Copyright © 2020 Luna. All rights reserved.
//

import Cocoa

class PreferencesWindowController: NSWindowController {

    @IBOutlet weak var startServiceOnProgram: NSButton!
    
    @IBOutlet weak var localAddr: NSTextField!
    
    @IBOutlet weak var localPort: NSTextField!
    
    @IBOutlet weak var pacPort: NSTextField!
    
    @IBOutlet weak var gfwList: NSTextField!
    
    @IBOutlet weak var ignore: NSTextField!
    
    override func windowDidLoad() {
        super.windowDidLoad()
        
        self.startServiceOnProgram.state = UserDefaults.standard.bool(forKey: "startServiceOnProgram") ? .on : .off
        
        self.localAddr.stringValue = UserDefaults.standard.string(forKey: "localAddr")!
        self.localPort.stringValue = UserDefaults.standard.string(forKey: "localPort")!
        self.pacPort.stringValue = UserDefaults.standard.string(forKey: "pacPort")!
        self.gfwList.stringValue = UserDefaults.standard.string(forKey: "gfwList")!
        self.ignore.stringValue = UserDefaults.standard.string(forKey: "ignoreHosts")!
    }
    
    /*
     切换服务启动项
     */
    @IBAction func switchStartServiceOnProgram(_ sender: NSButton) {
        if sender.state == .on {
            UserDefaults.standard.set(true, forKey: "startServiceOnProgram")
        }
        
        if sender.state == .off {
            UserDefaults.standard.set(false, forKey: "startServiceOnProgram")
        }
    }
    
    /**
     保存代理设置
     */
    @IBAction func save(_ sender: Any) {
        if 0 == self.localPort.intValue || self.localPort.intValue > 65535 {
            self.localPort.stringValue = "1280"
        }
        
        UserDefaults.standard.set(self.localAddr.stringValue, forKey: "localAddr")
        UserDefaults.standard.set(NSNumber(value: Int(self.localPort.intValue)), forKey: "localPort")
        UserDefaults.standard.set(NSNumber(value: Int(self.pacPort.intValue)), forKey: "pacPort")
        UserDefaults.standard.set(self.gfwList.stringValue, forKey: "gfwList")
        UserDefaults.standard.set(self.ignore.stringValue, forKey: "ignoreHosts")
        
        NotificationCenter.default.post(name: NotifyPreferencesChange, object: nil)
    }
}
