//
//  PreferencesController.swift
//  GoToNetUI-X
//
//  Created by Luna on 2020/5/13.
//  Copyright © 2020 Luna. All rights reserved.
//

import Cocoa

class PreferencesController: NSViewController {

    @IBOutlet weak var startOnUser: NSButton!
    
    @IBOutlet weak var startServiceOnProgram: NSButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.startOnUser.isEnabled = false
        self.startServiceOnProgram.state = UserDefaults.standard.bool(forKey: "startServiceOnProgram") ? .on : .off
        
        self.localAddr.stringValue = UserDefaults.standard.string(forKey: "localAddr")!
        self.localPort.stringValue = UserDefaults.standard.string(forKey: "localPort")!
        self.gfwListAddr.stringValue = UserDefaults.standard.string(forKey: "gfwList")!
    }
    
    /**
     切换开机启动项
     */
    @IBAction func switchStartOnUser(_ sender: NSButton) {
        if sender.state == .on {
            UserDefaults.standard.set(true, forKey: "startOnUser")
        }
        
        if sender.state == .off {
            UserDefaults.standard.set(false, forKey: "startOnUser")
        }
    }
    
    /**
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
    
    @IBOutlet weak var localAddr: NSTextField!
    
    @IBOutlet weak var localPort: NSTextField!
    
    @IBOutlet weak var gfwListAddr: NSTextField!
    
    @IBOutlet weak var saveProxyButton: NSButton!
    
    /**
     保存代理设置
     */
    @IBAction func saveProxy(_ sender: NSButton) {
        UserDefaults.standard.set(self.localAddr.stringValue, forKey: "localAddr")
        
        if 0 == self.localPort.intValue || self.localPort.intValue > 65535 {
            self.localPort.stringValue = "1280"
        }
        
        UserDefaults.standard.set(NSNumber(value: Int(self.localPort.intValue)), forKey: "localPort")
        
        UserDefaults.standard.set(self.gfwListAddr.stringValue, forKey: "gfwList")
    }
}
