//
//  InfoDetailTableViewCell.swift
//  SeSAC_StudyApp
//
//  Created by Seo Jae Hoon on 2022/11/15.
//
import UIKit

import SnapKit
import Then

final class InfoDetailTableViewCell: UITableViewCell {
    
    //MARK: Porperty
    lazy var genderView = GenderCustomView()
    
    lazy var studyInputView = StudyInputView()
    
    lazy var phoneSearchView = PhoneSearchView()
    
    lazy var friendAgeView = FriendAgeView()
    
    lazy var withdrawView = WithdrawView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configure()
        setConstraint()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    private func configure() {
        [genderView, studyInputView, phoneSearchView, friendAgeView, withdrawView].forEach { contentView.addSubview($0) }
    }
    
    private func setConstraint(){
        genderView.snp.makeConstraints { make in
            make.width.equalTo(contentView)
            make.height.equalTo(76)
            make.centerX.equalTo(contentView)
            make.top.equalTo(contentView)
        }
        
        studyInputView.snp.makeConstraints { make in
            make.width.equalTo(contentView)
            make.height.equalTo(76)
            make.centerX.equalTo(contentView)
            make.top.equalTo(genderView.snp.bottom)
        }
        
        phoneSearchView.snp.makeConstraints { make in
            make.width.equalTo(contentView)
            make.height.equalTo(76)
            make.centerX.equalTo(contentView)
            make.top.equalTo(studyInputView.snp.bottom)
        }
        
        friendAgeView.snp.makeConstraints { make in
            make.width.equalTo(contentView)
            make.height.equalTo(100)
            make.centerX.equalTo(contentView)
            make.top.equalTo(phoneSearchView.snp.bottom)
        }
        
        withdrawView.snp.makeConstraints { make in
            make.width.equalTo(contentView)
            make.height.equalTo(76)
            make.centerX.equalTo(contentView)
            make.top.equalTo(friendAgeView.snp.bottom)
        }
    }
    
    func setData(item: SeSACInfo) {
        if item.gender == 0 {
            genderView.womanButton.status = .active
            genderView.manButton.status = .inactive
        } else {
            genderView.womanButton.status = .inactive
            genderView.manButton.status = .active
        }
    }
}
