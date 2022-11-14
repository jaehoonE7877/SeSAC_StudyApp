//
//  SesacReviewView.swift
//  SeSAC_StudyApp
//
//  Created by Seo Jae Hoon on 2022/11/15.
//

import UIKit

final class SesacReviewView: BaseView {
    
    lazy var reviewTitleLabel = UILabel().then {
        $0.font = UIFont.notoSans(size: 12, family: .Regular)
        $0.textColor = .textColor
        $0.text = "새싹 리뷰"
    }
    
    lazy var reviewLabel = UILabel().then {
        $0.numberOfLines = 0
        $0.font = UIFont.notoSans(size: 14, family: .Regular)
        $0.textColor = .gray6
        $0.text = "첫 리뷰를 기다리는 중이에요!"
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    override func configure() {
        [reviewTitleLabel, reviewLabel].forEach { self.addSubview($0) }
    }
    
    override func setConstraints() {
        reviewTitleLabel.snp.makeConstraints { make in
            make.top.leading.equalToSuperview()

        }
        
        reviewLabel.snp.makeConstraints { make in
            make.top.equalTo(reviewTitleLabel.snp.bottom).offset(16)
            make.horizontalEdges.equalToSuperview()
        }
    }
    
}