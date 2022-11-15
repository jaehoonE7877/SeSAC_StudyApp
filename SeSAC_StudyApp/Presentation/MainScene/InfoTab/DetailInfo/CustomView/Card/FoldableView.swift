//
//  FoldableView.swift
//  SeSAC_StudyApp
//
//  Created by Seo Jae Hoon on 2022/11/16.
//

import UIKit

final class FoldableView: BaseView {
    
    lazy var nameLabel = UILabel().then {
        $0.font = UIFont.notoSans(size: 16, family: .Medium)
        $0.textColor = .textColor
    }
    
    lazy var chevornImageView = UIImageView().then {
        $0.layoutIfNeeded()
        $0.image = UIImage(named: "more_arrow 1")
        $0.contentMode = .scaleAspectFill
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    
    override func configure() {
        [nameLabel, chevornImageView].forEach { self.addSubview($0)}
    }
    
    override func setConstraints() {
        nameLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(16)
            make.leading.equalToSuperview().offset(16)
            make.height.equalTo(28)
            
        }
        
        chevornImageView.snp.makeConstraints { make in
            make.centerY.equalTo(nameLabel.snp.centerY)
            make.trailing.equalToSuperview().offset(-16)
            make.size.equalTo(16)
        }
    }
}
