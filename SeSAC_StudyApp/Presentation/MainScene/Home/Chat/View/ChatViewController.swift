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
import RxGesture

final class ChatViewController: BaseViewController {
    
    private let mainView = ChatView()
    
    private let disposeBag = DisposeBag()
    
    let viewModel = ChatViewModel()
    
    override func loadView() {
        self.view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setNavigationController()
        bindingViewModel()
    }
    
    override func setNavigationController() {
        tabBarController?.tabBar.isHidden = true
        navigationController?.navigationBar.isHidden = false
        guard let nick = viewModel.chatData?.matchedNick else { return }
        title = "\(nick)"
        navigationItem.backButtonTitle = ""
        navigationController?.navigationBar.tintColor = .textColor
        
        navigationItem.leftBarButtonItem = mainView.backButton
        navigationItem.rightBarButtonItem = mainView.viewMoreButton
        
        mainView.backButton.rx.tap
            .withUnretained(self)
            .bind { weakSelf, _ in
                weakSelf.navigationController?.popToRootViewController(animated: true)
            }
            .disposed(by: disposeBag)
    }
    
    private func bindingViewModel() {
        mainView.subView.cancelMatchButton.rx.tap
            .withUnretained(self)
            .subscribe { weakSelf, _ in
                let vc = MatchingCancelViewController()
                vc.modalPresentationStyle = .overFullScreen
                weakSelf.present(vc, animated: false)
            }
            .disposed(by: disposeBag)
        
        
    }
    
    private func bindingTableView() {
        
//        mainView.tableView.rx.setDelegate(self)
//            .disposed(by: disposeBag)
        
//        let dataSource = RxTableViewSectionedReloadDataSource<ChatSectionModel>(configureCell: { [weak self] dataSource, tableView, indexPath, item in
//            guard let self = self else { return UITableViewCell()}
//
//
//
//            return cell
//        })
        
        var sections: [SeSACCardSectionModel] = []
        
//        Observable.just(sections)
//            .bind(to: mainView.tableView.rx.items(dataSource: dataSource))
//            .disposed(by: disposeBag)
        
    }
    
}


