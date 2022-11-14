//
//  SesacTItleView.swift
//  SeSAC_StudyApp
//
//  Created by Seo Jae Hoon on 2022/11/15.
//

import UIKit

final class SesacTitleView: BaseView {
    
    //MARK: Porperty
    lazy var titleLabel = UILabel().then {
        $0.font = UIFont.notoSans(size: 12, family: .Regular)
        $0.textColor = .textColor
        $0.text = "새싹 타이틀"
    }
    
    lazy var mannerButton = GenderButton(title: "좋은 매너", status: .active).then {
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    
    lazy var exactTimeButton = GenderButton(title: "정확한 시간 약속", status: .inactive).then {
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    
    lazy var fastResponseButton = GenderButton(title: "빠른 응답", status: .inactive).then {
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    
    lazy var kindButton = GenderButton(title: "친절한 성격", status: .active).then {
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    
    lazy var skillfullButton = GenderButton(title: "능숙한 실력", status: .active).then {
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    
    lazy var beneficialButton = GenderButton(title: "유익한 시간", status: .active).then {
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    
    lazy var firstHorizontalStackView = UIStackView(arrangedSubviews: [mannerButton, exactTimeButton]).then {
        $0.distribution = .fillEqually
        $0.axis = .horizontal
        $0.spacing = 8
        
        mannerButton.snp.makeConstraints { make in
            make.width.equalTo(150)
        }
        
        exactTimeButton.snp.makeConstraints { make in
            make.width.equalTo(150)
        }
    }
    
    lazy var secondHorizontalStackView = UIStackView(arrangedSubviews: [fastResponseButton, kindButton]).then {
        $0.distribution = .fillEqually
        $0.axis = .horizontal
        $0.spacing = 8
        
        fastResponseButton.snp.makeConstraints { make in
            make.width.equalTo(150)
        }
        
        kindButton.snp.makeConstraints { make in
            make.width.equalTo(150)
        }
    }
    
    lazy var thirdHorizontalStackView = UIStackView(arrangedSubviews: [skillfullButton, beneficialButton]).then {
        $0.distribution = .fillEqually
        $0.axis = .horizontal
        $0.spacing = 8
        
        skillfullButton.snp.makeConstraints { make in
            make.width.equalTo(150)
        }
        
        beneficialButton.snp.makeConstraints { make in
            make.width.equalTo(150)
        }
    }
    
    lazy var verticalStackView = UIStackView(arrangedSubviews: [firstHorizontalStackView, secondHorizontalStackView, thirdHorizontalStackView]).then {
        $0.distribution = .fillEqually
        $0.axis = .vertical
        $0.spacing = 8
    }
    

    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    override func configure() {
        [titleLabel, verticalStackView].forEach { self.addSubview($0) }
    }
    
    override func setConstraints() {
        titleLabel.snp.makeConstraints { make in
            make.top.leading.equalToSuperview()
        }
        
        verticalStackView.snp.makeConstraints { make in
            make.horizontalEdges.bottom.equalToSuperview()
            make.top.equalTo(titleLabel.snp.bottom).offset(16)
        }
    }
}
