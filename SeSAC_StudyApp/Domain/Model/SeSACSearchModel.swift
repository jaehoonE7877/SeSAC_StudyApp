//
//  SeSACSearchModel.swift
//  SeSAC_StudyApp
//
//  Created by Seo Jae Hoon on 2022/11/21.
//

import Foundation

struct SeSACSearchModel {
    let lat, long: Double
    let gender, type, background: Int
    
    init(
        lat: Double = 0,
        long: Double = 0,
        gender: Int = 0,
        type: Int = 0,
        background: Int = 0
    ){
        self.lat = lat
        self.long = long
        self.gender = gender
        self.type = type
        self.background = background
    }
    
}
