//
//  SeSACChatVO.swift
//  SeSAC_StudyApp
//
//  Created by Seo Jae Hoon on 2022/11/28.
//

import Foundation

struct SeSACChatVO: Codable {
    let id, to, from, chat: String
    let createdAt: String

    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case to, from, chat, createdAt
    }
    
    func toDomain() -> SeSACChat{
        return SeSACChat(
            id: self.id,
            to: self.to,
            from: self.from,
            chat: self.chat,
            createdAt: self.createdAt)
    }
}
