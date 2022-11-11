//
//  GenderViewController.swift
//  SeSAC_StudyApp
//
//  Created by Seo Jae Hoon on 2022/11/10.
//

import UIKit

import RxCocoa
import RxSwift

final class GenderViewController: BaseViewController {
    
    private let mainView = GenderView()
    
    private let disposeBag = DisposeBag()
    private let viewModel = GenderViewModel()
    
    override func loadView() {
        self.view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func setBinding() {
        
        let input = GenderViewModel.Input(nextButtonTap: mainView.mainButton.rx.tap,
                                          manButtonTap: mainView.manView.button.rx.tap,
                                          womanButtonTap: mainView.womanView.button.rx.tap)
        let output = viewModel.transform(input: input)
        
        output.manButtonTap
            .withUnretained(self)
            .bind { weakSelf, _ in
                weakSelf.mainView.manView.backgroundColor = .ssWhiteGreen
                weakSelf.mainView.womanView.backgroundColor = .clear
                weakSelf.mainView.mainButton.status = .fill
                weakSelf.mainView.mainButton.isEnabled = true
            }
            .disposed(by: disposeBag)
        
        output.womanButtonTap
            .withUnretained(self)
            .bind { weakSelf, _ in
                weakSelf.mainView.womanView.backgroundColor = .ssWhiteGreen
                weakSelf.mainView.manView.backgroundColor = .clear
                weakSelf.mainView.mainButton.status = .fill
                weakSelf.mainView.mainButton.isEnabled = true
            }
            .disposed(by: disposeBag)
        
        output.nextButtonTap
            .withUnretained(self)
            .bind { weakSelf, _ in
                if weakSelf.mainView.manView.backgroundColor == .ssWhiteGreen {
                    UserManager.gender = Gender.man.rawValue
                    weakSelf.viewModel.signup { result in
                        switch result {
                        case .success(let success):
                            dump(success)
                        case .failure(let error):
                            if error.rawValue == SeSACError.forbiddenNick.rawValue {
                                weakSelf.mainView.makeToast(error.localizedDescription, duration: 1, position: .center)
                                weakSelf.popToNickVC()
                            } else {
                                weakSelf.mainView.makeToast(error.localizedDescription, duration: 1, position: .center)
                            }
                        }
                    }
                } else if weakSelf.mainView.womanView.backgroundColor == .ssWhiteGreen {
                    UserManager.gender = Gender.woman.rawValue
                } else {
                    weakSelf.mainView.makeToast("성별을 선택해주세요", duration: 1, position: .center)
                }
            }
            .disposed(by: disposeBag)

    }
}
extension GenderViewController {
    
    private func popToNickVC() {
        guard let self = self.presentingViewController as? UINavigationController else { return }
        let viewControllerStack = self.viewControllers
        
        self.dismiss(animated: true) {
            for stack in viewControllerStack {
                if let vc = stack as? NicknameViewController {
                    self.popToViewController(vc, animated: true)
                }
            }
        }
    }
    
}

