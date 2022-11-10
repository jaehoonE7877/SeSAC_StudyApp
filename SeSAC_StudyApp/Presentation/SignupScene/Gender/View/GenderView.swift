//
//  GenderView.swift
//  SeSAC_StudyApp
//
//  Created by Seo Jae Hoon on 2022/11/10.
//

import UIKit

final class GenderView: LoginView {
    
    //MARK: Property
    lazy var subLabel = UILabel().then {
        $0.text = "새싹 찾기 기능을 이용하기 위해서 필요해요!"
        $0.textColor = .gray7
        $0.textAlignment = .center
        $0.font = UIFont.notoSans(size: 16, family: .Regular)
    }
    
    lazy var manView = GenderItemView().then {
        $0.imageView.image = UIImage(named: "man")!
        $0.titleLabel.text = "남자"
    }
    
    lazy var womanView = GenderItemView().then {
        $0.imageView.image = UIImage(named: "woman")!
        $0.titleLabel.text = "여자"
    }
    
    lazy var verticalStackView = UIStackView(arrangedSubviews: [mainLabel, subLabel]).then {
        $0.distribution = .fillProportionally
        $0.axis = .vertical
        $0.spacing = 8
    }
    
    lazy var horizontalStackView = UIStackView(arrangedSubviews: [manView, womanView]).then {
        $0.distribution = .fillEqually
        $0.axis = .horizontal
        $0.spacing = 16
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    override func configure() {
        super.configure()
        mainButton.setTitle("다음", for: .normal)
        mainLabel.text = "성별을 선택해 주세요"
        [verticalStackView, horizontalStackView].forEach { self.addSubview($0)}
    }
    
    override func setConstraints() {
        super.setConstraints()
        
        verticalStackView.snp.makeConstraints { make in
            make.centerY.equalTo(self.safeAreaLayoutGuide).multipliedBy(0.48)
            make.centerX.equalToSuperview()
        }
        
        horizontalStackView.snp.makeConstraints { make in
            make.width.equalTo(mainButton)
            make.centerX.equalToSuperview()
            make.centerY.equalTo(self.safeAreaLayoutGuide).multipliedBy(0.8)
            make.height.equalTo(horizontalStackView.snp.width).multipliedBy(0.35)
        }
    }
}
