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
        
    }
    
    override func setBinding() {
        
        let input = PhoneViewModel.Input(phoneNumberText: mainView.phoneTextField.rx.text.orEmpty,
                                         sendButtonTapped: mainView.mainButton.rx.tap,
                                         textFieldEditing: mainView.phoneTextField.rx.controlEvent([.editingDidBegin]))
        let output = viewModel.transform(input: input)
        
        output.phoneNumberText
            .withUnretained(self)
            .bind { vc, text in
                vc.mainView.phoneTextField.text = text
            }
            .disposed(by: disposeBag)
        
        output.textFieldEditing
            .withUnretained(self)
            .bind { vc, _ in
                vc.mainView.lineView.backgroundColor = .black 
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
                vc.showAlert(title: "확인", button: "확인")
            }
            .disposed(by: disposeBag)
        
        
    }
}
