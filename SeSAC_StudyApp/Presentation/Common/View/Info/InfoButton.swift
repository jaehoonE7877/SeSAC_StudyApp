//
//  GenderButton.swift
//  SeSAC_StudyApp
//
//  Created by Seo Jae Hoon on 2022/11/15.
//

import UIKit

final class InfoButton: UIButton {
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    init(){
        super.init(frame: .zero)
    }
    
    convenience init(title: String, status: InfoButtonStatus) {
        self.init()
        
        self.setTitle(title, for: .normal)
        self.titleLabel?.font = .notoSans(size: 14, family: .Regular)
        self.layer.cornerRadius = 8
        
        switch status {
        case .inactive:
            self.setTitleColor(.textColor, for: .normal)
            self.backgroundColor = .white
            self.layer.borderWidth = 1
            self.layer.borderColor = UIColor.gray4.cgColor
        case .active:
            self.backgroundColor = .ssGreen
            self.setTitleColor(.white, for: .normal)
        }
        
    }
    
    var status: InfoButtonStatus = .inactive {
        didSet {
            switch status {
            case .inactive:
                self.setTitleColor(.textColor, for: .normal)
                self.backgroundColor = .white
                self.layer.borderWidth = 1
                self.layer.borderColor = UIColor.gray4.cgColor
            case .active:
                self.backgroundColor = .ssGreen
                self.setTitleColor(.white, for: .normal)
            }
        }
    }
}
