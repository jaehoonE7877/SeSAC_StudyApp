//
//  SeSACCardModel.swift
//  SeSAC_StudyApp
//
//  Created by Seo Jae Hoon on 2022/11/23.
//

import Foundation

struct SeSACCardModel {
    var background: Int
    var sesac: Int
    var nick: String
    var reputation: [Int]
    var reviews: [String]
    var studylist: [String]
    
    init(
        background: Int = 0,
        sesac: Int = 0,
        nick: String = "",
        reputation: [Int] = [],
        reviews: [String] = [],
        studylist: [String] = []
    ){
        self.background = background
        self.sesac = sesac
        self.nick = nick
        self.reputation = reputation
        self.reviews = reviews
        self.studylist = studylist
    }
}
