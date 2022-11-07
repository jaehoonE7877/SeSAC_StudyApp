//
//  UIFont+CustomFont.swift
//  SeSAC_StudyApp
//
//  Created by Seo Jae Hoon on 2022/11/07.
//

import UIKit

extension UIFont {
    enum Family: String {
        case medium, regular
    }

    static func notoSans(size: CGFloat = 10, family: Family = .regular) -> UIFont {
        return UIFont(name: "NotoSansKR-\(family)", size: size) ?? UIFont.systemFont(ofSize: size)
    }
    
    static func notoSansBoldItalic(size: CGFloat = 10) -> UIFont {
        return UIFont(name: "NotoSans-boldItalic", size: size) ?? UIFont.systemFont(ofSize: size)
    }
    
    static func racingSansOne(size: CGFloat) -> UIFont {
        return UIFont(name: "RacingSansOne-Regular", size: size) ?? UIFont.systemFont(ofSize: size)
    }
}
