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
    
    let mannerButton = InfoButton(title: "좋은 매너", status: .active).then {
        $0.tag = 0
    }
    
    let exactTimeButton = InfoButton(title: "정확한 시간 약속", status: .inactive).then {
        $0.tag = 1
    }
    
    let fastResponseButton = InfoButton(title: "빠른 응답", status: .inactive).then {
        $0.tag = 2
    }
    
    let kindButton = InfoButton(title: "친절한 성격", status: .active).then {
        $0.tag = 3
    }
    
    let skillfullButton = InfoButton(title: "능숙한 실력", status: .active).then {
        $0.tag = 4
    }
    
    let beneficialButton = InfoButton(title: "유익한 시간", status: .active).then {
        $0.tag = 5
    }
    
    lazy var leftVerticalStackView = UIStackView(arrangedSubviews: [mannerButton, fastResponseButton, skillfullButton]).then {
        $0.spacing = 8
        $0.alignment = .fill
        $0.distribution = .fillEqually
        $0.axis = .vertical
    }
    
    lazy var rightVerticalStackView = UIStackView(arrangedSubviews: [exactTimeButton, kindButton, beneficialButton]).then {
        $0.spacing = 8
        $0.alignment = .fill
        $0.distribution = .fillEqually
        $0.axis = .vertical
    }

    lazy var horizontalStackView = UIStackView(arrangedSubviews: [leftVerticalStackView, rightVerticalStackView]).then {
        $0.alignment = .fill
        $0.distribution = .fillEqually
        $0.axis = .horizontal
        $0.spacing = 8
    }
    

    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    override func configure() {
        [titleLabel, horizontalStackView].forEach { self.addSubview($0) }
    }
    
    override func setConstraints() {
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.equalToSuperview()
        }
        
        horizontalStackView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(16)
            make.bottom.equalToSuperview().offset(1)
            make.horizontalEdges.equalToSuperview()
            //make.trailing.equalToSuperview()
        }
    }
}
