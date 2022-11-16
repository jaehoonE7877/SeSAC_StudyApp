//
//  InfoViewController.swift
//  SeSAC_StudyApp
//
//  Created by Seo Jae Hoon on 2022/11/12.
//

import UIKit

import RxCocoa
import RxSwift
import RxDataSources

final class InfoViewController: BaseViewController {
    
    private lazy var tableView = UITableView(frame: .zero, style: .plain).then {
        $0.separatorInset = .init(top: 0, left: 16, bottom: 0, right: 16)
        $0.register(InfoTableViewCell.self, forCellReuseIdentifier: InfoTableViewCell.reuseIdentifier)
    }
    
    private var dataSource = RxTableViewSectionedReloadDataSource<InfoSectionModel>(configureCell: { dataSource, tableView, indexPath, item in
        guard let cell = tableView.dequeueReusableCell(withIdentifier: InfoTableViewCell.reuseIdentifier, for: indexPath) as? InfoTableViewCell else { return UITableViewCell() }
        
        if indexPath.row == Info.personal.rawValue {
            cell.mainImageView.snp.updateConstraints { make in
                make.size.equalTo(48)
            }
            cell.mainLabel.font = UIFont.notoSans(size: 16, family: .Medium)
            cell.selectionStyle = .none
        }

        cell.mainImageView.image = item.mainImage
        cell.mainLabel.text = item.title
        cell.detailImage.image = item.detailImage
        
        return cell
    })
    
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setNavigationController()
        self.tabBarController?.tabBar.isHidden = false
    }
    
    override func configure() {
        title = "내정보"
        
        view.addSubview(tableView)
    }
    
    override func setConstraint() {
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    override func setBinding() {
        
        let info = [
            InfoSectionModel(items: [InfoModel(mainImage: Info.personal.image, detailImage: UIImage(named: "more_arrow"), title: Info.personal.title),
                                     InfoModel(mainImage: Info.notice.image, title: Info.notice.title),
                                     InfoModel(mainImage: Info.faq.image, title: Info.faq.title),
                                     InfoModel(mainImage: Info.qna.image, title: Info.qna.title),
                                     InfoModel(mainImage: Info.alarm.image, title: Info.alarm.title),
                                     InfoModel(mainImage: Info.permit.image, title: Info.permit.title)
                                    ])
        ]
        
        Observable.just(info)
          .bind(to: tableView.rx.items(dataSource: dataSource))
          .disposed(by: disposeBag)
        
        tableView.rx.itemSelected
            .withUnretained(self)
            .subscribe(onNext: { weakSelf, indexPath in
                weakSelf.transitionViewController(viewController: DetailInfoViewController(), transitionStyle: .push)
            })
            .disposed(by: disposeBag)
        
        tableView.rx.setDelegate(self)
            .disposed(by: disposeBag)

    }
    
}

extension InfoViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == Info.personal.rawValue {
            return 96
        } else {
            return 74
        }
    }
    
}
