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
        //let timerText: ControlProperty<String>
        let textFieldBeginEdit: ControlEvent<Void>
        let textFieldEndEdit: ControlEvent<Void>
        let resendButtonTap: ControlEvent<Void>
        let verifyButtonTap: ControlEvent<Void>
    }
    
    struct Output {
        let verifyTextValid: Driver<Bool> // 버튼 스타일 바꿀 때
        //let timerText: Driver<Bool> // 타이머
        let textFieldBeginEdit: ControlEvent<Void> //라인
        let textFieldEndEdit: ControlEvent<Void> //라인
        let resendButtonTap: ControlEvent<Void> //재전송 요청
        let verifyButtonTap: ControlEvent<Void> // 파베 가입
    }
    
    func transform(input: Input) -> Output {

        let textValid = input.verifyText
            .map { text in
                text.count == 6
            }
            .asDriver(onErrorJustReturn: false)

        let timerText = input.timerText
            .map {
                Int($0)
            }
            .asDriver(onErrorJustReturn: 10)

        return Output(verifyTextValid: textValid, textFieldBeginEdit: input.textFieldBeginEdit, textFieldEndEdit: input.textFieldEndEdit, resendButtonTap: input.resendButtonTap, verifyButtonTap: input.verifyButtonTap)
   }
}
