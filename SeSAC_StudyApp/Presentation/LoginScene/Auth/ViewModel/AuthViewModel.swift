//
//  AuthViewModel.swift
//  SeSAC_StudyApp
//
//  Created by Seo Jae Hoon on 2022/11/08.
//

import Foundation

import RxSwift
import RxCocoa

final class AuthViewModel: ViewModelType{
    
    struct Input {
        let verifyText: ControlProperty<String>
        let timerText: ControlProperty<String>
        let resendButtonTap: ControlEvent<Void>
        let verifyButtonTap: ControlEvent<Void>
    }
    
    struct Output {
        let verifyTextValid: Driver<Bool>
        let timerText: Observable<String>
        let textFieldBeginEdit: ControlEvent<Void>
        let textFieldEndEdit: ControlEvent<Void>
        let resendButtonTap: ControlEvent<Void>
        let verifyButtonTap: ControlEvent<Void>
    }
    
    func transform(input: Input) -> Output {

        let textValid = input.verifyText
            .map { text in
                text.count == 6
            }
            .asDriver(onErrorJustReturn: false)

        let timerText = input.timerText

        return Output(verifyTextValid: textValid, timerText: <#T##Observable<String>#>, textFieldBeginEdit: <#T##ControlEvent<Void>#>, textFieldEndEdit: <#T##ControlEvent<Void>#>, resendButtonTap: <#T##ControlEvent<Void>#>, verifyButtonTap: <#T##ControlEvent<Void>#>)
   }
}
