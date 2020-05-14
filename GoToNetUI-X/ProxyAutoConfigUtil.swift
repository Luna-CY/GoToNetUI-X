//
//  ProxyAutoConfigUtil.swift
//  GoToNetUI-X
//
//  Created by ronghui.huo on 2020/5/14.
//  Copyright © 2020 Luna. All rights reserved.
//

import Foundation

class ProxyAutoConfigUtil : NSObject {
    
    static let `default` = ProxyAutoConfigUtil()
    
    private override init() {
        super.init()
    }
    
    func generate() -> Bool {
        return true
    }
}
