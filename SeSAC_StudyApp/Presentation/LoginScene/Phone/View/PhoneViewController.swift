//
//  LoginViewController.swift
//  SeSAC_StudyApp
//
//  Created by Seo Jae Hoon on 2022/11/08.
//

import UIKit

import RxCocoa
import RxSwift

final class PhoneViewController: BaseViewController, Alertable {
    
    private let mainView = PhoneView()
    
    private let disposeBag = DisposeBag()
    private let viewModel = PhoneViewModel()
    
    override func loadView() {
        self.view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tapGesture()
    }
    
    override func setBinding() {
        
        let input = PhoneViewModel.Input(phoneNumberText: mainView.phoneTextField.rx.text.orEmpty,
                                         sendButtonTapped: mainView.mainButton.rx.tap,
                                         textFieldBeginEdit: mainView.phoneTextField.rx.controlEvent(.editingDidBegin),
                                         textFieldEndEdit: mainView.phoneTextField.rx.controlEvent(.editingDidEnd))
        let output = viewModel.transform(input: input)
        
        output.phoneNumberText
            .withUnretained(self)
            .bind { vc, text in
                vc.mainView.phoneTextField.text = text
            }
            .disposed(by: disposeBag)
        
        output.textFieldBeginEdit
            .withUnretained(self)
            .bind { vc, _ in
                vc.mainView.lineView.backgroundColor = .black 
            }
            .disposed(by: disposeBag)
        
        output.textFieldEndEdit
            .withUnretained(self)
            .bind { vc, _ in
                vc.mainView.lineView.backgroundColor = .gray3
            }
            .disposed(by: disposeBag)
        
        output.phoneNumberValid
            .drive { [weak self] valid in
                guard let self = self else { return }
                self.mainView.mainButton.isEnabled = valid
                self.mainView.mainButton.status = valid ? .fill : .disable
            }
            .disposed(by: disposeBag)
        
        output.sendButtonTapped
            .withUnretained(self)
            .bind { vc, _ in
                vc.transitionViewController(viewController: AuthViewController(), transitionStyle: .push)
            }
            .disposed(by: disposeBag)
    }
    
    private func tapGesture(){
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapEndEditing))
        view.addGestureRecognizer(tap)
    }
    
    @objc private func tapEndEditing(){
        view.endEditing(true)
    }
}
