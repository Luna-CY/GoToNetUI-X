//
//  ServerEditor.swift
//  GoToNetUI-X
//
//  Created by ronghui.huo on 2020/5/11.
//  Copyright © 2020 Luna. All rights reserved.
//

import Cocoa

class ServerEditor: NSView {
    
    @IBOutlet weak var editorBox: NSBox!
    
    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)
        
        self.editorBox.layer?.backgroundColor = .white
    }
    
    /**
     关闭窗口
     */
    @IBAction func closeWindow(_ sender: NSButton) {
        self.window?.close()
    }
    
}
