//
//  RequireViewController.swift
//  SeSAC_StudyApp
//
//  Created by Seo Jae Hoon on 2022/11/23.
//

import UIKit

import RxSwift
import RxCocoa

final class RequireViewController: BaseViewController {
    
    private let mainView = MatchPopView(status: .require(title: "스터디를 요청할게요!", subTitle: "상대방이 요청을 수락하면\n채팅창에서 대화를 나눌 수 있어요"))
    
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
                weakSelf.viewModel.requireMatch { statusCode in
                    switch SeSACStudyRequestError(rawValue: statusCode){
                    case .success:
                        weakSelf.dismiss(animated: false) {
                            guard let vc = (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.window?.rootViewController?.topViewController else { return }
                            vc.view.makeToast(SeSACStudyRequestError(rawValue: statusCode)?.localizedDescription ?? "", duration: 1, position: .center)
                        }
                    case .alreadyRequested:
                        //let vc = 채팅뷰컨
//                            guard let vc = (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.window?.rootViewController?.topViewController else { return }
//                            vc.transitionViewController(viewController: <#T##T#>, transitionStyle: .push)
                        print(statusCode)
                    default :
                        weakSelf.view.makeToast(SeSACStudyRequestError(rawValue: statusCode)?.localizedDescription ?? "", position: .center)
                    }
                }
            }
            .disposed(by: disposeBag)
    }
    
    
    
}