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
        $0.font = UIFont.notoSans(size: 16, family: .Medium)
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
    
    lazy var sesacStudyListView = SesacStudyListView().then {
        $0.layoutIfNeeded()
        $0.isHidden = true
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.layoutIfNeeded()
        contentView.layer.borderWidth = 1
        contentView.layer.masksToBounds = true
        contentView.layer.cornerRadius = 8
        contentView.layer.borderColor = UIColor.gray2.cgColor
        configure()
        setConstraint()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    private func configure() {
        [nameLabel, chevornImageView, sesacTitleView, sesacStudyListView, sesacReviewView].forEach { contentView.addSubview($0) }
    }
    
    private func setConstraint() {
        
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
        
        sesacReviewView.snp.makeConstraints { make in
            make.top.equalTo(sesacTitleView.snp.bottom).offset(24)
            make.horizontalEdges.equalToSuperview().inset(16)
            make.bottom.equalToSuperview().inset(16)
        }
    }
    
    func setData(item: SeSACInfo){

        nameLabel.text = item.nick
        [sesacTitleView.mannerButton, sesacTitleView.exactTimeButton,
         sesacTitleView.fastResponseButton, sesacTitleView.kindButton,
         sesacTitleView.skillfullButton, sesacTitleView.beneficialButton].forEach { self.configReputation(reputation: item.reputation, sender: $0)}
        if item.comment.first != nil {
            sesacReviewView.reviewImageView.isHidden = false
            sesacReviewView.reviewLabel.textColor = .textColor
            sesacReviewView.reviewLabel.text = item.comment.first
        } else {
            sesacReviewView.reviewImageView.isHidden = true
            sesacReviewView.reviewLabel.textColor = .gray6
            sesacReviewView.reviewLabel.text = "첫 리뷰를 기다리는 중이에요!"
        }
    }
    
    func setDatas(item: SeSACCardModel){
        nameLabel.text = item.nick
        [sesacTitleView.mannerButton, sesacTitleView.exactTimeButton,
         sesacTitleView.fastResponseButton, sesacTitleView.kindButton,
         sesacTitleView.skillfullButton, sesacTitleView.beneficialButton].forEach { self.configReputation(reputation: item.reputation, sender: $0)}
        if item.reviews.first != nil {
            sesacReviewView.reviewImageView.isHidden = false
            sesacReviewView.reviewLabel.textColor = .textColor
            sesacReviewView.reviewLabel.text = item.reviews.last
        } else {
            sesacReviewView.reviewImageView.isHidden = true
            sesacReviewView.reviewLabel.textColor = .gray6
            sesacReviewView.reviewLabel.text = "첫 리뷰를 기다리는 중이에요!"
        }
    }
    
    
    private func configReputation(reputation: [Int], sender: InfoButton)  {
        if reputation[sender.tag] == 0 {
            sender.status = .inactive
        } else {
            sender.status = .active
        }
    }
}
