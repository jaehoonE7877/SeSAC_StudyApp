//
//  GenderTableViewCell.swift
//  SeSAC_StudyApp
//
//  Created by Seo Jae Hoon on 2022/11/14.
//

import UIKit

import SnapKit
import Then

final class GenderCustomView: BaseView {
    
    //MARK: Porperty
    lazy var genderLabel = UILabel().then {
        $0.text = "내 성별"
        $0.font = UIFont.notoSans(size: 14, family: .Regular)
        $0.textColor = .textColor
    }
    
    lazy var manButton = InfoButton(title: "남자", status: .active).then {
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    
    lazy var womanButton = InfoButton(title: "여자", status: .inactive).then {
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    
    lazy var horizontalStackView = UIStackView(arrangedSubviews: [manButton, womanButton]).then {
        $0.alignment = .fill
        $0.distribution = .fillEqually
        $0.axis = .horizontal
        $0.spacing = 8
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    
    override func configure() {
        [genderLabel, horizontalStackView].forEach { self.addSubview($0) }
    }
    
    override func setConstraints() {
        genderLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.centerY.equalToSuperview()
        }
        
        horizontalStackView.snp.makeConstraints { make in
            make.centerY.equalTo(genderLabel.snp.centerY)
            make.trailing.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.36)
            make.height.equalTo(48)
        }
    }
}
