//
//  ChatView.swift
//  SeSAC_StudyApp
//
//  Created by Seo Jae Hoon on 2022/11/27.
//

import UIKit

final class ChatView: BaseView {
    
    lazy var tableView = UITableView(frame: .zero, style: .plain).then {
        $0.showsVerticalScrollIndicator = false
        $0.backgroundColor = .systemBackground
        $0.register(ProfileImageHeaderView.self, forHeaderFooterViewReuseIdentifier: ProfileImageHeaderView.reuseIdentifier)
        $0.separatorStyle = .none
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
}
