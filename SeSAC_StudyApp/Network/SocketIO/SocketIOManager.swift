//
//  SocketIOManager.swift
//  SeSAC_StudyApp
//
//  Created by Seo Jae Hoon on 2022/11/30.
//

import Foundation
import SocketIO

final class SocketIOManager {
    
    static let shared = SocketIOManager()
    
    var manager: SocketManager!
    
    var socket: SocketIOClient!
    
    private init() {
        //어디와 통신할 지
        manager = SocketManager(socketURL: URL(string: "http://api.sesac.co.kr:1210/")!, config: [
           // .log(true),
            .forceWebsockets(true)
        ])
        // socket이 중요한 이유
        // defaultSocket으로 통신하면 오픈카톡 같이 여러명이 소켓 통신하는 것
        // 1:1 개인 통신 하려면 / 뒤에 어떤 방인지 명시해줄 것
        socket = manager.defaultSocket  // http://api.sesac.co.kr:2022/ 여기로 통신을 하겠다!
        /// 아래부터는 연결이 되고나서의 기능
        // 연결
        // 소켓 연결 메서드
        socket.on(clientEvent: .connect) { data, ack in
            print("Socket is connected", data, ack)
            print("=================\(data)====================")
            self.socket.emit("changesocketid", "myUID")
        }
        
        // 연결 해제
        socket.on(clientEvent: .disconnect) { data, ack in
            print("SOCKET IS DISCONNECTED", data, ack)
        }
        
        // 이벤트 수신
        socket.on("chat") { dataArray, ack in
            print("SESAC RECEIVED", dataArray, ack)
            
            let data = dataArray[0] as! NSDictionary
            let id = data["_id"] as! String
            let chat = data["chat"] as! String
            let createdAt = data["createdAt"] as! String
            let from = data["from"] as! String
            let to = data["to"] as! String
            
            print("CHECK >>>", chat , id , createdAt)
            NotificationCenter.default.post(name: NSNotification.Name("getMessage"), object: self, userInfo: ["_id": id, "chat": chat, "createdAt": createdAt, "from": from, "to": to])
        }
    }

    func establishConnection() {
        socket.connect()
    }

    func closeConnection() {
        socket.disconnect()
    }
    
}
