//
//  CardViewCell.swift
//  SeSAC_StudyApp
//
//  Created by Seo Jae Hoon on 2022/11/23.
//

import UIKit

final class CardViewCell: SesacDetailTableViewCell {
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
    }
    
    override func configure() {
        super.configure()
        
    }
    
    override func prepareForReuse() {
        //sesacStudyListView.collectionView.reloadData()
    }
    
    override func setConstraint() {
        //super.setConstraint()
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
        
        sesacStudyListView.snp.makeConstraints { make in
            make.top.equalTo(sesacTitleView.snp.bottom).offset(24)
            make.horizontalEdges.equalToSuperview().inset(16)
            make.height.greaterThanOrEqualTo(66)
        }
        
        sesacReviewView.snp.makeConstraints { make in
            make.top.equalTo(sesacStudyListView.snp.bottom).offset(24)
            make.horizontalEdges.equalToSuperview().inset(16)
            make.bottom.equalToSuperview().inset(16)
        }
    }
    
}
