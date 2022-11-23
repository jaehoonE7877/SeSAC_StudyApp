//
//  FriendEmptyView.swift
//  SeSAC_StudyApp
//
//  Created by Seo Jae Hoon on 2022/11/24.
//

import UIKit

final class FriendEmptyView: BaseView {
    
    lazy var imageView = UIImageView(image: UIImage(named: "gray_sesac")).then {
        $0.contentMode = .scaleAspectFill
    }
    
    lazy var mainLabel = UILabel().then {
        $0.textAlignment = .center
        $0.font = .notoSans(size: 20, family: .Regular)
        $0.textColor = .textColor
    }
    
    lazy var subLabel = UILabel().then {
        $0.textAlignment = .center
        $0.font = .notoSans(size: 14, family: .Regular)
        $0.textColor = .gray7
        $0.text = "스터디를 변경하거나 조금만 더 기다려 주세요!"
    }
    
    lazy var studyChangeButton = NextButton(title: "스터디 변경하기", status: .fill)
    
    lazy var refreshButton = UIButton().then {
        $0.backgroundColor = .white
        $0.layer.borderWidth = 1
        $0.layer.borderColor = UIColor.ssGreen.cgColor
        $0.layer.cornerRadius = 8
        $0.contentMode = .center
        $0.tintColor = .ssGreen
        $0.setImage(UIImage(named: "refresh"), for: .normal)
    }
    
    lazy var verticalStackView = UIStackView(arrangedSubviews: [mainLabel, subLabel]).then {
        $0.distribution = .fillProportionally
        $0.axis = .vertical
        $0.alignment = .fill
        $0.spacing = 8
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    init(){
        super.init(frame: .zero)
    }
    
    convenience init(title: String) {
        self.init()
        
        self.mainLabel.text = title
    }
    
    override func configure() {
        [imageView, verticalStackView, studyChangeButton, refreshButton].forEach{ self.addSubview($0) }
    }
    
    override func setConstraints() {
        imageView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.equalTo(64)
            make.height.equalTo(56)
        }
        
        verticalStackView.snp.makeConstraints { make in
            make.top.equalTo(imageView.snp.bottom).offset(36)
            make.centerX.equalToSuperview()
        }
        
        refreshButton.snp.makeConstraints { make in
            make.size.equalTo(48)
            make.bottom.equalToSuperview().offset(-50)
            make.trailing.equalToSuperview().offset(-16)
        }
        
        studyChangeButton.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalTo(refreshButton.snp.leading).offset(-16)
            make.height.equalTo(48)
            make.bottom.equalToSuperview().offset(-50)
        }
    }
}
