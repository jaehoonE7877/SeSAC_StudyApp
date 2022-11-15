//
//  SesacDetailTableViewCell.swift
//  SeSAC_StudyApp
//
//  Created by Seo Jae Hoon on 2022/11/14.
//

import UIKit

import SnapKit
import Then

final class SesacDetailTableViewCell: UITableViewCell {
    
    //MARK: Property
    lazy var nameLabel = UILabel().then {
        $0.font = UIFont.notoSans(size: 16, family: .Regular)
        $0.textColor = .textColor
    }
    
    lazy var chevornImageView = UIImageView().then {
        $0.layoutIfNeeded()
        $0.image = UIImage(named: "more_arrow 1")
        $0.contentMode = .scaleAspectFill
    }
    
    lazy var sesacTitleView = SesacTitleView().then {
        $0.isHidden = true
        $0.layoutIfNeeded()
    }
    
    lazy var sesacReviewView = SesacReviewView().then {
        $0.isHidden = true
        $0.layoutIfNeeded()
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configure()
        setConstraint()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    private func configure() {
        [nameLabel, chevornImageView , sesacTitleView, sesacReviewView].forEach { contentView.addSubview($0) }
    }
    
    private func setConstraint() {
        nameLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(16)
            make.height.greaterThanOrEqualTo(24)
            make.leading.equalToSuperview().offset(16)
        }
        
        chevornImageView.snp.makeConstraints { make in
            make.centerY.equalTo(nameLabel.snp.centerY)
            make.trailing.equalToSuperview().offset(-16)
            make.size.equalTo(16)
        }
        
        sesacTitleView.snp.makeConstraints { make in
            make.top.equalTo(nameLabel.snp.bottom).offset(24)
            make.horizontalEdges.equalToSuperview().inset(16)
            make.height.equalTo(146)
        }
        
        sesacReviewView.snp.makeConstraints { make in
            make.top.equalTo(sesacTitleView.snp.bottom).offset(16)
            make.horizontalEdges.equalToSuperview().inset(16)
            make.bottom.equalToSuperview().inset(16)
        }
    }
    
    func setData(item: SeSACInfo){
        
    }
}
