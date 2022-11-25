//
//  MatchButton.swift
//  SeSAC_StudyApp
//
//  Created by Seo Jae Hoon on 2022/11/23.
//

enum MatchButtonStatus {
    case accept
    case require
}

import UIKit

final class MatchButton: UIButton {
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    init(){
        super.init(frame: .zero)
    }
    
    convenience init(status: MatchButtonStatus) {
        self.init()
        
        self.titleLabel?.font = .notoSans(size: 14, family: .Regular)
        self.layer.cornerRadius = 8
        
        switch status {
        case .accept:
            self.setTitle("수락하기", for: .normal)
            self.setTitleColor(.white, for: .normal)
            self.backgroundColor = .ssBlue
        case .require:
            self.setTitle("요청하기", for: .normal)
            self.setTitleColor(.white, for: .normal)
            self.backgroundColor = .ssRed
        }
        
    }
}
