//
//  EmailViewController.swift
//  SeSAC_StudyApp
//
//  Created by Seo Jae Hoon on 2022/11/10.
//

import UIKit

import RxCocoa
import RxSwift

final class EmailViewController: BaseViewController {
    
    private let mainView = EmailView()
    
    private let disposeBag = DisposeBag()
    private let viewModel = EmailViewModel()
    
    override func loadView() {
        self.view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
    }
    
    override func setBinding() {
        let input = EmailViewModel.Input(emailText: mainView.emailTextField.rx.text.orEmpty,
                                         nextButtonTapped: mainView.mainButton.rx.tap,
                                         textFieldBeginEdit: mainView.emailTextField.rx.controlEvent(.editingDidBegin),
                                         textFieldEndEdit: mainView.emailTextField.rx.controlEvent(.editingDidEnd))
        let output = viewModel.transform(input: input)
        
        output.emailValid
            .drive { [weak self] valid in
                guard let self = self else { return }
                self.mainView.mainButton.status = valid ? .fill : .disable
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
        
        output.nextButtonTapped
            .withUnretained(self)
            .bind { weakSelf, _ in
                if weakSelf.mainView.mainButton.status == .fill {
                    guard let email = weakSelf.mainView.emailTextField.text else { return }
                    UserManager.email = email
                    weakSelf.transitionViewController(viewController: GenderViewController(), transitionStyle: .push)
                } else {
                    weakSelf.mainView.makeToast(SignupMessage.emailValid, duration: 1, position: .center)
                }
            }
            .disposed(by: disposeBag)
    }
}
