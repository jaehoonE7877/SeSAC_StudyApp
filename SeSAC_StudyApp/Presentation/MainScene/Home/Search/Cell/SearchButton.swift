//
//  SearchButton.swift
//  SeSAC_StudyApp
//
//  Created by Seo Jae Hoon on 2022/11/21.
//

import UIKit

final class SearchButton: UIButton {
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    init(){
        super.init(frame: .zero)
    }
    
    convenience init(title: String, status: SearchButtonStatus) {
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
        case .outline:
            self.backgroundColor = .white
            self.layer.borderWidth = 1
            self.layer.borderColor = UIColor.ssGreen.cgColor
            self.setTitleColor(.ssGreen, for: .normal)
        case .redOutline:
            self.backgroundColor = .white
            self.layer.borderWidth = 1
            self.layer.borderColor = UIColor.ssRed.cgColor
            self.setTitleColor(.ssRed, for: .normal)
        }
    }
    
    var status: SearchButtonStatus = .inactive {
        didSet {
            switch status {
            case .inactive:
                self.backgroundColor = .white
                self.layer.borderWidth = 1
                self.layer.borderColor = UIColor.gray4.cgColor
                self.setTitleColor(.textColor, for: .normal)
            case .outline:
                self.backgroundColor = .white
                self.layer.borderWidth = 1
                self.layer.borderColor = UIColor.gray4.cgColor
                self.setTitleColor(.ssGreen, for: .normal)
            case .redOutline:
                self.backgroundColor = .white
                self.layer.borderWidth = 1
                self.layer.borderColor = UIColor.ssRed.cgColor
                self.setTitleColor(.ssRed, for: .normal)
            }
        }
    }
}
