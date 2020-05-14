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
struct ServerConfig : Codable {
    var id: String
    var name: String
    
    var hostname: String
    var serverPort: Int
    
    var username: String
    var password: String
    
    /**
     是否有效
     */
    func isValid() -> Bool {
        return "" != self.hostname && 0 != self.serverPort && "" != self.username && "" != self.password
    }
}

/**
 服务器配置管理器
 */
class ServerConfigManager : NSObject {
    
    static let `default` = ServerConfigManager()
    
    private let characters = "0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ"
    
    private var list : [ServerConfig] = []
    
    override private init() {
        super.init()
        
        let userConfigDir = NSHomeDirectory() + UserConfigDir
        
        let manager = FileManager.default
        if !manager.fileExists(atPath: userConfigDir) {
            try! manager.createDirectory(atPath: userConfigDir, withIntermediateDirectories: true, attributes: nil)
        }
        
        let configFilePath = userConfigDir + ServerConfigFileName
        
        if !manager.fileExists(atPath: configFilePath) {
            let data = "[]".data(using: .utf8)
            if !manager.createFile(atPath: configFilePath, contents: data, attributes: nil) {
                NSLog("创建服务器配置文件失败")
            }
        }
        
        let json = manager.contents(atPath: configFilePath)!
        self.list = (try! JSONDecoder().decode([ServerConfig].self, from: json)).sorted(by: {$0.name < $1.name})
    }
    
    /**
     获取服务器配置列表
     */
    func getServerConfigList() -> [ServerConfig] {
        return self.list
    }
    
    /**
     获取配置对象
     */
    func getServerConfig(id: String) -> ServerConfig? {
        for config in self.list {
            if config.id == id {
                return config
            }
        }
        
        return nil
    }
    
    /**
     添加服务器配置
     */
    func addServerConfig(_ serverConfig: ServerConfig) -> Bool {
        self.list.append(serverConfig)
        self.sort()
        
        return self.flushToFile()
    }
    
    /**
     删除服务器配置
     */
    func delServerConfig(_ id: String) -> Bool {
        for (index, config) in self.list.enumerated() {
            if config.id == id {
                self.list.remove(at: index)
            }
        }

        self.sort()
        
        return self.flushToFile()
    }
    
    /**
     刷新数据到文件
     */
    func flushToFile() -> Bool {
        let manager = FileManager.default
        let configFilePath = NSHomeDirectory() + UserConfigDir + ServerConfigFileName
        
        let data = try! JSONEncoder().encode(self.list)
        try! manager.removeItem(atPath: configFilePath)
        
        return manager.createFile(atPath: configFilePath, contents: data, attributes: nil)
    }
    
    /**
     生成id
     */
    func generateId() -> String {
        var ranStr = ""
        
        for _ in 0..<16 {
            let index = Int(arc4random_uniform(UInt32(self.characters.count)))
            ranStr.append(self.characters[self.characters.index(self.characters.startIndex, offsetBy: index)])
        }
        
        return ranStr
    }
    
    /**
     排序
     */
    private func sort() {
        self.list = self.list.sorted(by: {$0.name < $1.name})
    }
}
