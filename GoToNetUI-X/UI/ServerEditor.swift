//
//  ServerEditor.swift
//  GoToNetUI-X
//
//  Created by ronghui.huo on 2020/5/11.
//  Copyright © 2020 Luna. All rights reserved.
//

import Cocoa

class ServerEditor: NSView {
    
    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)
        
        // Drawing code here.
        self.editorContainerItem.wantsLayer = true
        self.editorContainerItem.layer?.backgroundColor = .white
    }
    
    @IBOutlet weak var editorContainerItem: NSView!
    
    @IBOutlet weak var configListViewItem: NSScrollView!
    
    /**
     关闭窗口
     */
    @IBAction func closeWindow(_ sender: Any) {
        self.window?.close()
    }
}
