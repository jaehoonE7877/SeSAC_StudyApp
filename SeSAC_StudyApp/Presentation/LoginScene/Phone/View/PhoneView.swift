//
//  LoginView.swift
//  SeSAC_StudyApp
//
//  Created by Seo Jae Hoon on 2022/11/08.
//

import UIKit

final class PhoneView: LoginView {
    
    //MARK: Property
    lazy var phoneTextField = UITextField().then {
        $0.setPlaceholder(text: "휴대폰 번호(-없이 숫자만 입력)", color: .gray7)
        $0.addLeftPadding()
        $0.keyboardType = .numberPad
    }
    
    lazy var lineView = UIView().then {
        $0.backgroundColor = .gray3
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .white
    }
    
    override func configure() {
        [phoneTextField, lineView].forEach { self.addSubview($0) }
    }
    
    override func setConstraints() {
        phoneTextField.snp.makeConstraints { make in
            make.top.equalTo(self.mainLabel.snp.bottom).offset(68)
            make.centerX.equalToSuperview()
            make.width.equalTo(self.safeAreaLayoutGuide).multipliedBy(0.92)
            make.height.equalTo(40)
        }
        
        lineView.snp.makeConstraints { make in
            make.top.equalTo(phoneTextField.snp.bottom)
            make.width.equalTo(phoneTextField.snp.width)
            make.centerX.equalToSuperview()
            make.height.equalTo(1)
        }
    }
}
