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
    lazy var foldableView = FoldableView().then {
        $0.layoutIfNeeded()
        $0.layer.borderWidth = 1
        $0.layer.masksToBounds = true
        $0.layer.cornerRadius = 8
        $0.layer.borderColor = UIColor.gray2.cgColor
        
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
        [foldableView , sesacTitleView, sesacReviewView].forEach { contentView.addSubview($0) }
    }
    
    private func setConstraint() {
        
        foldableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        sesacTitleView.snp.makeConstraints { make in
            make.top.equalTo(foldableView.nameLabel.snp.bottom).offset(25)
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
        
        
        foldableView.nameLabel.text = item.nick
        [sesacTitleView.mannerButton, sesacTitleView.exactTimeButton,
         sesacTitleView.fastResponseButton, sesacTitleView.kindButton,
         sesacTitleView.skillfullButton, sesacTitleView.beneficialButton].forEach { self.configReputation(reputation: item.reputation, sender: $0)}
        if item.comment.first != nil {
            sesacReviewView.reviewLabel.text = item.comment.first
        } else {
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
