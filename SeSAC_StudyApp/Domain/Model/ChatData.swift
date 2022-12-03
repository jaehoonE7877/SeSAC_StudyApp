//
//  SeSACChat.swift
//  SeSAC_StudyApp
//
//  Created by Seo Jae Hoon on 2022/11/28.
//

import Foundation

struct ChatData {
    let id, to, from, chat: String
    let createdAt: String
    
    init(id: String = "" , to: String = "", from: String = "", chat: String = "", createdAt: String = "") {
        self.id = id
        self.to = to
        self.from = from
        self.chat = chat
        self.createdAt = createdAt
    }
}
