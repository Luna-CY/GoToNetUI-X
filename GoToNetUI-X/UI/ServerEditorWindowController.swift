//
//  ServerEditorWindowController.swift
//  GoToNetUI-X
//
//  Created by Luna on 2020/5/14.
//  Copyright © 2020 Luna. All rights reserved.
//

import Cocoa

class ServerEditorWindowController: NSWindowController, NSTableViewDataSource, NSTableViewDelegate {
    
    @IBOutlet weak var configName: NSTextField!
    
    @IBOutlet weak var host: NSTextField!
    
    @IBOutlet weak var port: NSTextField!
    
    @IBOutlet weak var username: NSTextField!
    
    @IBOutlet weak var password: NSSecureTextField!
    
    @IBOutlet weak var addButton: NSButton!
    
    @IBOutlet weak var saveButton: NSButton!
    
    @IBOutlet weak var delButton: NSButton!
    
    @IBOutlet weak var listTableView: NSTableView!
    
    override func windowDidLoad() {
        super.windowDidLoad()
        
        self.listTableView.dataSource = self
        self.listTableView.delegate = self
        
        self.saveButton.isEnabled = false
        self.delButton.isEnabled = false
        
        self.listTableView.selectRowIndexes(IndexSet(integer: 0), byExtendingSelection: true)
    }
    
    @IBAction func add(_ sender: Any) {
        let count = ServerConfigManagerUtil.default.getServerConfigList().count
        let id = ServerConfigManagerUtil.default.generateId()
        let name = "未命名配置"
        
        let config = ServerConfig(id: id, name: name, hostname: "", serverPort: 443, username: "", password: "")
        
        if !ServerConfigManagerUtil.default.addServerConfig(config) {
            return
        }
        
        self.listTableView.beginUpdates()
        self.listTableView.insertRows(at: IndexSet(integer: count), withAnimation: .effectFade)
        self.listTableView.endUpdates()
        
        self.listTableView.selectRowIndexes(IndexSet(integer: count), byExtendingSelection: false)
        
        NotificationCenter.default.post(name: NotifyServerConfigListChange, object: nil)
    }
    
    @IBAction func save(_ sender: Any) {
        if self.listTableView.selectedRow >= 0 {
            self.saveButton.isEnabled = false
            
            var config = ServerConfigManagerUtil.default.getServerConfigList()[self.listTableView.selectedRow]
            
            if !ServerConfigManagerUtil.default.delServerConfig(config.id) {
                return
            }
            
            config.name = self.configName.stringValue
            config.hostname = self.host.stringValue
            config.serverPort = Int(self.port.intValue)
            config.username = self.username.stringValue
            config.password = self.password.stringValue
            
            if !ServerConfigManagerUtil.default.addServerConfig(config) {
                return
            }
            
            self.listTableView.beginUpdates()
            self.listTableView.endUpdates()
            
            NotificationCenter.default.post(name: NotifyServerConfigListChange, object: nil)
        }
    }
    
    @IBAction func del(_ sender: Any) {
        if self.listTableView.selectedRow >= 0 {
            self.delButton.isEnabled = false
            
            let selectedRow = self.listTableView.selectedRow
            let config = ServerConfigManagerUtil.default.getServerConfigList()[self.listTableView.selectedRow]
            
            self.listTableView.beginUpdates()
            
            _ = ServerConfigManagerUtil.default.delServerConfig(config.id)
            
            self.listTableView.removeRows(at: IndexSet(integer: selectedRow), withAnimation: .effectFade)
            self.listTableView.endUpdates()
            
            self.listTableView.selectRowIndexes(IndexSet(integer: (selectedRow > 0 ? selectedRow - 1 : 0)), byExtendingSelection: false)
            
            NotificationCenter.default.post(name: NotifyServerConfigListChange, object: nil)
        }
    }
    
    /**
     返回表格总行数
     */
    func numberOfRows(in listTableView: NSTableView) -> Int {
        return ServerConfigManagerUtil.default.getServerConfigList().count
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
        let list = ServerConfigManagerUtil.default.getServerConfigList()
        
        if list.count > row {
            let config = list[row]
            
            if tableColumn == tableView.tableColumns[0] {
                if UserDefaults.standard.string(forKey: "selectedServerName")! != config.id {
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
            let config = ServerConfigManagerUtil.default.getServerConfigList()[self.listTableView.selectedRow]
            
            self.configName.isEnabled = true
            self.host.isEnabled = true
            self.port.isEnabled = true
            self.username.isEnabled = true
            self.password.isEnabled = true
            
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
