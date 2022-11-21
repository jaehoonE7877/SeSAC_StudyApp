//
//  SeSACUserData.swift
//  SeSAC_StudyApp
//
//  Created by Seo Jae Hoon on 2022/11/21.
//

import Foundation

struct SeSACUserDataDTO: Codable {
    let fromQueueDB, fromQueueDBRequested: [FromQueueDB]
    let fromRecommend: [String]
}

// MARK: - FromQueueDB
struct FromQueueDB: Codable {
    let uid, nick: String
    let lat, long: Double
    let reputation: [Int]
    let studylist, reviews: [String]
    let gender, type, sesac, background: Int
    
    func toDomain() -> SeSACSearchModel {
        return SeSACSearchModel(
            lat: self.lat,
            long: self.long,
            gender: self.gender,
            type: self.type,
            background: self.background)
    }
}
