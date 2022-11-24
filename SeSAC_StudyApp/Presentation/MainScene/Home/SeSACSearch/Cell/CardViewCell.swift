//
//  CardViewCell.swift
//  SeSAC_StudyApp
//
//  Created by Seo Jae Hoon on 2022/11/23.
//

import UIKit

import RxSwift

class DynamicHeightCollectionView: UICollectionView {
    override func layoutSubviews() {
        super.layoutSubviews()
        if !__CGSizeEqualToSize(bounds.size, self.intrinsicContentSize) {
            self.invalidateIntrinsicContentSize()
        }
    }
    
    override var intrinsicContentSize: CGSize {
        return contentSize
    }
}

final class CardViewCell: SesacDetailTableViewCell {
    
    var cellDisposeBag = DisposeBag()
    
    lazy var studyLabel = UILabel().then {
        $0.layoutIfNeeded()
        $0.font = UIFont.notoSans(size: 12, family: .Regular)
        $0.textColor = .textColor
        $0.text = "하고 싶은 스터디"
    }
    
    lazy var collectionView = DynamicHeightCollectionView(frame: .zero, collectionViewLayout: UICollectionViewLayout.init()).then {
        $0.layoutSubviews()
        $0.layoutIfNeeded()
        $0.isScrollEnabled = false
        $0.showsVerticalScrollIndicator = false
        $0.register(SearchCollectionViewCell.self, forCellWithReuseIdentifier: SearchCollectionViewCell.reuseIdentifier)
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
    }
    
    override func configure() {
        super.configure()
        [studyLabel, collectionView].forEach { contentView.addSubview($0) }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        updateLayout()
        self.cellDisposeBag = DisposeBag()
        collectionView.reloadData()
        
    }
    
    func updateLayout() {
        self.setNeedsLayout()
        self.layoutIfNeeded()
        self.collectionView.setNeedsLayout()
        self.collectionView.layoutIfNeeded()
    }

    override func setConstraint() {

        chevornImageView.snp.makeConstraints { make in
            make.top.equalTo(contentView.snp.top).offset(21)
            make.trailing.equalTo(contentView.snp.trailing).offset(-16)
            make.size.equalTo(16)
        }
        
        nameLabel.snp.makeConstraints { make in
            make.leading.equalTo(contentView).offset(16)
            make.centerY.equalTo(chevornImageView.snp.centerY)
            make.height.equalTo(28)
        }

        sesacTitleView.snp.makeConstraints { make in
            make.top.equalTo(nameLabel.snp.bottom).offset(25)
            make.horizontalEdges.equalToSuperview().inset(16)
            make.height.equalTo(154)
        }
        
        studyLabel.snp.makeConstraints { make in
            make.top.equalTo(sesacTitleView.snp.bottom).offset(24)
            make.leading.equalToSuperview().offset(16)
            make.height.equalTo(18)
        }
        
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(studyLabel.snp.bottom).offset(16)
            make.horizontalEdges.equalToSuperview().inset(16)
            make.height.greaterThanOrEqualTo(32)
        }
        
        sesacReviewView.snp.makeConstraints { make in
            make.top.equalTo(collectionView.snp.bottom).offset(24)
            make.horizontalEdges.equalToSuperview().inset(16)
            make.bottom.equalToSuperview().inset(16)
        }
    }
    
}
