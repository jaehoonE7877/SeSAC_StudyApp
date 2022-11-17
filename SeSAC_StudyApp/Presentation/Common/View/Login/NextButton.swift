//
//  NextButton.swift
//  SeSAC_StudyApp
//
//  Created by Seo Jae Hoon on 2022/11/08.
//

import UIKit

final class NextButton: UIButton {
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    init(){
        super.init(frame: .zero)
    }
    
    convenience init(title: String, status: NextButtonStatus) {
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
        case .fill:
            self.backgroundColor = .ssGreen
            self.setTitleColor(.white, for: .normal)
        case .outline:
            self.backgroundColor = .white
            self.layer.borderWidth = 1
            self.layer.borderColor = UIColor.gray4.cgColor
            self.setTitleColor(.ssGreen, for: .normal)
        case .cancel:
            self.backgroundColor = .gray2
            self.setTitleColor(.textColor, for: .normal)
        case .disable:
            self.backgroundColor = .gray6
            self.setTitleColor(.gray3, for: .normal)
        }
    }
    
    var status: NextButtonStatus = .inactive {
        didSet {
            switch status {
            case .inactive:
                self.backgroundColor = .white
                self.layer.borderWidth = 1
                self.layer.borderColor = UIColor.gray4.cgColor
                self.setTitleColor(.textColor, for: .normal)
            case .fill:
                self.backgroundColor = .ssGreen
                self.setTitleColor(.white, for: .normal)
            case .outline:
                self.backgroundColor = .white
                self.layer.borderWidth = 1
                self.layer.borderColor = UIColor.gray4.cgColor
                self.setTitleColor(.ssGreen, for: .normal)
            case .cancel:
                self.backgroundColor = .gray2
                self.setTitleColor(.textColor, for: .normal)
            case .disable:
                self.backgroundColor = .gray6
                self.setTitleColor(.gray3, for: .normal)
            }
        }
    }
    
}
