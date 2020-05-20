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
    
    @IBOutlet weak var git: NSTextField!
    
    @IBOutlet weak var iconAuthor: NSTextField!
    
    override func windowDidLoad() {
        super.windowDidLoad()

        self.icon.image = NSImage(named: "About")
        
        self.git.textColor = .linkColor
        self.git.backgroundColor = .clear
        self.git.isBordered = false
        self.git.isSelectable = true
        
        self.iconAuthor.textColor = .linkColor
        self.iconAuthor.backgroundColor = .clear
        self.iconAuthor.isBordered = false
        self.iconAuthor.isSelectable = true
        self.iconAuthor.allowsEditingTextAttributes = true
        
        let attribute = NSMutableAttributedString()
        attribute.append(NSAttributedString(string: "点击这里", attributes: [NSAttributedString.Key.link: "https://www.iconfont.cn/collections/detail?spm=a313x.7781069.1998910419.d9df05512&cid=2692"]))
        self.iconAuthor.attributedStringValue = attribute
        
    }
    
}
