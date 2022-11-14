//
//  DetailInfoModel.swift
//  SeSAC_StudyApp
//
//  Created by Seo Jae Hoon on 2022/11/15.
//

import Foundation
import RxDataSources


struct DetailInfoModel {
    var title: String?
    
}

struct DetailInfoSectionModel {
    var items: [Item]
}

extension DetailInfoSectionModel: SectionModelType {
    
    typealias Item = DetailInfoModel
    
    init(original: DetailInfoSectionModel, items: [Item]) {
        self = original
        self.items = items
      }
}
