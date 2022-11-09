//
//  NicknameView.swift
//  SeSAC_StudyApp
//
//  Created by Seo Jae Hoon on 2022/11/09.
//

import UIKit

final class NicknameView: LoginView {
    
    //MARK: Property textfield, lineview
    lazy var nicknameTextField = UITextField().then {
        $0.setPlaceholder(text: "10자 이내로 입력", color: .gray7)
        $0.addLeftPadding()
    }
    
    lazy var lineView = UIView().then {
        $0.backgroundColor = .gray3
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    override func configure() {
        super.configure()
        mainButton.setTitle("다음", for: .normal)
        mainLabel.text = "닉네임을 입력해주세요"
        [nicknameTextField, lineView].forEach { self.addSubview($0) }
    }
    
    override func setConstraints() {
        super.setConstraints()
        
        mainLabel.snp.makeConstraints { make in
            make.centerY.equalTo(self.safeAreaLayoutGuide).multipliedBy(0.48)
            make.centerX.equalToSuperview()
        }
        
        nicknameTextField.snp.makeConstraints { make in
            make.centerY.equalTo(self.safeAreaLayoutGuide).multipliedBy(0.8)
            make.centerX.equalToSuperview()
            make.width.equalTo(self.safeAreaLayoutGuide).multipliedBy(0.92)
            make.height.equalTo(40)
        }
        
        lineView.snp.makeConstraints { make in
            make.top.equalTo(nicknameTextField.snp.bottom)
            make.width.equalTo(nicknameTextField)
            make.centerX.equalToSuperview()
            make.height.equalTo(1)
        }
        
    }
    
}

