//
//  CustomPACWindowController.swift
//  GoToNetUI-X
//
//  Created by Luna on 2020/5/15.
//  Copyright © 2020 Luna. All rights reserved.
//

import Cocoa

class CustomPACWindowController: NSWindowController {
    
    @IBOutlet var rule: NSTextView!
    
    @IBOutlet weak var saveButton: NSButton!
    
    @IBOutlet weak var cleanButton: NSButton!
    
    override func windowDidLoad() {
        super.windowDidLoad()
        
        if "" == self.rule.string {
            self.rule.string = "! 每行一个规则\n! 以!开始的行为注释将会被忽略"
        }
        
        if FileManager.default.fileExists(atPath: SupportDir + ProxyAutoConfigUtil.default.userRuleFileName) {
            self.rule.string = try! String(contentsOfFile: SupportDir + ProxyAutoConfigUtil.default.userRuleFileName, encoding: .utf8)
        }
    }
    
    /**
     保存
     */
    @IBAction func save(_ sender: NSButton) {
        try! self.rule.string.write(toFile: SupportDir + ProxyAutoConfigUtil.default.userRuleFileName, atomically: true, encoding: .utf8)
        
        NotificationCenter.default.post(name: NotifyPACRuleChange, object: nil)
    }
    
    /**
     清空
     */
    @IBAction func reset(_ sender: NSButton) {
        self.rule.string = "! 每行一个规则\n! 以!开始的行为注释将会被忽略"
    }
    
}
