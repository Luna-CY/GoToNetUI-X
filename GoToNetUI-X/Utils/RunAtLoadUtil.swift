//
//  RunAtLoadUtil.swift
//  GoToNetUI-X
//
//  Created by Luna on 2020/9/30.
//  Copyright © 2020 Luna. All rights reserved.
//

import Foundation

class RunAtLoadUtil : NSObject {
    
    static let `default` = RunAtLoadUtil()
    
    private let bundle = Bundle.main
    
    private let manager = FileManager.default
    
    private let defaults = UserDefaults.standard
    
    private let plist = "xin.luna.GoToNetUI-X.plist"
    
    private override init() {
        super.init()
    }
    
    public func enable() -> Bool {
        let plistFilepath = LaunchAgentDir + self.plist
        
        if !self.manager.fileExists(atPath: LaunchAgentDir) {
            try! self.manager.createDirectory(atPath: LaunchAgentDir, withIntermediateDirectories: true, attributes: nil)
        }
        
        let dict: NSMutableDictionary = [
            "Label": "xin.luna.GoToNetUI-X",
            "Program": "/Applications/GoToNetUI-X.app/Contents/MacOS/GoToNetUI-X",
            "RunAtLoad": true,
        ]
        
        dict.write(toFile: plistFilepath, atomically: true)
        
        return true
    }
    
    public func disable() -> Bool {
        let plistFilepath = LaunchAgentDir + self.plist
        
        if !self.manager.fileExists(atPath: LaunchAgentDir) {
            try! self.manager.createDirectory(atPath: LaunchAgentDir, withIntermediateDirectories: true, attributes: nil)
        }
        
        let dict: NSMutableDictionary = [
            "Label": "xin.luna.GoToNetUI-X",
            "Program": "/Applications/GoToNetUI-X.app/Contents/MacOS/GoToNetUI-X",
            "RunAtLoad": false,
        ]
        
        dict.write(toFile: plistFilepath, atomically: true)
        
        return true
    }
}
