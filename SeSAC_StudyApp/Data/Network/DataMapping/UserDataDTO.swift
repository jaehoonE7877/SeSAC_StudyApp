//
//  LoginModel.swift
//  SeSAC_StudyApp
//
//  Created by Seo Jae Hoon on 2022/11/09.
//

import Foundation

struct UserDataDTO: Codable {
    let id: String
    let v: Int
    let uid, phoneNumber, email, fcMtoken: String
    let nick, birth: String
    let gender: Int
    let study: String
    let comment: [String]
    let reputation: [Int]
    let sesac: Int
    let sesacCollection: [Int]
    let background: Int
    let backgroundCollection: [Int]
    let purchaseToken, transactionID, reviewedBefore: [String]
    let reportedNum: Int
    let reportedUser: [String]
    let dodgepenalty, dodgeNum, ageMin, ageMax: Int
    let searchable: Int
    let createdAt: String

    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case v = "__v"
        case uid, phoneNumber, email
        case fcMtoken = "FCMtoken"
        case nick, birth, gender, study, comment, reputation, sesac, sesacCollection, background, backgroundCollection, purchaseToken
        case transactionID = "transactionId"
        case reviewedBefore, reportedNum, reportedUser, dodgepenalty, dodgeNum, ageMin, ageMax, searchable, createdAt
    }
    
    func toDomain() -> SeSACInfo {
        return SeSACInfo(
            background: self.background,
            sesac: self.sesac,
            nick: self.nick,
            reputation: self.reputation,
            comment: self.comment,
            gender: self.gender,
            study: self.study,
            searchable: self.searchable,
            ageMin: self.ageMin,
            ageMax: self.ageMax)
    }
    
    func toDomain() -> SeSACImage {
        return SeSACImage(
            sesac: self.sesac,
            sesacCollection: self.sesacCollection,
            background: self.background,
            backgroundCollection: self.backgroundCollection)
    }
}
