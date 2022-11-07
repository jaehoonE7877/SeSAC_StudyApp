//
//  UITextField+AttributedString.swift
//  SeSAC_StudyApp
//
//  Created by Seo Jae Hoon on 2022/11/08.
//

import UIKit

public extension UITextField {
    func setPlaceholder(text:String, color: UIColor){
        attributedPlaceholder = NSAttributedString(
            string: text,
            attributes: [
                .foregroundColor: color,
                .font: UIFont.notoSans(size: 14, family: .Regular)
            ].compactMapValues{ $0 }
        )
    }
}
