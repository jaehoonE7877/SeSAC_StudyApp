//
//  MatchDataDTO.swift
//  SeSAC_StudyApp
//
//  Created by Seo Jae Hoon on 2022/11/23.
//

import Foundation

struct MatchDataDTO: Codable {
    let dodged, matched, reviewed: Int
    let matchedNick, matchedUid: String
}
