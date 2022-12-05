//
//  BuyButton.swift
//  SeSAC_StudyApp
//
//  Created by Seo Jae Hoon on 2022/12/05.
//

import UIKit

enum BuyButtonStatus {
    case yet(title: String = "고유")
    case lowCost(cost: String = "1,200")
    case hightCost(cost: String = "2,500")
}

final class BuyButton: UIButton {
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    init(){
        super.init(frame: .zero)
    }
    
    convenience init(status: BuyButtonStatus) {
        self.init()
        
        self.titleLabel?.font = .notoSans(size: 12, family: .Medium)
        self.layer.cornerRadius = 30
        
        switch status {
        case .yet(let title):
            self.setTitle(title, for: .normal)
            self.setTitleColor(.white, for: .normal)
            self.backgroundColor = .ssGreen
        case .lowCost(let cost):
            self.setTitle(cost, for: .normal)
            self.backgroundColor = .gray2
            self.setTitleColor(.gray7, for: .normal)
        case .hightCost(let cost):
            self.setTitle(cost, for: .normal)
            self.backgroundColor = .gray2
            self.setTitleColor(.gray7, for: .normal)
        }
        
    }
    
    var status: BuyButtonStatus = .yet() {
        didSet {
            switch status {
            case .yet(let title):
                self.setTitle(title, for: .normal)
                self.setTitleColor(.white, for: .normal)
                self.backgroundColor = .ssGreen
            case .lowCost(let cost):
                self.setTitle(cost, for: .normal)
                self.backgroundColor = .gray2
                self.setTitleColor(.gray7, for: .normal)
            case .hightCost(let cost):
                self.setTitle(cost, for: .normal)
                self.backgroundColor = .gray2
                self.setTitleColor(.gray7, for: .normal)
            }
        }
    }
}
