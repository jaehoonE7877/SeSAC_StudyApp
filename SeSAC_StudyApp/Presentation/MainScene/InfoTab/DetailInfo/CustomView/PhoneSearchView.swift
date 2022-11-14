//
//  PhoneSearchTableViewCell.swift
//  SeSAC_StudyApp
//
//  Created by Seo Jae Hoon on 2022/11/15.
//

import UIKit

final class PhoneSearchView: BaseView {
    
    //MARK: Porperty
    lazy var phoneLabel = UILabel().then {
        $0.text = "내 번호 검색 허용"
        $0.font = UIFont.notoSans(size: 14, family: .Regular)
        $0.textColor = .textColor
    }
    
    lazy var phoneButton = UISwitch().then {
        $0.isOn = true
        $0.onTintColor = .ssGreen
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    override func configure() {
        [phoneLabel, phoneButton].forEach { self.addSubview($0) }
    }
    
    override func setConstraints() {
        phoneLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.centerY.equalToSuperview()
        }
        
        phoneButton.snp.makeConstraints { make in
            make.centerY.equalTo(phoneLabel.snp.centerY)
            make.trailing.equalToSuperview()
            make.height.equalTo(40)
            make.width.equalTo(52)
        }
    }
}
