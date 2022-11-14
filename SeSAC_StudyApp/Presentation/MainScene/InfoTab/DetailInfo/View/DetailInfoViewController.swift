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
    
    private var dataSource = RxTableViewSectionedReloadDataSource<DetailInfoSectionModel>(configureCell: { dataSource, tableView, indexPath, item in
        
        if indexPath.section == 0 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: SesacImageTableViewCell.reuseIdentifier, for: indexPath) as? SesacImageTableViewCell else { return UITableViewCell() }
            cell.selectionStyle = .none
            return cell
        } else if indexPath.section == 1 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: SesacDetailTableViewCell.reuseIdentifier, for: indexPath) as? SesacDetailTableViewCell else { return UITableViewCell() }
            cell.layer.borderWidth = 1
            cell.layer.masksToBounds = true
            cell.layer.cornerRadius = 8
            cell.layer.borderColor = UIColor.gray2.cgColor
            cell.selectionStyle = .none
            cell.nameLabel.text = item.title
            return cell
        } else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: InfoDetailTableViewCell.reuseIdentifier, for: indexPath) as? InfoDetailTableViewCell else { return UITableViewCell() }
            
            return cell
        }
    })
    
    private var foldValue: Bool = true
    
    private let disposeBag = DisposeBag()
    
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
        
        let section = [
            DetailInfoSectionModel(items: [DetailInfoModel()]),
            DetailInfoSectionModel(items: [DetailInfoModel(title: UserManager.nickname)]),
            DetailInfoSectionModel(items: [DetailInfoModel()])
        ]
        
        Observable.just(section)
          .bind(to: tableView.rx.items(dataSource: dataSource))
          .disposed(by: disposeBag)
        
        tableView.rx.itemSelected
            .withUnretained(self)
            .bind { weakSelf, indexPath in
                if indexPath.section == 1 {
                    weakSelf.foldValue.toggle()
                    weakSelf.tableView.reloadRows(at: [IndexPath(row: 0, section: 1)], with: .fade)
                }
            }
            .disposed(by: disposeBag)
        
        tableView.rx.setDelegate(self)
            .disposed(by: disposeBag)
    }
}

extension DetailInfoViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 194
        } else if indexPath.section == 1 {
            //⭐️Cell height
            return UITableView.automaticDimension
        } else {
            return 404
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 194
        } else if indexPath.section == 1 {
            //⭐️Cell height
            return foldValue ? 56 : 316
        } else {
            return 404
        }
    }
    
}
