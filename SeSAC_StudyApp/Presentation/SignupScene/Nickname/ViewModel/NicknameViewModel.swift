//
//  NicknameViewModel.swift
//  SeSAC_StudyApp
//
//  Created by Seo Jae Hoon on 2022/11/10.
//

import Foundation

import RxSwift
import RxCocoa

final class NicknameViewModel: ViewModelType {
    
    private let disposeBag = DisposeBag()
    
    struct Input {
        let nicknameText: ControlProperty<String>
        let nextButtonTapped: ControlEvent<Void>
        let textFieldBeginEdit: ControlEvent<Void>
        let textFieldEndEdit: ControlEvent<Void>
    }
    
    struct Output {
        let nicknameValid: Driver<Bool>
        let nextButtonTapped: ControlEvent<Void>
        let textFieldBeginEdit: ControlEvent<Void>
        let textFieldEndEdit: ControlEvent<Void>
    }
    
    func transform(input: Input) -> Output {
        
        let nicknameValid = input.nicknameText
            .distinctUntilChanged()
            .map { text in
                text.count >= 1 && text.count <= 10
            }
            .asDriver(onErrorJustReturn: false)
        
        return Output(nicknameValid: nicknameValid, nextButtonTapped: input.nextButtonTapped, textFieldBeginEdit: input.textFieldBeginEdit, textFieldEndEdit: input.textFieldEndEdit)
    }
}
