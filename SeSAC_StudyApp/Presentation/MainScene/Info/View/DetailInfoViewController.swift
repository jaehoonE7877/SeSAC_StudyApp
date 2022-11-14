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

final class DetailViewController: BaseViewController {
    
    //MARK: Property
    private let tableView = UITableView(frame: .zero, style: .plain).then {
        $0.register(InfoDetailTableViewCell.self, forCellReuseIdentifier: InfoDetailTableViewCell.reuseIdentifier)
        $0.register(SesacDetailTableViewCell.self, forCellReuseIdentifier: SesacDetailTableViewCell.reuseIdentifier)
        $0.register(SesacImageTableViewCell.self, forCellReuseIdentifier: SesacImageTableViewCell.reuseIdentifier)
        $0.separatorStyle = .none
    }
    
    private var dataSource = RxTableViewSectionedReloadDataSource<InfoSectionModel>(configureCell: { dataSource, tableView, indexPath, item in
        guard let cell = tableView.dequeueReusableCell(withIdentifier: InfoTableViewCell.reuseIdentifier, for: indexPath) as? InfoTableViewCell else { return UITableViewCell() }
        
        if indexPath.row == Info.personal.rawValue {
            cell.mainImageView.snp.updateConstraints { make in
                make.size.equalTo(48)
            }
            cell.mainLabel.font = UIFont.notoSans(size: 16, family: .Medium)
        }

        cell.mainImageView.image = item.mainImage
        cell.mainLabel.text = item.title
        cell.detailImage.image = item.detailImage
        
        return cell
    })
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setNavigationController()
    }
    
    override func configure() {
        title = "정보 관리"
        view.addSubview(tableView)
    }
    
    override func setConstraint() {
        tableView.snp.makeConstraints { make in
            make.verticalEdges.equalToSuperview()
            make.horizontalEdges.equalToSuperview().inset(16)
        }
    }
}
