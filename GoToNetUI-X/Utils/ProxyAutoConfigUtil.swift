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
    
    /**
     执行同步动作
     */
    func sync(_ force : Bool) {
        if force {
            self.download(UserDefaults.standard.string(forKey: "gfwList")!)
        } else {
            self.generate(false)
        }
    }
    
    /**
     生成pac文件
     */
    private func generate(_ sendNotify: Bool) {
        if !FileManager.default.fileExists(atPath: UserConfigDir + GFWListFileName) {
            try! FileManager.default.copyItem(atPath: Bundle.main.path(forResource: "gfwlist", ofType: "txt")!, toPath: UserConfigDir + GFWListFileName)
        }
        let base64Encoded = try! String(contentsOfFile: UserConfigDir + GFWListFileName)
        
        let rules = String(data: Data(base64Encoded: base64Encoded, options: .ignoreUnknownCharacters)!, encoding: .utf8)?.components(separatedBy: .newlines)
        let userRules = self.getUserRules().components(separatedBy: .newlines)
        
        var lines = userRules + rules!.filter { (line) in
            // ignore the rule from gwf if user provide same rule for the same url
            var i = line.startIndex
            while i < line.endIndex {
                if line[i] == "@" || line[i] == "|" {
                    i = line.index(after: i)
                    continue
                }
                break
            }
            if i == line.startIndex {
                return !userRules.contains(line)
            }
            return !userRules.contains(String(line[i...]))
        }
        
        lines = lines.filter({ (s: String) -> Bool in
            if s.isEmpty {
                return false
            }
            let c = s[s.startIndex]
            if c == "!" || c == "[" {
                return false
            }
            return true
        })
        
        var success = true
        do {
            // rule lines to json array
            let rulesJsonData: Data
                = try JSONSerialization.data(withJSONObject: lines, options: .prettyPrinted)
            let rulesJsonStr = String(data: rulesJsonData, encoding: String.Encoding.utf8)
            
            // Get raw pac js
            let jsPath = Bundle.main.url(forResource: "template", withExtension: "js")
            let jsData = try? Data(contentsOf: jsPath!)
            var jsStr = String(data: jsData!, encoding: String.Encoding.utf8)
            
            // Replace rules placeholder in pac js
            jsStr = jsStr!.replacingOccurrences(of: "__RULES__"
                , with: rulesJsonStr!)
            
            // Replace __SOCKS5PORT__ palcholder in pac js
            let socks5Port = UserDefaults.standard.integer(forKey: "localPort")
            jsStr = jsStr!.replacingOccurrences(of: "__SOCKS5PORT__"
                , with: "\(socks5Port)")
            
            // Replace __SOCKS5ADDR__ palcholder in pac js
            var sin6 = sockaddr_in6()
            let socks5Address = UserDefaults.standard.string(forKey: "localAddr")!
            if socks5Address.withCString({ cstring in inet_pton(AF_INET6, cstring, &sin6.sin6_addr) }) == 1 {
                jsStr = jsStr!.replacingOccurrences(of: "__SOCKS5ADDR__"
                    , with: "[\(socks5Address)]")
            } else {
                jsStr = jsStr!.replacingOccurrences(of: "__SOCKS5ADDR__"
                    , with: socks5Address)
            }
            
            // Write the pac js to file.
            try jsStr!.data(using: String.Encoding.utf8)?
                .write(to: URL(fileURLWithPath: UserConfigDir + PACFileName), options: .atomic)
            
        } catch {
            success = false
        }
        
        if sendNotify {
            self.notify(success)
        }
    }
    
    /**
     获取用户规则
     */
    private func getUserRules() -> String {
        if FileManager.default.fileExists(atPath: UserConfigDir + UserRulesFileName) {
            return try! String(contentsOfFile: UserConfigDir + UserRulesFileName, encoding: .utf8)
        }
        
        return ""
    }
    
    /**
     发送用户通知
     */
    private func notify(_ status: Bool) {
        NotificationCenter.default.post(name: NotifyPACUpdate, object: nil)
        
        let message = NSUserNotification()
        message.title = "PAC更新通知"
        message.subtitle = "更新PAC规则" + (status ? "成功" : "失败")
        
        NSUserNotificationCenter.default.deliver(message)
    }
    
    /**
     下载文件
     */
    private func download(_ from: String) {
        let request = URLRequest(url: URL(string: from.addingPercentEncoding(withAllowedCharacters: .urlFragmentAllowed)!)!)
        
        let task = URLSession.shared.dataTask(with: request) { (d, _, e) in
            if nil == e && nil != d {
                let base64Encoded = String(data: d!, encoding: .utf8)!
                try! base64Encoded.write(toFile: UserConfigDir + GFWListFileName, atomically: true, encoding: .utf8)
                
                self.generate(true)
            } else {
                self.notify(false)
            }
        }
        
        task.resume()
    }
}
