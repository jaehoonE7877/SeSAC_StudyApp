//
//  EmailViewModel.swift
//  SeSAC_StudyApp
//
//  Created by Seo Jae Hoon on 2022/11/10.
//

import Foundation

import RxCocoa
import RxSwift

final class EmailViewModel: ViewModelType {
    
    struct Input {
        let emailText: ControlProperty<String>
        let nextButtonTapped: ControlEvent<Void>
        let textFieldBeginEdit: ControlEvent<Void>
        let textFieldEndEdit: ControlEvent<Void>
    }
    
    struct Output {
        let emailValid: Driver<Bool>
        let nextButtonTapped: ControlEvent<Void>
        let textFieldBeginEdit: ControlEvent<Void>
        let textFieldEndEdit: ControlEvent<Void>
    }
    
    func transform(input: Input) -> Output {
        
        let emailValid = input.emailText
            .distinctUntilChanged()
            .withUnretained(self)
            .map { weakSelf, text in
                weakSelf.validateEmail(text)
            }
            .asDriver(onErrorJustReturn: false)
        
        return Output(emailValid: emailValid, nextButtonTapped: input.nextButtonTapped, textFieldBeginEdit: input.textFieldBeginEdit, textFieldEndEdit: input.textFieldEndEdit)
    }
    
    private func validateEmail(_ text: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: text)
    }
}
