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
    
    convenience init(title: String, status: ButtonStatus) {
        self.init()
        
        self.setTitle(title, for: .normal)
        self.titleLabel?.font = .notoSans(size: 14, family: .Regular)
        self.layer.cornerRadius = 8

        switch status {
        case .inactive:
            self.backgroundColor = .white
            self.layer.borderWidth = 1
            self.layer.borderColor = UIColor.gray4.cgColor
            self.titleLabel?.textColor = .black
        case .fill:
            self.backgroundColor = .ssGreen
            self.titleLabel?.textColor = .white
        case .outline:
            self.backgroundColor = .white
            self.layer.borderWidth = 1
            self.layer.borderColor = UIColor.gray4.cgColor
            self.titleLabel?.textColor = .ssGreen
        case .cancel:
            self.backgroundColor = .gray2
            self.titleLabel?.textColor = .black
        case .disable:
            self.backgroundColor = .gray6
            self.titleLabel?.textColor = .gray3
        }
    }
    
    var status: ButtonStatus = .inactive {
        didSet {
            switch status {
            case .inactive:
                self.backgroundColor = .white
                self.layer.borderWidth = 1
                self.layer.borderColor = UIColor.gray4.cgColor
                self.titleLabel?.textColor = .black
            case .fill:
                self.backgroundColor = .ssGreen
                self.titleLabel?.textColor = .white
            case .outline:
                self.backgroundColor = .white
                self.layer.borderWidth = 1
                self.layer.borderColor = UIColor.gray4.cgColor
                self.titleLabel?.textColor = .ssGreen
            case .cancel:
                self.backgroundColor = .gray2
                self.titleLabel?.textColor = .black
            case .disable:
                self.backgroundColor = .gray6
                self.titleLabel?.textColor = .gray3
            }
        }
    }
    
}
