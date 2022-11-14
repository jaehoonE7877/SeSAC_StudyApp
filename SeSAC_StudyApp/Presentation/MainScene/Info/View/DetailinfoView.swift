//
//  DetailinfoView.swift
//  SeSAC_StudyApp
//
//  Created by Seo Jae Hoon on 2022/11/14.
//

import UIKit

import RxSwift
import RxCocoa

final class DetailInfoView: BaseView {
    
    //MARK: Property
    private let tableView = UITableView(frame: .zero, style: .plain).then {
        $0.separatorStyle = .none
        $0.translatesAutoresizingMaskIntoConstraints = false
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    override func configure() {
        contentView.addSubview(tableView)
    }
    
    override func setConstraints() {
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
}
