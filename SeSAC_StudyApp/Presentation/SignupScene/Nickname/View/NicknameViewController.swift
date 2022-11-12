//
//  NicknameViewController.swift
//  SeSAC_StudyApp
//
//  Created by Seo Jae Hoon on 2022/11/10.
//

import UIKit

import RxSwift
import RxCocoa

final class NicknameViewController: BaseViewController {
    
    private let mainView = NicknameView()
    
    private let disposeBag = DisposeBag()
    private let viewModel = NicknameViewModel()
    
    override func loadView() {
        self.view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setNavigationController()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if mainView.nicknameTextField.text == "" {
            UserManager.nickError = false
        }
    }
    
    override func setBinding() {
        
        let input = NicknameViewModel.Input(nicknameText: mainView.nicknameTextField.rx.text.orEmpty,
                                            nextButtonTapped: mainView.mainButton.rx.tap,
                                            textFieldBeginEdit: mainView.nicknameTextField.rx.controlEvent(.editingDidBegin),
                                            textFieldEndEdit: mainView.nicknameTextField.rx.controlEvent(.editingDidEnd))
        let output = viewModel.transform(input: input)
        
        output.nicknameValid
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
                if weakSelf.mainView.mainButton.backgroundColor == .ssGreen {
                    guard let nickname = weakSelf.mainView.nicknameTextField.text else { return }
                    UserManager.nickname = nickname
                    weakSelf.transitionViewController(viewController: BirthViewController(), transitionStyle: .push)
                } else {
                    weakSelf.mainView.makeToast(SignupMessage.nicknameLength, duration: 1, position: .center)
                }
            }
            .disposed(by: disposeBag)
    }
}
