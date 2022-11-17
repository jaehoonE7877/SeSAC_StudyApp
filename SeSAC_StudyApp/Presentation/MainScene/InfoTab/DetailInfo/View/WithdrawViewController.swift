//
//  WithdrawViewController.swift
//  SeSAC_StudyApp
//
//  Created by Seo Jae Hoon on 2022/11/17.
//

import UIKit

import RxSwift
import RxCocoa

final class WithdrawViewController: BaseViewController {
    
    private let mainView = WithdrawCheckView()
    
    private let viewModel = DetailViewModel()
    
    private let disposeBag = DisposeBag()
    
    override func loadView() {
        self.view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func setBinding() {
        
        let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene
        let sceneDelegate = windowScene?.delegate as? SceneDelegate
        
        mainView.cancelButton.rx.tap
            .withUnretained(self)
            .bind { weakSelf, _ in
                weakSelf.dismiss(animated: false)
            }
            .disposed(by: disposeBag)
        
        mainView.withdrawButton.rx.tap
            .withUnretained(self)
            .subscribe { weakSelf, _ in
                weakSelf.viewModel.withdraw { result in
                    switch result {
                    case .success(_):
                        break
                    case .failure(let response):
                        switch response{
                        case .success, .alreadySignedup:
                            weakSelf.removeUserManager()
                            let vc = OnboardingViewController()
                            sceneDelegate?.window?.rootViewController = vc
                        default :
                            weakSelf.view.makeToast(response.errorDescription , duration: 1, position: .center)
                        }
                        sceneDelegate?.window?.makeKeyAndVisible()
                    }
                }
            }
            .disposed(by: disposeBag)
    }
}

extension WithdrawViewController {
    
    private func removeUserManager() {
        let keyForUserDefaults = ["onboarding", "authVerificationID", "phone", "token", "nickname", "authDone", "birth", "email", "gender", "nickError"]
        keyForUserDefaults.forEach { UserDefaults.standard.removeObject(forKey: $0)}

    }
    
}
