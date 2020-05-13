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
        let scp = SystemConfiguration.SCPreferencesCreate(nil, SystemConfiguration.kSCPrefNetworkServices, nil)!
        
        let services = SystemConfiguration.SCPreferencesGetValue(scp, SystemConfiguration.kSCPrefNetworkServices)! as! NSDictionary
        
        let proxies = NSMutableDictionary()
        for (key, value) in services {
            let d = value as! NSMutableDictionary
            
            let hardware = d.value(forKeyPath: "Interface.Hardware")! as! NSString
            if hardware.isEqual(to: "airPort") || hardware.isEqual(to: "Ethernet") {
                let path = String.init(format: "/%@/%@/%@", SystemConfiguration.kSCPrefNetworkServices as String, key as! String, SystemConfiguration.kSCEntNetProxies as String)
                
                proxies.setObject(NSNumber(value: 1), forKey: SystemConfiguration.kSCPropNetProxiesSOCKSEnable as NSString)
                proxies.setObject(UserDefaults.standard.string(forKey: "localAddr")!, forKey: SystemConfiguration.kSCPropNetProxiesSOCKSProxy as NSString)
                proxies.setObject(NSNumber(value: UserDefaults.standard.integer(forKey: "localPort")), forKey: SystemConfiguration.kSCPropNetProxiesSOCKSPort as NSString)
                
                SystemConfiguration.SCPreferencesPathSetValue(scp, path as CFString, proxies as CFDictionary)
            }
        }
    }
}
