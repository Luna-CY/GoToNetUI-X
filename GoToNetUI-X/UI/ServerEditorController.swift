//
//  ServerEditorController.swift
//  GoToNetUI-X
//
//  Created by ronghui.huo on 2020/5/11.
//  Copyright © 2020 Luna. All rights reserved.
//

import Foundation
import Cocoa

class ServerEditorController: NSViewController, NSTableViewDataSource, NSTableViewDelegate {
    
    @IBOutlet weak var configName: NSTextField!
    
    @IBOutlet weak var host: NSTextField!
    
    @IBOutlet weak var port: NSTextField!
    
    @IBOutlet weak var username: NSTextField!
    
    @IBOutlet weak var password: NSSecureTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.listTableView.dataSource = self
        self.listTableView.delegate = self
        
        self.saveButton.isEnabled = false
        self.delButton.isEnabled = false
        
        self.listTableView.selectRowIndexes(IndexSet(arrayLiteral: 0), byExtendingSelection: true)
    }
    
    @IBOutlet weak var saveButton: NSButton!
    @IBOutlet weak var delButton: NSButton!
    
    
    /**
     新增配置
     */
    @IBAction func add(_ sender: NSButton) {
        let count = ServerConfigManager.default.getServerConfigList().count
        let name = "未命名配置"
        let config = ServerConfig(name: name, hostname: "", serverPort: 443, username: "", password: "")
        
        if !ServerConfigManager.default.addServerConfig(config) {
            return
        }
        
        self.listTableView.beginUpdates()
        self.listTableView.insertRows(at: IndexSet(integer: count), withAnimation: .effectFade)
        self.listTableView.endUpdates()
        
        NotificationCenter.default.post(name: NotifyServerConfigListChange, object: nil)
    }
    
    /**
     保存配置
     */
    @IBAction func save(_ sender: NSButton) {
        if self.listTableView.selectedRow >= 0 {
            var config = ServerConfigManager.default.getServerConfigList()[self.listTableView.selectedRow]
            
            if !ServerConfigManager.default.delServerConfig(self.listTableView.selectedRow) {
                return
            }
            
            config.name = self.configName.stringValue
            config.hostname = self.host.stringValue
            config.serverPort = Int(self.port.intValue)
            config.username = self.username.stringValue
            config.password = self.password.stringValue
            
            if !ServerConfigManager.default.addServerConfig(config) {
                return
            }
            
            self.listTableView.beginUpdates()
            self.listTableView.endUpdates()
            
            NotificationCenter.default.post(name: NotifyServerConfigListChange, object: nil)
        }
    }
    
    /**
     删除配置
     */
    @IBAction func del(_ sender: NSButton) {
        if self.listTableView.selectedRow >= 0 {
            self.listTableView.beginUpdates()
            
            _ = ServerConfigManager.default.delServerConfig(self.listTableView.selectedRow)
            
            self.listTableView.removeRows(at: IndexSet(arrayLiteral: self.listTableView.selectedRow), withAnimation: .effectFade)
            self.listTableView.selectRowIndexes(IndexSet(arrayLiteral: self.listTableView.selectedRow > 0 ? self.listTableView.selectedRow - 1 : 0), byExtendingSelection: true)
            
            self.listTableView.endUpdates()
            
            NotificationCenter.default.post(name: NotifyServerConfigListChange, object: nil)
        }
    }
    
    @IBOutlet weak var listTableView: NSTableView!
    
    /**
     返回表格总行数
     */
    func numberOfRows(in listTableView: NSTableView) -> Int {
        return ServerConfigManager.default.getServerConfigList().count
    }
    
    /**
     不允许直接编辑
     */
    func tableView(_ tableView: NSTableView, shouldEdit tableColumn: NSTableColumn?, row: Int) -> Bool {
        return false
    }
    
    /**
     显示单元格
     */
    func tableView(_ tableView: NSTableView, objectValueFor tableColumn: NSTableColumn?, row: Int) -> Any? {
        let list = ServerConfigManager.default.getServerConfigList()
        
        if list.count > row {
            let config = list[row]
            
            if tableColumn == tableView.tableColumns[0] {
                if UserDefaults.standard.integer(forKey: "selectedServerName") != row {
                    return nil
                }
                
                return NSImage.init(named: NSImage.Name("NSMenuOnStateTemplate"))
            }
            
            if tableColumn == tableView.tableColumns[1] {
                return config.name
            }
        }
        
        return nil
    }
    
    /**
     通知表格选择状态
     */
    func tableViewSelectionDidChange(_ notification: Notification) {
        if self.listTableView.selectedRow >= 0 {
            let config = ServerConfigManager.default.getServerConfigList()[self.listTableView.selectedRow]
            
            self.configName.stringValue = config.name
            self.host.stringValue = config.hostname
            self.port.stringValue = String(config.serverPort)
            self.username.stringValue = config.username
            self.password.stringValue = config.password
            
            self.saveButton.isEnabled = true
            self.delButton.isEnabled = true
        }
    }
    
}
