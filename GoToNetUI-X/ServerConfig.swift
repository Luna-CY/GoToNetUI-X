//
//  ServerConfig.swift
//  GoToNetUI-X
//
//  Created by ronghui.huo on 2020/5/10.
//  Copyright © 2020 Luna. All rights reserved.
//

import Foundation

/**
 服务器配置结构
 */
struct ServerConfig {
    var name: String
    
    var hostname: String
    var serverPort: Int16
    
    var localAddress: String
    var localPort: Int16
    
    var username: String
    var password: String
}

/**
 服务器配置管理器
 */
class ServerConfigManager : NSObject {
    static let `default` = ServerConfigManager()
    
    private var list: [String: ServerConfig] = [:]
    
    override private init() {
        super.init()
        
        if nil == UserDefaults.standard.dictionary(forKey: "serverConfigList") {
//            UserDefaults.standard.set(self.list, forKey: "serverConfigList")
        }
    }
    
    /**
     获取服务器配置列表
     */
    func getServerConfigList() -> [String: ServerConfig] {
//        for (key, value) in UserDefaults.standard.dictionary(forKey: "serverConfigList")! {
//            self.list[key] = (value as! ServerConfig)
//        }
        
        return self.list
    }
    
    /**
     添加服务器配置
     */
    func addServerConfig(name: String, serverConfig: ServerConfig) -> Bool {
        self.list[name] = serverConfig
        
//        UserDefaults.standard.set(self.list, forKey: "serverConfigList")
        
        return true
    }
}
