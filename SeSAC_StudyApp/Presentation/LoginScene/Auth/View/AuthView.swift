//
//  AuthView.swift
//  SeSAC_StudyApp
//
//  Created by Seo Jae Hoon on 2022/11/08.
//

import UIKit

final class AuthView: LoginView {
    
    //MARK: Property
    lazy var authTextField = UITextField().then {
        $0.setPlaceholder(text: "인증번호 입력", color: .gray7)
        $0.addLeftPadding()
        $0.keyboardType = .numberPad
        $0.textContentType = .oneTimeCode
    }
    
    lazy var lineView = UIView().then {
        $0.backgroundColor = .gray3
    }
    
    lazy var timeLabel = UILabel().then {
        $0.text = "01:00"
        $0.font = UIFont.notoSans(size: 14, family: .Medium)
        $0.textColor = .ssGreen
    }
    
    lazy var resendButton = NextButton(title: "재전송", status: .fill).then {
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    
    lazy var horizontalStackView = UIStackView(arrangedSubviews: [authTextField, resendButton]).then { [weak self] view in
        guard let self = self else { return }
        view.distribution = .fillProportionally
        view.axis = .horizontal
        view.spacing = 8
        
        self.resendButton.snp.makeConstraints { make in
            make.width.equalTo(72)
            make.height.equalTo(40)
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    override func configure() {
        mainButton.setTitle("인증하고 시작하기", for: .normal)
        mainLabel.text = "인증번호가 문자로 전송되었어요"
        mainLabel.numberOfLines = 1
        [mainLabel, mainButton, horizontalStackView, lineView, timeLabel].forEach { self.addSubview($0) }
    }
    
    override func setConstraints() {
        super.setConstraints()
        
        mainLabel.snp.makeConstraints { make in
            make.centerY.equalTo(self.safeAreaLayoutGuide).multipliedBy(0.48)
            make.centerX.equalToSuperview()
        }
        
        horizontalStackView.snp.makeConstraints { make in
            make.centerY.equalTo(self.safeAreaLayoutGuide).multipliedBy(0.8)
            make.centerX.equalTo(mainButton.snp.centerX)
            make.width.equalTo(mainButton)
            make.height.equalTo(40)
        }
        
        lineView.snp.makeConstraints { make in
            make.top.equalTo(authTextField.snp.bottom)
            make.width.equalTo(authTextField)
            make.centerX.equalTo(authTextField.snp.centerX)
            make.height.equalTo(1)
        }
        
        timeLabel.snp.makeConstraints { make in
            make.trailing.top.bottom.equalTo(authTextField).inset(12)
        }
    }
    
}
