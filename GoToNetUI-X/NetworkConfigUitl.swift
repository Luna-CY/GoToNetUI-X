//
//  NetworkConfigUitl.swift
//  GoToNetUI-X
//
//  Created by Luna on 2020/5/13.
//  Copyright © 2020 Luna. All rights reserved.
//

import Foundation
import SystemConfiguration
import CFNetwork
import Security.Authorization

class NetworkConfigUtil : NSObject {
    static let `default` = NetworkConfigUtil()
    
    private override init() {
        super.init()
    }
    
    func setGlobalProxy() {
        
    }
}
