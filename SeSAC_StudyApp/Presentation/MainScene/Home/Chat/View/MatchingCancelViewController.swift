//
//  MatchingCancelViewController.swift
//  SeSAC_StudyApp
//
//  Created by Seo Jae Hoon on 2022/11/28.
//

import UIKit

import RxSwift
import RxCocoa

final class MatchingCancelViewController: BaseViewController {
    
    private let disposeBag = DisposeBag()
    let viewModel = ChatViewModel()
    
    private let mainView = PopView(title: "스터디를 취소하겠습니까?", subtitle: "스터디를 취소하시면 패널티가 부과됩니다")
    
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
            .bind { weakSelf, _ in
                weakSelf.viewModel.cancelMatch { statusCode in
                    switch SeSACDodgeError(rawValue: statusCode){
                    case .success:
                        weakSelf.dismiss(animated: false) {
                            guard let vc = (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.window?.rootViewController?.topViewController else { return }
                            vc.navigationController?.popToRootViewController(animated: false)
                        }
                    default:
                        weakSelf.view.makeToast(SeSACDodgeError(rawValue: statusCode)?.errorDescription, position: .center)
                    }
                }
            }
            .disposed(by: disposeBag)
    }
    
}
