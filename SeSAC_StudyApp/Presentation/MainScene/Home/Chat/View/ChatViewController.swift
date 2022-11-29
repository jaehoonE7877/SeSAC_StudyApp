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
    
    lazy var dataSource = RxTableViewSectionedReloadDataSource<ChatSectionModel>(configureCell: { [weak self] dataSource, tableView, indexPath, item in
        guard let self = self else { return UITableViewCell()}
        
        if item.payload[indexPath.row].from == UserManager.myUid  {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: MyChatCell.reuseIdentifier, for: indexPath) as? MyChatCell else { return UITableViewCell()}
            cell.setData(data: item.payload[indexPath.row])
            return cell
        } else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: YourChatCell.reuseIdentifier, for: indexPath) as? YourChatCell else { return UITableViewCell()}
            cell.setData(data: item.payload[indexPath.row])
            return cell
        }
    })
    
    override func loadView() {
        self.view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setNavigationController()
        bindingViewModel()
        bindingTableView()
    }
    
    override func setNavigationController() {
        tabBarController?.tabBar.isHidden = true
        navigationController?.navigationBar.isHidden = false
        guard let nick = viewModel.matchedUserData?.matchedNick else { return }
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
                vc.viewModel.matchedUserData = weakSelf.viewModel.matchedUserData
                vc.modalPresentationStyle = .overFullScreen
                weakSelf.present(vc, animated: false)
            }
            .disposed(by: disposeBag)
        
        let input = ChatViewModel.Input(viewWillAppearEvent: self.rx.viewWillAppear)
        let output = viewModel.transform(input: input)
        
        output.fetchFail
            .asDriver(onErrorJustReturn: "")
            .drive { [weak self] error in
                guard let self = self else { return }
                self.view.makeToast(error, duration: 1, position: .center)
            }
            .disposed(by: disposeBag)
        
        output.chat
            .bind(to: mainView.tableView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
    }
    
    private func bindingTableView() {
        
        
            
//        mainView.tableView.rx.setDelegate(self)
//            .disposed(by: disposeBag)

    }
}





