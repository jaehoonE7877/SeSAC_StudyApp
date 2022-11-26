//
//  MatchingStatus.swift
//  SeSAC_StudyApp
//
//  Created by Seo Jae Hoon on 2022/11/26.
//

import Foundation

enum MatchingStatus {
    case normal
    case matching
    case matched 
}

extension MatchingStatus {
    var image: String {
        switch self {
        case .normal:
            return "map_default"
        case .matching:
            return "map_matching"
        case .matched:
            return "map_matched"
        }
    }
}
