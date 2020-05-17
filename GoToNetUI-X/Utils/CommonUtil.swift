//
//  CommonUtil.swift
//  GoToNetUI-X
//
//  Created by ronghui.huo on 2020/5/17.
//  Copyright © 2020 Luna. All rights reserved.
//

import Foundation

class CommonUtil : NSObject {
    
    static let `default` = CommonUtil()
    
    private override init() {
        super.init()
    }
    
    /**
     发送通知消息
     */
    public func notify(title : String, subTitle : String?) {
        let message = NSUserNotification()
        message.title = title
        if nil != subTitle {
            message.subtitle = subTitle
        }
        
        NSUserNotificationCenter.default.deliver(message)
    }
}
