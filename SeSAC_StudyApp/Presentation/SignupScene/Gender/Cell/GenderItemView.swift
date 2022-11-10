//
//  GenderCollectionViewCell.swift
//  SeSAC_StudyApp
//
//  Created by Seo Jae Hoon on 2022/11/10.
//

import UIKit

import SnapKit
import Then

final class GenderItemView: BaseView {
    
    lazy var imageView = UIImageView().then {
        $0.contentMode = .scaleToFill
    }
    
    lazy var titleLabel = UILabel().then {
        $0.font = UIFont.notoSans(size: 16, family: .Regular)
        $0.textColor = .textColor
    }
    
    lazy var button = UIButton().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.layer.cornerRadius = 8
        self.layer.borderWidth = 1
        self.layer.masksToBounds = true
        self.layer.borderColor = UIColor.gray3.cgColor
    }
    
    override func configure() {
        [imageView, titleLabel, button].forEach{ self.addSubview($0)}

    }
    
    override func setConstraints() {
        imageView.snp.makeConstraints { make in
            make.centerX.equalTo(self)
            make.centerY.equalTo(self).multipliedBy(0.76)
            make.height.equalTo(self).multipliedBy(0.5)
            make.width.equalTo(imageView.snp.height)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.centerX.equalTo(self)
            make.top.equalTo(imageView.snp.bottom).offset(4)
        }
        
        button.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }

}
