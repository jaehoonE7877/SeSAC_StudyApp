//
//  FriendAgeTableViewCell.swift
//  SeSAC_StudyApp
//
//  Created by Seo Jae Hoon on 2022/11/15.
//

import UIKit
import MultiSlider

final class FriendAgeView: BaseView {
    
    //MARK: Porperty
    lazy var friendLabel = UILabel().then {
        $0.text = "상대방 연령대"
        $0.font = UIFont.notoSans(size: 14, family: .Regular)
        $0.textColor = .textColor
    }
    
    lazy var ageLabel = UILabel().then {
        $0.font = .notoSans(size: 14, family: .Regular)
        $0.textColor = .ssGreen
        $0.text = "18 - 35"
    }
    
    lazy var slider = MultiSlider().then {
        $0.tintColor = .ssGreen
        $0.thumbImage = UIImage(named: "filter_control")
        $0.orientation = .horizontal
        $0.outerTrackColor = .gray2
        $0.thumbCount = 2
        $0.minimumValue = 18
        $0.maximumValue = 65
        $0.thumbTintColor = .ssGreen
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    override func configure() {
        [friendLabel, ageLabel, slider].forEach { self.addSubview($0) }
    }
    
    override func setConstraints() {
        friendLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.top.equalTo(self).offset(24)
        }
        
        ageLabel.snp.makeConstraints { make in
            make.centerY.equalTo(friendLabel.snp.centerY)
            make.trailing.equalToSuperview()
        }
        
        slider.snp.makeConstraints { make in
            make.top.equalTo(friendLabel.snp.bottom).offset(12)
            make.width.equalToSuperview().multipliedBy(0.92)
            make.centerX.equalToSuperview()
        }
    }
}
