//
//  DetailInfoViewController.swift
//  SeSAC_StudyApp
//
//  Created by Seo Jae Hoon on 2022/11/14.
//

import UIKit

import RxSwift
import RxCocoa
import RxDataSources

final class DetailInfoViewController: BaseViewController {
    
    //MARK: Property
    private let tableView = UITableView(frame: .zero, style: .plain).then {
        $0.register(InfoDetailTableViewCell.self, forCellReuseIdentifier: InfoDetailTableViewCell.reuseIdentifier)
        $0.register(SesacDetailTableViewCell.self, forCellReuseIdentifier: SesacDetailTableViewCell.reuseIdentifier)
        $0.register(SesacImageTableViewCell.self, forCellReuseIdentifier: SesacImageTableViewCell.reuseIdentifier)
        $0.separatorStyle = .none
    }
    
    private var dataSource = RxTableViewSectionedReloadDataSource<InfoSectionModel>(configureCell: { dataSource, tableView, indexPath, item in
        
        if indexPath.section == 0 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: SesacImageTableViewCell.reuseIdentifier, for: indexPath) as? SesacImageTableViewCell else { return UITableViewCell() }
            return cell
        } else if indexPath.section == 1 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: SesacDetailTableViewCell.reuseIdentifier, for: indexPath) as? SesacDetailTableViewCell else { return UITableViewCell() }
            return cell
        } else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: InfoDetailTableViewCell.reuseIdentifier, for: indexPath) as? InfoDetailTableViewCell else { return UITableViewCell() }
            return cell
        }
        
    })
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setNavigationController()
    }
    
    override func configure() {
        title = "정보 관리"
        view.backgroundColor = .systemBackground
        view.addSubview(tableView)
    }
    
    override func setConstraint() {
        tableView.snp.makeConstraints { make in
            make.verticalEdges.equalToSuperview()
            make.horizontalEdges.equalToSuperview().inset(16)
        }
    }
    
    override func setBinding() {
        
    }
}

extension DetailInfoViewController: UITableViewDelegate {
    
    
    
}
