//
//  ServerEditorController.swift
//  GoToNetUI-X
//
//  Created by ronghui.huo on 2020/5/11.
//  Copyright © 2020 Luna. All rights reserved.
//

import Cocoa

class ServerEditorController: NSViewController {
    
    @IBOutlet weak var configName: NSTextField!
    
    @IBOutlet weak var host: NSTextField!
    
    @IBOutlet weak var port: NSTextField!
    
    @IBOutlet weak var username: NSTextField!
    
    @IBOutlet weak var password: NSSecureTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func save(_ sender: Any) {
        NSLog(self.configName.stringValue)
        NSLog(self.port.stringValue)
        
        
    }
    
    @IBOutlet weak var configTableView: NSTableView!
}
