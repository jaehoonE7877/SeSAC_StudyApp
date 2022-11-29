//
//  AcceptViewController.swift
//  SeSAC_StudyApp
//
//  Created by Seo Jae Hoon on 2022/11/25.
//

import UIKit

import RxSwift
import RxCocoa

final class AccecptViewController: BaseViewController {
    
    private let mainView = MatchPopView(status: .accecpt(title: "스터디를 수락할까요?", subTitle: "요청을 수락하면 채팅창에서 대화를 나눌 수 있어요"))
    
    let viewModel = SeSACSearchViewModel()
    
    private let disposeBag = DisposeBag()
    
    override func loadView() {
        self.view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func setBinding() {
        
        mainView.cancelButton.rx.tap
            .withUnretained(self)
            .bind { weakSelf, _ in
                weakSelf.dismiss(animated: false)
            }
            .disposed(by: disposeBag)
        
        mainView.matchButton.rx.tap
            .withUnretained(self)
            .subscribe { weakSelf, _ in
                weakSelf.viewModel.acceptMatch { statusCode in
                    switch SeSACStudyAcceptError(rawValue: statusCode){
                    case .success:
                        weakSelf.viewModel.getMyStatus { result in
                            switch result{
                            case .success(let matchedUser):
                                weakSelf.dismiss(animated: false) {
                                    let chatVC = ChatViewController()
                                    chatVC.title = matchedUser.matchedNick
                                    chatVC.viewModel.matchedUserData = matchedUser
                                    guard let vc = (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.window?.rootViewController?.topViewController else { return }
                                    NotificationCenter.default.post(name: NSNotification.Name("timer"), object: nil)
                                    vc.transitionViewController(viewController: chatVC, transitionStyle: .push)
                                }
                            case .failure(let error):
                                weakSelf.view.makeToast(error.errorDescription, position: .center)
                            }
                        }
                    default:
                        weakSelf.dismiss(animated: false) {
                            guard let vc = (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.window?.rootViewController?.topViewController else { return }
                            vc.view.makeToast(SeSACStudyAcceptError(rawValue: statusCode)?.localizedDescription, position: .center)
                        }
                    }
                }
            }
            .disposed(by: disposeBag)
    }
    
}
