//
//  SeSACSearchView.swift
//  SeSAC_StudyApp
//
//  Created by Seo Jae Hoon on 2022/11/23.
//

import UIKit

final class SeSACSearchView: BaseView {
    
    //데이터가 없을 때 hidden처리한 뷰 보여주고 tableview hidden시켜주기
    
    lazy var tableView = UITableView(frame: .zero, style: .grouped).then {
        $0.showsVerticalScrollIndicator = false
        $0.contentInset = .init(top: 16, left: 0, bottom: 0, right: 0)
        $0.backgroundColor = .systemBackground
        $0.register(ProfileImageHeaderView.self, forHeaderFooterViewReuseIdentifier: ProfileImageHeaderView.reuseIdentifier)
        $0.register(SesacDetailTableViewCell.self, forCellReuseIdentifier: SesacDetailTableViewCell.reuseIdentifier)
        $0.separatorStyle = .none
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    override func configure() {
        self.addSubview(tableView)
    }
    
    override func setConstraints() {
        tableView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.bottom.equalToSuperview()
            make.horizontalEdges.equalToSuperview().inset(16)
        }
    }
}
