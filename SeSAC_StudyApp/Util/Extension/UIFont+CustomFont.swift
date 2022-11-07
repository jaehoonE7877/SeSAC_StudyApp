//
//  UIFont+CustomFont.swift
//  SeSAC_StudyApp
//
//  Created by Seo Jae Hoon on 2022/11/07.
//

import UIKit

extension UIFont {
    enum Family: String {
        case Medium, Regular
    }

    static func notoSans(size: CGFloat = 14, family: Family = .Regular) -> UIFont {
        return UIFont(name: "NotoSansKR-\(family)", size: size) ?? UIFont.systemFont(ofSize: size)
    }
    
}
