//
//  WindowControllerUtil.swift
//  GoToNetUI-X
//
//  Created by Luna on 2020/5/15.
//  Copyright © 2020 Luna. All rights reserved.
//

import Foundation
import Cocoa

class WindowControllerUtil : NSObject {
    
    static let `default` = WindowControllerUtil()
    
    private var serverEditorWindow : ServerEditorWindowController!
    
    private var preferencesWindow : PreferencesWindowController!
    
    private var customPACWindow : CustomPACWindowController!
    
    private var aboutWindow : AboutWindowController!
    
    private override init() {
        super.init()
    }
    
    /**
     打开服务器配置编辑窗口
     */
    func openServerEditorWindow(_ parent: Any?) {
        if nil != self.serverEditorWindow {
            self.serverEditorWindow.close()
        }
        
        self.serverEditorWindow = ServerEditorWindowController(windowNibName: NSNib.Name("ServerEditorWindow"))
        self.serverEditorWindow.showWindow(self)
        
        NSApp.activate(ignoringOtherApps: true)
    }
    
    /**
     打开偏好设置窗口
     */
    func openPreferencesWindow(_ parent: Any?) {
        if nil != self.preferencesWindow {
            self.preferencesWindow.close()
        }
        
        self.preferencesWindow = PreferencesWindowController(windowNibName: NSNib.Name("PreferencesWindow"))
        self.preferencesWindow.showWindow(self)
        
        NSApp.activate(ignoringOtherApps: true)
    }
    
    /**
     打开自定义规则窗口
     */
    func openCustomPACWindow(_ parent : Any?) {
        if nil != self.customPACWindow {
            self.customPACWindow.close()
        }
        
        self.customPACWindow = CustomPACWindowController(windowNibName: NSNib.Name("CustomPACWindow"))
        self.customPACWindow.showWindow(parent)
        
        NSApp.activate(ignoringOtherApps: true)
    }
    
    /**
     打开关于窗口
     */
    func openAboutWindow(_ parent: Any?) {
        if nil != self.aboutWindow {
            self.aboutWindow.close()
        }
        
        self.aboutWindow = AboutWindowController(windowNibName: NSNib.Name("AboutWindow"))
        self.aboutWindow.showWindow(parent)
        
        NSApp.activate(ignoringOtherApps: true)
    }
}
