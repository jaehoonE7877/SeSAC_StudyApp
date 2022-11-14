//
//  GenderButton.swift
//  SeSAC_StudyApp
//
//  Created by Seo Jae Hoon on 2022/11/15.
//

import UIKit

final class GenderButton: UIButton {
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    init(){
        super.init(frame: .zero)
    }
    
    convenience init(title: String, status: GenderButtonStatus) {
        self.init()
        
        self.setTitle(title, for: .normal)
        self.titleLabel?.font = .notoSans(size: 14, family: .Regular)
        self.layer.cornerRadius = 8
        
        switch status {
        case .inactive:
            self.backgroundColor = .white
            self.layer.borderWidth = 1
            self.layer.borderColor = UIColor.gray4.cgColor
            self.titleLabel?.textColor = .textColor
        case .active:
            self.backgroundColor = .ssGreen
            self.titleLabel?.textColor = .white
        }
        
    }
    
    var status: GenderButtonStatus = .inactive {
        didSet {
            switch status {
            case .inactive:
                self.backgroundColor = .white
                self.layer.borderWidth = 1
                self.layer.borderColor = UIColor.gray4.cgColor
                self.titleLabel?.textColor = .textColor
            case .active:
                self.backgroundColor = .ssGreen
                self.titleLabel?.textColor = .white
            }
        }
    }
}
