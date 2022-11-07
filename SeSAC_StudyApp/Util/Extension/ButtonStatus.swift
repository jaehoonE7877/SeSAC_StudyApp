//
//  ButtonStatus.swift
//  SeSAC_StudyApp
//
//  Created by Seo Jae Hoon on 2022/11/08.
//

import UIKit

enum ButtonStatus {
    
    case inactive
    case fill
    case outline
    case cancel
    case disable
}

extension ButtonStatus {
    
    static func createNextButton(title: String, status: ButtonStatus = fill) -> UIButton {
        
        let button = UIButton()
        button.setTitle(title, for: .normal)
        button.titleLabel?.font = .notoSans(size: 14, family: .Regular)
        button.layer.cornerRadius = 8
        
        switch status {
        case .inactive:
            button.backgroundColor = .white
            button.layer.borderWidth = 1
            button.layer.borderColor = UIColor.gray4.cgColor
            button.titleLabel?.textColor = .black
            return button
        case .fill:
            button.backgroundColor = .ssGreen
            button.titleLabel?.textColor = .white
            return button
        case .outline:
            button.backgroundColor = .white
            button.layer.borderWidth = 1
            button.layer.borderColor = UIColor.gray4.cgColor
            button.titleLabel?.textColor = .ssGreen
            return button
        case .cancel:
            button.backgroundColor = .gray2
            button.titleLabel?.textColor = .black
            return button
        case .disable:
            button.backgroundColor = .gray6
            button.titleLabel?.textColor = .gray3
            return button
        }
    }
    
}
