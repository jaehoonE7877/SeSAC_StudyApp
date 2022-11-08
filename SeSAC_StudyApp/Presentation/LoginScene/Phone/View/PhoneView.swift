//
//  LoginView.swift
//  SeSAC_StudyApp
//
//  Created by Seo Jae Hoon on 2022/11/08.
//

import UIKit

final class PhoneView: BaseView {
    
    //MARK: Property
    lazy var mainLabel = UILabel().then {
        $0.text = "새싹 서비스 이용을 위해\n휴대폰 번호를 입력해 주세요"
        $0.numberOfLines = 2
        $0.font = UIFont.notoSans(size: 20, family: .Regular)
        $0.textAlignment = .center
    }
    
    lazy var phoneTextField = UITextField().then {
        $0.setPlaceholder(text: "휴대폰 번호(-없이 숫자만 입력)", color: .gray7)
        $0.addLeftPadding()
        $0.keyboardType = .numberPad
    }
    
    let lineView = UIView().then {
        $0.backgroundColor = .gray3
    }
    
    let mainButton = NextButton(title: "인증 문자 받기", status: .disable).then {
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .white
    }
    
    override func configure() {
        [mainLabel, phoneTextField, lineView, mainButton].forEach { self.addSubview($0) }
    }
    
    override func setConstraints() {
        mainLabel.snp.makeConstraints { make in
            make.top.equalTo(self.safeAreaLayoutGuide).offset(125)
            make.centerX.equalToSuperview()
        }
        
        phoneTextField.snp.makeConstraints { make in
            make.top.equalTo(mainLabel.snp.bottom).offset(68)
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
        
        mainButton.snp.makeConstraints { make in
            make.top.equalTo(lineView.snp.bottom).offset(72)
            make.width.equalTo(lineView.snp.width)
            make.centerX.equalToSuperview()
            make.height.equalTo(48)
        }
    }
    
}
