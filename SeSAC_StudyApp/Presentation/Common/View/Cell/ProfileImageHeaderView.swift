//
//  ProfileImageView.swift
//  SeSAC_StudyApp
//
//  Created by Seo Jae Hoon on 2022/11/16.
//

import UIKit

import RxSwift
import RxCocoa
import RxGesture

final class ProfileImageHeaderView: UITableViewHeaderFooterView {
    
    var cellDisposeBag = DisposeBag()
    
    let bgImageView = UIImageView().then {
        $0.isHidden = false
        $0.layer.cornerRadius = 8
        $0.layer.masksToBounds = true
        $0.contentMode = .scaleAspectFill
    }
    
    let sesacImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFill
    }
    
    let requireButton = MatchButton(status: .require).then {
        $0.isHidden = true
    }
    
    let acceptButton = MatchButton(status: .accept).then {
        $0.isHidden = true
    }
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        configure()
        setConstraints()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        cellDisposeBag = DisposeBag()
    }
    
    //@available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        [bgImageView, sesacImageView, requireButton, acceptButton].forEach { self.addSubview($0)}
    }
    
    private func setConstraints() {
        bgImageView.snp.makeConstraints { make in
            make.top.equalTo(self)
            make.horizontalEdges.bottom.equalToSuperview()
        }
        
        sesacImageView.snp.makeConstraints { make in
            make.top.equalTo(bgImageView.snp.top).offset(20)
            make.centerX.equalTo(bgImageView)
            make.height.equalTo(bgImageView.snp.height).multipliedBy(0.98)
            make.width.equalTo(sesacImageView.snp.height)
        }
        
        requireButton.snp.makeConstraints { make in
            make.width.equalTo(80)
            make.height.equalTo(40)
            make.top.trailing.equalTo(bgImageView).inset(12)
        }
        
        acceptButton.snp.makeConstraints { make in
            make.width.equalTo(80)
            make.height.equalTo(40)
            make.top.trailing.equalTo(bgImageView).inset(12)
        }
    }
}
