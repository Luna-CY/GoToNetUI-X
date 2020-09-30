//
//  PreferencesWindowController.swift
//  GoToNetUI-X
//
//  Created by Luna on 2020/5/14.
//  Copyright © 2020 Luna. All rights reserved.
//

import Cocoa

class PreferencesWindowController: NSWindowController {

    @IBOutlet weak var startServiceOnLogin: NSButton!
    
    @IBOutlet weak var startServiceOnProgram: NSButton!
    
    @IBOutlet weak var localAddr: NSTextField!
    
    @IBOutlet weak var localPort: NSTextField!
    
    @IBOutlet weak var pacPort: NSTextField!
    
    @IBOutlet weak var enableHttp: NSButton!
    
    @IBOutlet weak var httpAddr: NSTextField!
    
    @IBOutlet weak var httpPort: NSTextField!
    
    @IBOutlet weak var gfwList: NSTextField!
    
    @IBOutlet weak var ignore: NSTextField!
    
    override func windowDidLoad() {
        super.windowDidLoad()
        
        self.startServiceOnLogin.state = UserDefaults.standard.bool(forKey: "startServiceOnLogin") ? .on : .off
        
        self.startServiceOnProgram.state = UserDefaults.standard.bool(forKey: "startServiceOnProgram") ? .on : .off
        
        self.localAddr.stringValue = UserDefaults.standard.string(forKey: "socks.listen")!
        self.localPort.stringValue = UserDefaults.standard.string(forKey: "socks.port")!
        
        self.pacPort.stringValue = UserDefaults.standard.string(forKey: "pac.port")!
        
        self.enableHttp.state = UserDefaults.standard.bool(forKey: "privoxy.enable") ? .on : .off
        self.httpAddr.stringValue = UserDefaults.standard.string(forKey: "privoxy.listen")!
        self.httpPort.stringValue = UserDefaults.standard.string(forKey: "privoxy.port")!
        
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
     切换开机启动选项
     */
    @IBAction func switchStartOnLogin(_ sender: NSButton) {
        if sender.state == .on {
            if RunAtLoadUtil.default.enable() {
                UserDefaults.standard.set(true, forKey: "startServiceOnLogin")
            }
        }
        
        if sender.state == .off {
            if RunAtLoadUtil.default.disable() {
                UserDefaults.standard.set(false, forKey: "startServiceOnLogin")
            }
        }
    }
    
    /**
     保存代理设置
     */
    @IBAction func save(_ sender: Any) {
        if 0 == self.localPort.intValue || self.localPort.intValue > 65535 {
            self.localPort.stringValue = "1280"
        }
        
        UserDefaults.standard.set(self.localAddr.stringValue, forKey: "socks.listen")
        UserDefaults.standard.set(NSNumber(value: Int(self.localPort.intValue)), forKey: "socks.port")
        
        UserDefaults.standard.set(NSNumber(value: Int(self.pacPort.intValue)), forKey: "pac.port")
        
        UserDefaults.standard.set(.on == self.enableHttp.state, forKey: "privoxy.enable")
        UserDefaults.standard.set(self.httpAddr.stringValue, forKey: "privoxy.listen")
        UserDefaults.standard.set(NSNumber(value: Int(self.httpPort.intValue)), forKey: "privoxy.port")
        
        UserDefaults.standard.set(self.gfwList.stringValue, forKey: "gfwList")
        UserDefaults.standard.set(self.ignore.stringValue, forKey: "ignoreHosts")
        
        NotificationCenter.default.post(name: NotifyPreferencesChange, object: nil)
    }
}
