//
//  LoginViewController.swift
//  SeSAC_StudyApp
//
//  Created by Seo Jae Hoon on 2022/11/08.
//

import UIKit

import RxCocoa
import RxSwift
import Toast

final class PhoneViewController: BaseViewController {
    
    private let mainView = PhoneView()
    
    private let disposeBag = DisposeBag()
    private let viewModel = PhoneViewModel()
    
    override func loadView() {
        self.view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if UserManager.authDone == 406 {
            let vc = NicknameViewController()
            self.transitionViewController(viewController: vc, transitionStyle: .pushWithoutAni)
        }
    }
    
    override func setBinding() {
        
        let input = PhoneViewModel.Input(phoneNumberText: mainView.phoneTextField.rx.text.orEmpty,
                                         sendButtonTapped: mainView.mainButton.rx.tap,
                                         textFieldBeginEdit: mainView.phoneTextField.rx.controlEvent(.editingDidBegin),
                                         textFieldEndEdit: mainView.phoneTextField.rx.controlEvent(.editingDidEnd))
        let output = viewModel.transform(input: input)
        
        output.phoneNumberText
            .withUnretained(self)
            .bind { weakSelf, text in
                weakSelf.mainView.phoneTextField.text = text
            }
            .disposed(by: disposeBag)
        
        output.textFieldBeginEdit
            .withUnretained(self)
            .bind { weakSelf, _ in
                weakSelf.mainView.lineView.backgroundColor = .textColor
            }
            .disposed(by: disposeBag)
        
        output.textFieldEndEdit
            .withUnretained(self)
            .bind { weakSelf, _ in
                weakSelf.mainView.lineView.backgroundColor = .gray3
            }
            .disposed(by: disposeBag)
        
        output.phoneNumberValid
            .drive { [weak self] valid in
                guard let self = self else { return }
                self.mainView.mainButton.status = valid ? .fill : .disable
            }
            .disposed(by: disposeBag)
        
        output.sendButtonTapped
            .withUnretained(self)
            .bind { weakSelf, _ in
                if weakSelf.mainView.mainButton.backgroundColor == .ssGreen {
                    weakSelf.mainView.makeToast(LoginMessage.phoneValidOk, duration: 1, position: .center)
                    weakSelf.viewModel.requestAuth(phoneNumber: weakSelf.formattingNumber()) { result in
                        switch result {
                        case .success(_):
                            UserManager.phone = weakSelf.formattingNumber()
                            weakSelf.transitionViewController(viewController: AuthViewController(), transitionStyle: .push)
                        case .failure(let error):
                            weakSelf.mainView.makeToast(error.localizedDescription, position: .center)
                        }
                    }
                } else {
                    weakSelf.mainView.makeToast(LoginMessage.phoneValidError, duration: 1, position: .center)
                }
            }
            .disposed(by: disposeBag)
    }
    
    private func formattingNumber() -> String {
        guard var text = mainView.phoneTextField.text else { return ""}
        text.remove(at: text.startIndex)
        let formater = "+82 " + text
        return formater
    }
}
