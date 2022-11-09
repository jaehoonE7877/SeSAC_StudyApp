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
                vc.mainView.lineView.backgroundColor = .textColor
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
                self.mainView.mainButton.status = valid ? .fill : .disable
            }
            .disposed(by: disposeBag)
        
        output.sendButtonTapped
            .withUnretained(self)
            .bind { vc, _ in
                
                if vc.mainView.mainButton.backgroundColor == .ssGreen {
                    vc.mainView.makeToast("전화 번호 인증 시작", duration: 1, position: .center)
                    vc.viewModel.requestAuth(phoneNumber: vc.formattingNumber()) { result in
                        switch result {
                        case .success(_):
                            UserDefaults.standard.set(vc.formattingNumber(), forKey: "phone")
                            vc.transitionViewController(viewController: AuthViewController(), transitionStyle: .push)
                        case .failure(let error):
                            vc.mainView.makeToast(error.localizedDescription, position: .center)
                        }
                    }
                } else {
                    vc.mainView.makeToast("잘못된 전화번호 형식입니다.", duration: 1, position: .center)
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
