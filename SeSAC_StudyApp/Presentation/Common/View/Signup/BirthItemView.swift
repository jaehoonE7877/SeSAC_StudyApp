//
//  BirthItemView.swift
//  SeSAC_StudyApp
//
//  Created by Seo Jae Hoon on 2022/11/10.
//

import UIKit

final class BirthItemView: BaseView {
    
    //MARK: Property
    lazy var dateTextField = UITextField().then {
        $0.addLeftPadding()
    }
    
    lazy var lineView = UIView().then {
        $0.backgroundColor = .gray3
    }
    
    lazy var dateLabel = UILabel().then {
        $0.font = UIFont.notoSans(size: 16, family: .Regular)
        $0.textColor = .textColor
    }
    
    override init(frame: CGRect) {
        super.init(frame: CGRect(x: 0, y: 0, width: 99, height: 48))
    }
    
    override func configure() {
        [dateTextField, lineView, dateLabel].forEach { self.addSubview($0) }
    }
    
    override func setConstraints() {
        
        dateTextField.snp.makeConstraints { make in
            make.top.leading.bottom.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.92)
        }
        
        lineView.snp.makeConstraints { make in
            make.top.equalTo(dateTextField.snp.bottom)
            make.width.equalTo(dateTextField.snp.width)
            make.height.equalTo(1)
            make.centerX.equalTo(dateTextField.snp.centerX)
        }
        
        dateLabel.snp.makeConstraints { make in
            make.centerY.equalTo(dateTextField)
            make.leading.equalTo(dateTextField.snp.trailing).offset(4)
        }
        
    }
    
}
