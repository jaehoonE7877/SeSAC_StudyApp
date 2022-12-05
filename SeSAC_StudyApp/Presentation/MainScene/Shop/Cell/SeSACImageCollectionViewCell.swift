//
//  SeSACImageCollectionViewCell.swift
//  SeSAC_StudyApp
//
//  Created by Seo Jae Hoon on 2022/12/05.
//

import UIKit

import SnapKit
import Then

import RxCocoa
import RxSwift

final class SeSACImageCollectionViewCell: UICollectionViewCell {
    
    let sesacImageView = UIImageView().then {
        $0.layer.masksToBounds = true
        $0.layer.cornerRadius = 8
        $0.layer.borderWidth = 1
        $0.contentMode = .scaleAspectFill
    }
    
    let titleLabel = UILabel().then {
        $0.textColor = .textColor
        $0.font = .notoSans(size: 16, family: .Regular)
    }
    
    let buyButton = BuyButton(status: .yet())
    
    let subLabel = UILabel().then {
        $0.numberOfLines = 3
        $0.textColor = .textColor
        $0.font = .notoSans(size: 14, family: .Regular)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    private func setUI() {
        [sesacImageView, titleLabel, buyButton, subLabel].forEach { contentView.addSubview($0) }
        
        sesacImageView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.horizontalEdges.equalToSuperview()
            make.height.equalTo(sesacImageView.snp.width).multipliedBy(1)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(sesacImageView.snp.bottom).offset(8)
            make.leading.equalToSuperview()
        }
        
        buyButton.snp.makeConstraints { make in
            make.centerY.equalTo(titleLabel.snp.centerY)
            make.width.equalTo(52)
            make.height.equalTo(20)
            make.trailing.equalToSuperview().inset(10)
        }
        
        subLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(8)
            make.horizontalEdges.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }
}
