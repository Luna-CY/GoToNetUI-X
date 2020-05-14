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
    
    @IBOutlet weak var gfwList: NSTextField!
    
    override func windowDidLoad() {
        super.windowDidLoad()
        
        self.startServiceOnProgram.state = UserDefaults.standard.bool(forKey: "startServiceOnProgram") ? .on : .off
        
        self.localAddr.stringValue = UserDefaults.standard.string(forKey: "localAddr")!
        self.localPort.stringValue = UserDefaults.standard.string(forKey: "localPort")!
        self.gfwList.stringValue = UserDefaults.standard.string(forKey: "gfwList")!
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
        UserDefaults.standard.set(self.localAddr.stringValue, forKey: "localAddr")
        
        if 0 == self.localPort.intValue || self.localPort.intValue > 65535 {
            self.localPort.stringValue = "1280"
        }
        
        UserDefaults.standard.set(NSNumber(value: Int(self.localPort.intValue)), forKey: "localPort")
        
        UserDefaults.standard.set(self.gfwList.stringValue, forKey: "gfwList")
    }
}
