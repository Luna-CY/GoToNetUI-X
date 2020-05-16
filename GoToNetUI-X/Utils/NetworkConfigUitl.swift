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
    
    private var flags : AuthorizationFlags? = nil
    
    private var ref : AuthorizationRef? = nil
    
    private let helper = "/Library/Application Support/GoToNetUI-X/network-helper"
    
    private override init() {
        super.init()
        
//        self.flags = AuthorizationFlags.init(arrayLiteral: AuthorizationFlags.interactionAllowed, AuthorizationFlags.preAuthorize, AuthorizationFlags.extendRights)
//
//        let osStatus = SystemConfiguration.AuthorizationCreate(nil, nil, self.flags!, &self.ref)
//        if SystemConfiguration.noErr != osStatus {
//            NSLog("获取系统授权失败")
//        }
    }
    
//    deinit {
//        if nil != self.ref {
//            SystemConfiguration.AuthorizationFree(self.ref!, self.flags!)
//        }
//    }
    
    func install() -> Bool {
        if FileManager.default.fileExists(atPath: self.helper) {
            return true
        }
        
        let script = String.init(format: "do shell script \"/bin/bash \\\"%@\\\"\" with administrator privileges", String.init(format: "%@/%@", Bundle.main.resourcePath!, "install-network-helper.sh"))
        print(script)
        
        if nil != NSAppleScript.init(source: script)?.executeAndReturnError(nil) {
            return true
        } else {
            return false
        }
    }
    
    /**
     设置代理模式
     */
    func set(_ mode: String) -> Bool {
        switch mode {
        case "auto":
            return self.setAuto()
        case "global":
            return self.setGlobal()
        case "manual":
            return self.setManual()
        default:
            return false
        }
    }
    
    /**
     同步状态
     */
    func sync() {
        if "manual" != UserDefaults.standard.string(forKey: "runningMode")! {
            _ = self.set(UserDefaults.standard.string(forKey: "runningMode")!)
        }
    }
    
    /**
     设置为pac自动模式
     */
    private func setAuto() -> Bool {
//        if nil == self.ref {
//            return false
//        }
        
        NSLog("设置自动代理模式")
        
//        let proxies = NSMutableDictionary()
//        proxies.setObject(NSNumber(value: 0), forKey: SystemConfiguration.kSCPropNetProxiesSOCKSEnable as NSString)
//        proxies.setObject(NSNumber(value: 0), forKey: SystemConfiguration.kSCPropNetProxiesHTTPEnable as NSString)
//        proxies.setObject(NSNumber(value: 0), forKey: SystemConfiguration.kSCPropNetProxiesHTTPSEnable as NSString)
//
//        let url = String.init(format: "http://localhost:%@/proxy.pac", String(UserDefaults.standard.integer(forKey: "pac.port")))
//
//        proxies.setObject(NSNumber(value: 1), forKey: SystemConfiguration.kSCPropNetProxiesProxyAutoConfigEnable as NSString)
//        proxies.setObject(url as NSString, forKey: SystemConfiguration.kSCPropNetProxiesProxyAutoConfigURLString as NSString)
//        proxies.setObject(self.getIgnoreHosts().allObjects, forKey: SystemConfiguration.kSCPropNetProxiesExceptionsList as NSString)
//
//        self.setProxy(proxies: proxies)
//
//        return true
        
        let task = Process.launchedProcess(launchPath: self.helper, arguments: ["-m", "auto", "-u", "http://localhost:" + String(UserDefaults.standard.integer(forKey: "pac.port")) + "/proxy.pac"])
        
        task.waitUntilExit()
        if task.terminationStatus == 0 {
            NSLog("切换Auto模式成功")
            
            return true
        } else {
            NSLog("切换Auto模式失败")
            
            return false
        }
    }
    
    /**
     设置全局代理状态
     */
    private func setGlobal() -> Bool {
//        if nil == self.ref {
//            return false
//        }
        
        NSLog("设置全局代理模式")
        
//        let proxies = NSMutableDictionary()
//        proxies.setObject(NSNumber(value: 0), forKey: SystemConfiguration.kSCPropNetProxiesProxyAutoConfigEnable as NSString)
//        proxies.setObject(NSNumber(value: 0), forKey: SystemConfiguration.kSCPropNetProxiesHTTPEnable as NSString)
//        proxies.setObject(NSNumber(value: 0), forKey: SystemConfiguration.kSCPropNetProxiesHTTPSEnable as NSString)
//
//        // 设置SOCKS
//        proxies.setObject(NSNumber(value: 1), forKey: SystemConfiguration.kSCPropNetProxiesSOCKSEnable as NSString)
//        proxies.setObject(UserDefaults.standard.string(forKey: "socks.listen")!, forKey: SystemConfiguration.kSCPropNetProxiesSOCKSProxy as NSString)
//        proxies.setObject(NSNumber(value: UserDefaults.standard.integer(forKey: "socks.port")), forKey: SystemConfiguration.kSCPropNetProxiesSOCKSPort as NSString)
//
//        proxies.setObject(self.getIgnoreHosts().allObjects, forKey: SystemConfiguration.kSCPropNetProxiesExceptionsList as NSString)
//
//        self.setProxy(proxies: proxies)
//
//        return true
        
        let task = Process.launchedProcess(launchPath: self.helper, arguments: ["-m", "global", "-l", UserDefaults.standard.string(forKey: "socks.listen")!, "-p", String(UserDefaults.standard.integer(forKey: "socks.port"))])
        
        task.waitUntilExit()
        if task.terminationStatus == 0 {
            NSLog("切换Global模式成功")
            
            return true
        } else {
            NSLog("切换Global模式失败")
            
            return false
        }
    }
    
    /**
     设置为手动代理模式
     */
    private func setManual() -> Bool {
//        if nil == self.ref {
//            return false
//        }
        
        NSLog("设置手动代理模式")
        
//        let proxies = NSMutableDictionary()
//        proxies.setObject(NSNumber(value: 0), forKey: SystemConfiguration.kSCPropNetProxiesProxyAutoConfigEnable as NSString)
//        proxies.setObject(NSNumber(value: 0), forKey: SystemConfiguration.kSCPropNetProxiesSOCKSEnable as NSString)
//        proxies.setObject(NSNumber(value: 0), forKey: SystemConfiguration.kSCPropNetProxiesHTTPEnable as NSString)
//        proxies.setObject(NSNumber(value: 0), forKey: SystemConfiguration.kSCPropNetProxiesHTTPSEnable as NSString)
//        proxies.setObject(NSMutableSet().allObjects, forKey: SystemConfiguration.kSCPropNetProxiesExceptionsList as NSString)
//
//        self.setProxy(proxies: proxies)
//
//        return true
        
        let task = Process.launchedProcess(launchPath: self.helper, arguments: ["-m", "off"])
        
        task.waitUntilExit()
        if task.terminationStatus == 0 {
            NSLog("切换Manual模式成功")
            
            return true
        } else {
            NSLog("切换Manual模式失败")
            
            return false
        }
    }
    
    /**
     设置代理
     */
    private func setProxy(proxies : NSMutableDictionary) {
        let scp = SystemConfiguration.SCPreferencesCreateWithAuthorization(nil, SystemConfiguration.kSCPrefNetworkServices, nil, self.ref!)
        let services = SystemConfiguration.SCPreferencesGetValue(scp!, SystemConfiguration.kSCPrefNetworkServices)! as? NSDictionary
        
        for (key, value) in services! {
            let d = value as! NSMutableDictionary
            
            let hardware = d.value(forKeyPath: "Interface.Hardware")! as! NSString
            let userDefinedName = d.value(forKeyPath: "Interface.UserDefinedName")! as! NSString
            
            if hardware.isEqual(to: "AirPort") || hardware.isEqual(to: "Ethernet") || hardware.isEqual(to: "Wi-Fi") || userDefinedName.isEqual(to: "Wi-Fi") {
                let path = String.init(format: "/%@/%@/%@", SystemConfiguration.kSCPrefNetworkServices as String, key as! String, SystemConfiguration.kSCEntNetProxies as String)
                
                SystemConfiguration.SCPreferencesPathSetValue(scp!, path as CFString, proxies as CFDictionary)
            }
        }
        
        SystemConfiguration.SCPreferencesCommitChanges(scp!)
        SystemConfiguration.SCPreferencesApplyChanges(scp!)
        SystemConfiguration.SCPreferencesSynchronize(scp!)
    }
    
    /**
     获取忽略主机列表
     */
    private func getIgnoreHosts() -> NSMutableSet {
        let ignoreHosts = NSMutableSet()
        let hosts = UserDefaults.standard.string(forKey: "ignoreHosts")!.components(separatedBy: CharacterSet(charactersIn: ","))
        for host in hosts {
            ignoreHosts.add(host.trimmingCharacters(in: .whitespaces) as NSString)
        }
        
        return ignoreHosts
    }
}
