//
//  EmailView.swift
//  SeSAC_StudyApp
//
//  Created by Seo Jae Hoon on 2022/11/10.
//

import UIKit

final class EmailView: LoginView {
    
    //MARK: Property
    lazy var subLabel = UILabel().then {
        $0.text = "휴대폰 번호 변경 시 인증을 위해 사용해요"
        $0.textColor = .gray7
        $0.textAlignment = .center
        $0.font = UIFont.notoSans(size: 16, family: .Regular)
    }
    
    lazy var emailTextField = UITextField().then {
        $0.setPlaceholder(text: "SeSAC@email.com", color: .gray7)
        $0.addLeftPadding()
        $0.becomeFirstResponder()
    }
    
    lazy var lineView = UIView().then {
        $0.backgroundColor = .gray3
    }
    
    lazy var verticalStackView = UIStackView(arrangedSubviews: [mainLabel, subLabel]).then {
        $0.distribution = .fillProportionally
        $0.axis = .vertical
        $0.spacing = 8
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    override func configure() {
        super.configure()
        mainButton.setTitle("다음", for: .normal)
        mainLabel.text = "이메일을 입력해 주세요"
        [verticalStackView, emailTextField, lineView].forEach { self.addSubview($0) }
    }
    
    override func setConstraints() {
        super.setConstraints()
        
        verticalStackView.snp.makeConstraints { make in
            make.centerY.equalTo(self.safeAreaLayoutGuide).multipliedBy(0.48)
            make.centerX.equalToSuperview()
        }
        
        emailTextField.snp.makeConstraints { make in
            make.centerY.equalTo(self.safeAreaLayoutGuide).multipliedBy(0.8)
            make.centerX.equalToSuperview()
            make.width.equalTo(self.safeAreaLayoutGuide).multipliedBy(0.92)
            make.height.equalTo(40)
        }
        
        lineView.snp.makeConstraints { make in
            make.top.equalTo(emailTextField.snp.bottom)
            make.width.equalTo(emailTextField)
            make.centerX.equalToSuperview()
            make.height.equalTo(1)
        }
        
    }
}
