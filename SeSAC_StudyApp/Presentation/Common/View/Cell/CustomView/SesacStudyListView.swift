//
//  SesacStudyListView.swift
//  SeSAC_StudyApp
//
//  Created by Seo Jae Hoon on 2022/11/23.
//

import UIKit

final class SesacStudyListView: BaseView {
    
    lazy var studyLabel = UILabel().then {
        $0.layoutIfNeeded()
        $0.font = UIFont.notoSans(size: 12, family: .Regular)
        $0.textColor = .textColor
        $0.text = "하고 싶은 스터디"
    }
    
    lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewLayout.init()).then {
        $0.layoutIfNeeded()
        $0.isScrollEnabled = false
        $0.showsVerticalScrollIndicator = false
        $0.register(SearchCollectionViewCell.self, forCellWithReuseIdentifier: SearchCollectionViewCell.reuseIdentifier)
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        
    }
    
    override func configure() {
        [studyLabel, collectionView].forEach { self.addSubview($0) }
    }
    
    override func setConstraints() {
        studyLabel.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.equalToSuperview()
        }
        
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(studyLabel.snp.bottom).offset(16)
            make.horizontalEdges.equalToSuperview()
            make.height.greaterThanOrEqualTo(36)
        }
    }
}
