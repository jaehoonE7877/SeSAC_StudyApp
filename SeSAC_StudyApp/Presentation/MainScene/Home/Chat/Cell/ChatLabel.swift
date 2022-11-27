//
//  ChatLabel.swift
//  SeSAC_StudyApp
//
//  Created by Seo Jae Hoon on 2022/11/27.
//

import UIKit

enum ChatStatus {
    case my
    case your
}

final class Chatlabel: UILabel {
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    init(){
        super.init(frame: .zero)
    }
    
    private var padding = UIEdgeInsets(top: 10.0, left: 16.0, bottom: 10.0, right: 16.0)
    
    convenience init(padding: UIEdgeInsets) {
        self.init()
        self.padding = padding
    }
    
    override func drawText(in rect: CGRect) {
        super.drawText(in: rect.inset(by: padding))
    }
    
    //안의 내재되어있는 콘텐트의 사이즈에 따라 height와 width에 padding값을 더해줌
    override var intrinsicContentSize: CGSize {
        var contentSize = super.intrinsicContentSize
        contentSize.height += padding.top + padding.bottom
        contentSize.width += padding.left + padding.right
        
        return contentSize
    }
    
    convenience init(style: ChatStatus){
        self.init()
        
        self.font = .notoSans(size: 14, family: .Regular)
        self.textColor = .textColor
        self.textAlignment = .center
        self.numberOfLines = 0
        self.layer.cornerRadius = 8
        
        switch style {
        case .my:
            self.layer.borderWidth = 1
            self.layer.cornerRadius = 8
            self.layer.borderColor = UIColor.gray4.cgColor
            self.backgroundColor = .systemBackground
        case .your:
            self.layer.cornerRadius = 8
            self.backgroundColor = .ssWhiteGreen
        }
    }
    
    var status: ChatStatus = .my {
        didSet {
            switch status {
            case .my:
                self.layer.borderWidth = 1
                self.layer.borderColor = UIColor.gray4.cgColor
                self.backgroundColor = .systemBackground
            case .your:
                self.backgroundColor = .ssWhiteGreen
            }
        }
    }
}
