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
    
    private var ref : AuthorizationRef? = nil
    
    private override init() {
        super.init()
    }
    
    /**
     设置为pac自动模式
     */
    func setAuto(_ b : Bool) -> Bool {
        return true
    }
    
    /**
     设置全局代理状态
     */
    func setGlobal(_ b : Bool) -> Bool {
        let (scp, services) = self.getAuthorization()
        if nil == scp || nil == services {
            return false
        }
        
        let proxies = NSMutableDictionary()
        for (key, value) in services! {
            let d = value as! NSMutableDictionary
            
            let hardware = d.value(forKeyPath: "Interface.Hardware")! as! NSString
            if hardware.isEqual(to: "airPort") || hardware.isEqual(to: "Ethernet") {
                let path = String.init(format: "/%@/%@/%@", SystemConfiguration.kSCPrefNetworkServices as String, key as! String, SystemConfiguration.kSCEntNetProxies as String)
                
                if b {
                    proxies.setObject(NSNumber(value: 1), forKey: SystemConfiguration.kSCPropNetProxiesSOCKSEnable as NSString)
                    proxies.setObject(UserDefaults.standard.string(forKey: "localAddr")!, forKey: SystemConfiguration.kSCPropNetProxiesSOCKSProxy as NSString)
                    proxies.setObject(NSNumber(value: UserDefaults.standard.integer(forKey: "localPort")), forKey: SystemConfiguration.kSCPropNetProxiesSOCKSPort as NSString)
                } else {
                    proxies.setObject(NSNumber(value: 0), forKey: SystemConfiguration.kSCPropNetProxiesSOCKSEnable as NSString)
                }
                
                SystemConfiguration.SCPreferencesPathSetValue(scp!, path as CFString, proxies as CFDictionary)
            }
        }
        
        SystemConfiguration.SCPreferencesCommitChanges(scp!)
        SystemConfiguration.SCPreferencesApplyChanges(scp!)
        SystemConfiguration.SCPreferencesSynchronize(scp!)
        
        if nil != self.ref {
            SystemConfiguration.AuthorizationFree(self.ref!, AuthorizationFlags.interactionAllowed)
        }
        
        return true
    }
    
    /**
     设置为手动代理模式
     */
    func setManual() -> Bool {
        if !self.setGlobal(false) {
            return false
        }
        
        if !self.setAuto(false) {
            return false
        }
        
        return true
    }
    
    /**
     获取系统授权
     */
    private func getAuthorization() -> (SystemConfiguration.SCPreferences?, NSDictionary?) {
        let flag = AuthorizationFlags.interactionAllowed

        let osStatus = SystemConfiguration.AuthorizationCreate(nil, nil, flag, &self.ref)
        if SystemConfiguration.noErr != osStatus {
            NSLog("获取系统授权失败")

            return (nil, nil)
        }
        
        let scp = SystemConfiguration.SCPreferencesCreateWithAuthorization(nil, SystemConfiguration.kSCPrefNetworkServices, nil, self.ref!)
        let services = SystemConfiguration.SCPreferencesGetValue(scp!, SystemConfiguration.kSCPrefNetworkServices)! as? NSDictionary
        
        return (scp, services)
    }
}
