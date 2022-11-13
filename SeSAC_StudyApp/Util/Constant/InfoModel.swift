//
//  Info.swift
//  SeSAC_StudyApp
//
//  Created by Seo Jae Hoon on 2022/11/13.
//

import UIKit
import RxDataSources

struct InfoModel {
    var mainImage: UIImage
    var detailImage: UIImage?
    var title: String
}

enum Info : Int {
    case personal, notice, faq, qna, alarm, permit
    
    var title: String {
        switch self {
        case .personal:
            return "김새싹"
        case .notice:
            return "공지사항"
        case .faq:
            return "자주 묻는 질문"
        case .qna:
            return "1:1 문의"
        case .alarm:
            return "알림 설정"
        case .permit:
            return "이용약관"
        }
    }
    
    var image: UIImage {
        switch self {
        case .personal:
            return UIImage(named: "profile_img")!
        case .notice:
            return UIImage(named: "notice")!
        case .faq:
            return UIImage(named: "faq")!
        case .qna:
            return UIImage(named: "qna")!
        case .alarm:
            return UIImage(named: "setting_alarm")!
        case .permit:
            return UIImage(named: "permit")!
        }
    }
}

struct InfoSectionModel {
    var items: [Item]
}

extension InfoSectionModel: SectionModelType {
    
    typealias Item = InfoModel
    
    init(original: InfoSectionModel, items: [Item]) {
        self = original
        self.items = items
      }
}
