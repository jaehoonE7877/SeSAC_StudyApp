//
//  PageView.swift
//  SeSAC_StudyApp
//
//  Created by Seo Jae Hoon on 2022/11/07.
//

import UIKit

final class PageView: BaseView {
    
    lazy var onboardingLabel = UILabel().then {
        $0.numberOfLines = 2
        $0.text =
            """
            위치 기반으로 빠르게
            주위 친구를 확인
            """
        $0.asColor(targetString: "위치 기반", color: .ssGreen)
        $0.textAlignment = .center
        $0.font = .notoSans(size: 24, family: .Medium)
    }
    
    lazy var onboardingImage = UIImageView().then {
        $0.contentMode = .scaleAspectFill
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
    }
    
    override func configure() {
        [onboardingLabel, onboardingImage].forEach { self.addSubview($0) }
    }
    
    override func setConstraints() {
        onboardingLabel.snp.makeConstraints { make in
            make.top.equalTo(self).offset(72)
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.82)
        }
        
        onboardingImage.snp.makeConstraints { make in
            make.top.equalTo(onboardingLabel.snp.bottom).offset(56)
            make.width.equalToSuperview().multipliedBy(0.96)
            make.height.equalTo(onboardingImage.snp.width)
            make.centerX.equalToSuperview()
        }
        
    }
    
}
