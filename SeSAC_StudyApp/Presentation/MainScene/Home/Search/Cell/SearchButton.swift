//
//  SearchButton.swift
//  SeSAC_StudyApp
//
//  Created by Seo Jae Hoon on 2022/11/21.
//

import UIKit

final class SearchButton: UILabel {
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    init(){
        super.init(frame: .zero)
    }
    
    private var padding = UIEdgeInsets(top: 5.0, left: 16.0, bottom: 5.0, right: 16.0)
    
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
    
    convenience init(title: String, status: SearchButtonStatus) {
        self.init()
        
        self.text = "\(title)"
        self.font = .notoSans(size: 14, family: .Regular)
        self.layer.cornerRadius = 8

        switch status {
        case .inactive:
            self.textColor = .textColor
            self.backgroundColor = .white
            self.layer.borderWidth = 1
            self.layer.borderColor = UIColor.gray4.cgColor
        case .outline:
            self.backgroundColor = .white
            self.layer.borderWidth = 1
            self.layer.borderColor = UIColor.ssGreen.cgColor
            self.textColor = .ssGreen
        case .redOutline:
            self.backgroundColor = .white
            self.layer.borderWidth = 1
            self.layer.borderColor = UIColor.ssRed.cgColor
            self.textColor = .ssRed
        }
    }
    
    var status: SearchButtonStatus = .inactive {
        didSet {
            switch status {
            case .inactive:
                self.textColor = .textColor
                self.backgroundColor = .white
                self.layer.borderWidth = 1
                self.layer.borderColor = UIColor.gray4.cgColor
            case .outline:
                self.backgroundColor = .white
                self.layer.borderWidth = 1
                self.layer.borderColor = UIColor.ssGreen.cgColor
                self.textColor = .ssGreen
            case .redOutline:
                self.backgroundColor = .white
                self.layer.borderWidth = 1
                self.layer.borderColor = UIColor.ssRed.cgColor
                self.textColor = .ssRed
            }
        }
    }
}
