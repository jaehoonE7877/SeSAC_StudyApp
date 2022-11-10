//
//  BirthView.swift
//  SeSAC_StudyApp
//
//  Created by Seo Jae Hoon on 2022/11/10.
//

import UIKit

final class BirthView: LoginView {
    
    //MARK: Property
    lazy var yearView = BirthItemView().then {
        $0.dateTextField.setPlaceholder(text: "1990", color: .gray7)
        $0.dateLabel.text = "년"
    }
    
    lazy var monthView = BirthItemView().then {
        $0.dateTextField.setPlaceholder(text: "1", color: .gray7)
        $0.dateLabel.text = "월"
    }
    
    lazy var dayView = BirthItemView().then {
        $0.dateTextField.setPlaceholder(text: "1", color: .gray7)
        $0.dateLabel.text = "일"
    }
    
    lazy var horizontalStackView = UIStackView(arrangedSubviews: [yearView, monthView, dayView]).then {
        $0.distribution = .fillEqually
        $0.axis = .horizontal
        $0.spacing = 20
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
    }
    
    override func configure() {
        super.configure()
        mainLabel.text = "생년월일을 알려주세요"
        mainButton.setTitle("다음", for: .normal)
        self.addSubview(horizontalStackView)
    }
    
    override func setConstraints() {
        super.setConstraints()
        mainLabel.snp.makeConstraints { make in
            make.centerY.equalTo(self.safeAreaLayoutGuide).multipliedBy(0.48)
            make.centerX.equalToSuperview()
        }
        
        horizontalStackView.snp.makeConstraints { make in
            make.leading.equalTo(mainButton)
            make.trailing.equalTo(mainButton).offset(-12)
            make.centerY.equalTo(self.safeAreaLayoutGuide).multipliedBy(0.8)
            make.centerX.equalToSuperview()
        }
    }
}
