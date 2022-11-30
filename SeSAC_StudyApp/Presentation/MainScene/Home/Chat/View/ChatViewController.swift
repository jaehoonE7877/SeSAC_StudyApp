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
        NotificationCenter.default.addObserver(self, selector: #selector(getMessage(notification:)), name: NSNotification.Name("getMessage"), object: nil)
        setNavigationController()
        bindingViewModel()
        
        
    }
    
    @objc func getMessage(notification: NSNotification) {
            
        let id = notification.userInfo!["_id"] as! String
        let chat = notification.userInfo!["chat"] as! String
        let createdAt = notification.userInfo!["createdAt"] as! String
        let from = notification.userInfo!["from"] as! String
        let to = notification.userInfo!["to"] as! String
        
        let value = ChatData(id: id, to: to, from: from, chat: chat, createdAt: createdAt)
        
        self.viewModel.sections.append(ChatSectionModel(items: [value]))
        self.viewModel.chat.onNext(viewModel.sections)
        self.mainView.tableView.reloadData()
        self.mainView.tableView.scrollToRow(at: IndexPath(row: self.viewModel.sections.count - 1, section: 0), at: .bottom, animated: false)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        SocketIOManager.shared.closeConnection()
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
        
        let dataSource = RxTableViewSectionedReloadDataSource<ChatSectionModel>(configureCell: { dataSource, tableView, indexPath, item in
            
            if item.from == UserManager.myUid {
                guard let cell = tableView.dequeueReusableCell(withIdentifier: MyChatCell.reuseIdentifier, for: indexPath) as? MyChatCell else { return UITableViewCell()}
                cell.setData(data: item)
                return cell
            } else {
                guard let cell = tableView.dequeueReusableCell(withIdentifier: YourChatCell.reuseIdentifier, for: indexPath) as? YourChatCell else { return UITableViewCell()}
                cell.setData(data: item)
                return cell
            }
            
        })
        
        let input = ChatViewModel.Input(viewWillAppearEvent: self.rx.viewWillAppear,
                                        sendButtonTap: mainView.sendButton.rx.tap)
        let output = viewModel.transform(input: input)
        
        output.fetchFail
            .asDriver(onErrorJustReturn: "")
            .drive { [weak self] error in
                guard let self = self else { return }
                self.view.makeToast(error, duration: 1, position: .center)
            }
            .disposed(by: disposeBag)
        
        viewModel.chat
            .bind(to: mainView.tableView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
    }

}
