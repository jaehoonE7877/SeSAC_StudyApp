//
//  SeSACCardSectionModel.swift
//  SeSAC_StudyApp
//
//  Created by Seo Jae Hoon on 2022/11/23.
//

import Foundation
import RxDataSources

struct SeSACCardSectionModel {
    var items: [Item]
}

extension SeSACCardSectionModel: SectionModelType {
    
    typealias Item = SeSACCardModel
    
    init(original: SeSACCardSectionModel, items: [Item]) {
        self = original
        self.items = items
      }
}
