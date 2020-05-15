//
//  WebServerUtil.swift
//  GoToNetUI-X
//
//  Created by Luna on 2020/5/15.
//  Copyright © 2020 Luna. All rights reserved.
//

import Foundation
import GCDWebServers

class WebServerUtil : NSObject {
    
    static let `default` = WebServerUtil()
    
    private var isStarted = false
    
    private var server : GCDWebServer
    
    private override init() {
        self.server = GCDWebServer()
        
        super.init()
    }
    
    /**
     同步服务器状态
     */
    func sync() {
        if "auto" == UserDefaults.standard.string(forKey: "runningMode")! {
            if !UserDefaults.standard.bool(forKey: "isStarted") && self.isStarted {
                self.stop()
            }
            
            if UserDefaults.standard.bool(forKey: "isStarted") && !self.isStarted {
                self.start()
            }
            
            if UserDefaults.standard.bool(forKey: "isStarted") && self.isStarted {
                self.restart()
            }
        } else if self.isStarted {
            self.stop()
        }
    }
    
    /**
     启动服务器
     */
    func start() {
        if !FileManager.default.fileExists(atPath: SupportDir + ProxyAutoConfigUtil.default.pacFileName) {
            ProxyAutoConfigUtil.default.sync(false)
        }
        
        self.server.addDefaultHandler(forMethod: "GET", request: GCDWebServerRequest.self, processBlock: {request in
            return GCDWebServerDataResponse(html: "<html><head><title>GCD Web Server</title></head><body></body></html>")
        })
        
        self.server.addHandler(forMethod: "GET", pathRegex: "/proxy.pac", request: GCDWebServerRequest.self, processBlock: {request in
            return GCDWebServerDataResponse(data: NSData(contentsOfFile: SupportDir + ProxyAutoConfigUtil.default.pacFileName)! as Data, contentType: "application/x-ns-proxy-autoconfig")
        })
        
        if self.server.start(withPort: UInt(UserDefaults.standard.integer(forKey: "pac.port")), bonjourName: nil) {
            self.isStarted = true
        }
    }
    
    /**
     停止服务器
     */
    func stop() {
        self.server.stop()
        
        self.isStarted = false
    }
    
    /**
     重启服务器
     */
    func restart() {
        self.stop()
        self.start()
    }
}
