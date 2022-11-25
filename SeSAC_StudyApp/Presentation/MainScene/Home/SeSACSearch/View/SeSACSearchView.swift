//
//  SeSACSearchView.swift
//  SeSAC_StudyApp
//
//  Created by Seo Jae Hoon on 2022/11/23.
//

import UIKit

final class SeSACSearchView: BaseView {
    
    lazy var friendEmptyView = FriendEmptyView().then {
        $0.isHidden = true
    }
    
    lazy var tableView = UITableView(frame: .zero, style: .grouped).then {
        $0.showsVerticalScrollIndicator = false
        $0.contentInset = .init(top: 16, left: 0, bottom: 0, right: 0)
        $0.backgroundColor = .systemBackground
        $0.register(ProfileImageHeaderView.self, forHeaderFooterViewReuseIdentifier: ProfileImageHeaderView.reuseIdentifier)
        $0.register(CardViewCell.self, forCellReuseIdentifier: CardViewCell.reuseIdentifier)
        $0.separatorStyle = .none
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    convenience init(emptyViewTitle: String) {
        self.init()
        friendEmptyView.mainLabel.text = emptyViewTitle
    }
    
    override func configure() {
        self.addSubview(tableView)
        self.addSubview(friendEmptyView)
    }
    
    override func setConstraints() {
        tableView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.bottom.equalToSuperview()
            make.horizontalEdges.equalToSuperview().inset(16)
        }
        
        friendEmptyView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}
