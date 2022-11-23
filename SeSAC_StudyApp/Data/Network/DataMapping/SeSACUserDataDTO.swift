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
    
//    func toDomain() -> SeSACSearchModel {
//        return SeSACSearchModel(
//            lat: self.lat,
//            long: self.long,
//            gender: self.gender,
//            sesac: self.sesac,
//            background: self.background)
//    }
    
    func toDomain() -> SeSACCardModel {
        return SeSACCardModel(
            background: self.background,
            sesac: self.sesac,
            nick: self.nick,
            reputation: self.reputation,
            reviews: self.reviews,
            studylist: self.studylist)
    }
}
