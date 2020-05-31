//
//  About.swift
//  GoToNetUI-X
//
//  Created by Luna on 2020/5/19.
//  Copyright © 2020 Luna. All rights reserved.
//

import Cocoa

class AboutWindowController: NSWindowController {
    
    @IBOutlet weak var icon: NSImageView!
    
    @IBOutlet weak var version: NSTextField!
    
    @IBOutlet weak var git: NSTextField!
    
    override func windowDidLoad() {
        super.windowDidLoad()

        self.icon.image = NSImage(named: "About")
        self.version.stringValue = AppVersion
        
        self.git.textColor = .linkColor
        self.git.backgroundColor = .clear
        self.git.isBordered = false
        self.git.isSelectable = true
    }
    
}
