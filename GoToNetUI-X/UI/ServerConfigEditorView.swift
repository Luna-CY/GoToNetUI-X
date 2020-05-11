//
//  ServerConfigEditorWindow.swift
//  GoToNetUI-X
//
//  Created by Luna on 2020/5/11.
//  Copyright © 2020 Luna. All rights reserved.
//

import SwiftUI

struct ServerConfigEditorView: View {
    @State var name = ""
    
    @State var host = ""
    @State var port = "443"
    
    @State var username = ""
    @State var password = ""
    
    var body: some View {
        VStack {
            HStack{
                VStack{
                    HStack {
                        Text("Hello, World!")
                        Spacer()
                    }.frame(width: nil, height: nil, alignment: .leading)
                        .padding(.vertical, 6)
                        .padding(.horizontal, 6)
                    
                    Spacer()
                }.frame(width: 250, height: 350, alignment: .center)
                    .background(Color.white)
                
                Spacer()
                
                VStack{
                    HStack{
                        Text("配置名称").frame(width: 60, height: nil, alignment: .leading)
                        TextField("配置名称必须唯一", text: $name)
                    }.padding(.vertical, 20)
                    
                    HStack{
                        Text("服务器").frame(width: 60, height: nil, alignment: .leading)
                        TextField("域名", text: $host)
                        TextField("端口", text: $port).frame(width: 50, height: nil, alignment: .leading)
                    }.padding(.vertical, 2)
                    HStack{
                        Text("用户名称").frame(width: 60, height: nil, alignment: .leading)
                        TextField("验证的用户名称", text: $username)
                    }.padding(.vertical, 2)
                    HStack{
                        Text("用户密码").frame(width: 60, height: nil, alignment: .leading)
                        TextField("验证的用户密码", text: $password)
                    }.padding(.vertical, 2)
                    HStack{
                        Button(action: saveButton) {
                            Text("保存")
                        }
                    }.padding(.vertical, 20)
                    Spacer()
                }.frame(width: 250, height: 350, alignment: .leading)
                    .padding(.horizontal, 10)
                    .background(Color.white)
                    
            }.padding(.horizontal, 30)
            
            Spacer()
            Button(action: saveButton) {
                Text("关闭")
            }
        }.frame(width: 600, height: 400, alignment: .center)
            .padding(.vertical, 30)
    }
    
    func saveButton() {
        
    }
}

struct ServerConfigEditorWindow_Previews: PreviewProvider {
    static var previews: some View {
        ServerConfigEditorView()
    }
}
