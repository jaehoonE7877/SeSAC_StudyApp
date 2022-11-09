//
//  BirthView.swift
//  SeSAC_StudyApp
//
//  Created by Seo Jae Hoon on 2022/11/10.
//

import UIKit

final class BirthView: LoginView {
    
    //MARK: Property
    
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    override func configure() {
        mainLabel.text = "생년월일을 알려주세요"
        mainButton.setTitle("다음", for: .normal)
    }
    
    override func setConstraints() {
        
    }
}
