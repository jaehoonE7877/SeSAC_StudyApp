//
//  ChattingViewController.swift
//  SeSAC_StudyApp
//
//  Created by Seo Jae Hoon on 2022/11/27.
//

import UIKit

import RxSwift
import RxCocoa
import RxDataSources

final class ChatViewController: BaseViewController {
    
    private let mainView = ChatView()
    
    private let disposeBag = DisposeBag()
    
    override func loadView() {
        self.view = mainView
    }
    
    lazy var viewMoreButton = UIBarButtonItem(image: UIImage(systemName: "ellipsis"), style: .plain, target: self, action: nil)
    lazy var backButton = UIBarButtonItem(image: UIImage(named: "arrow"), style: .plain, target: self, action: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setNavigationController()
    }
    
    override func setNavigationController() {
        tabBarController?.tabBar.isHidden = true
        navigationController?.navigationBar.isHidden = false
        title = "새싹 찾기"
        navigationItem.backButtonTitle = ""
        navigationController?.navigationBar.tintColor = .textColor
        
        navigationItem.leftBarButtonItem = backButton
        navigationItem.rightBarButtonItem = viewMoreButton
        
        backButton.rx.tap
            .withUnretained(self)
            .bind { weakSelf, _ in
                weakSelf.navigationController?.popToRootViewController(animated: true)
            }
            .disposed(by: disposeBag)
        
    }
    
    private func bindingTableView() {
        
//        mainView.tableView.rx.setDelegate(self)
//            .disposed(by: disposeBag)
        
        let dataSource = RxTableViewSectionedReloadDataSource<ChatSectionModel>(configureCell: { [weak self] dataSource, tableView, indexPath, item in
            guard let self = self else { return UITableViewCell()}
            
        
            
            return cell
        })
        
        var sections: [SeSACCardSectionModel] = []
        
        Observable.just(sections)
            .bind(to: mainView.tableView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
        
    }
    
}


