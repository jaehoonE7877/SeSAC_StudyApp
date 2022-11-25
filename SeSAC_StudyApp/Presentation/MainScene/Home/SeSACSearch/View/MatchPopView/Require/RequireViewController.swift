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
    
    private let mainView = RequireView()
    
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
        
        mainView.withdrawButton.rx.tap
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
                        print(statusCode)
                    default :
                        weakSelf.view.makeToast(SeSACStudyRequestError(rawValue: statusCode)?.localizedDescription ?? "", position: .center)
                    }
                }
            }
            .disposed(by: disposeBag)
    }
    
    
    
}
