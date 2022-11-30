//
//  ChatSectionModel.swift
//  SeSAC_StudyApp
//
//  Created by Seo Jae Hoon on 2022/11/28.
//

import Foundation
import RxDataSources

struct ChatSectionModel {
    var items: [Item]
}

extension ChatSectionModel: SectionModelType {
    
    typealias Item = ChatData
    
    init(original: ChatSectionModel, items: [Item]) {
        self = original
        self.items = items
      }
}
