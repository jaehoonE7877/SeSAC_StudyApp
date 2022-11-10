//
//  LoginView.swift
//  SeSAC_StudyApp
//
//  Created by Seo Jae Hoon on 2022/11/08.
//

import UIKit

class LoginView: BaseView {
    
    //MARK: Property
    lazy var mainLabel = UILabel().then {
        $0.text = "새싹 서비스 이용을 위해\n휴대폰 번호를 입력해 주세요"
        $0.numberOfLines = 2
        $0.font = UIFont.notoSans(size: 20, family: .Regular)
        $0.textAlignment = .center
    }
    
    lazy var mainButton = NextButton(title: "인증 문자 받기", status: .disable).then {
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
    }
    
    override func configure() {
        [mainLabel, mainButton].forEach { self.addSubview($0) }
    }
    
    override func setConstraints() {
        mainButton.snp.makeConstraints { make in
            make.centerY.equalTo(self.safeAreaLayoutGuide).multipliedBy(1.04)
            make.width.equalTo(self.safeAreaLayoutGuide).multipliedBy(0.92)
            make.centerX.equalToSuperview()
            make.height.equalTo(48)
        }
    }
}
