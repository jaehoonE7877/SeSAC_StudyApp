//
//  AuthViewModel.swift
//  SeSAC_StudyApp
//
//  Created by Seo Jae Hoon on 2022/11/08.
//

import Foundation

import FirebaseAuth
import RxSwift
import RxCocoa

final class AuthViewModel: ViewModelType{
    
    let firebaseApiService = DefaultFirebaseAPIService.shared
    
    struct Input {
        let verifyText: ControlProperty<String>
        let textFieldBeginEdit: ControlEvent<Void>
        let textFieldEndEdit: ControlEvent<Void>
        let resendButtonTap: ControlEvent<Void>
        let verifyButtonTap: ControlEvent<Void>
    }
    
    struct Output {
        let verifyTextValid: Driver<Bool>
        let timer: Observable<Int>
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

        let timer = Observable<Int>
            .timer(.seconds(1), period: .seconds(1), scheduler: MainScheduler.instance)

        return Output(verifyTextValid: textValid, timer: timer, textFieldBeginEdit: input.textFieldBeginEdit, textFieldEndEdit: input.textFieldEndEdit, resendButtonTap: input.resendButtonTap, verifyButtonTap: input.verifyButtonTap)
   }
    
}

extension AuthViewModel {
    
    func requestAuth(phoneNumber: String, completion: @escaping ((Result<String, FirebaseError>) -> Void)) {
        firebaseApiService.createAuth(phoneNumber: phoneNumber) { result in
            switch result {
            case .success(let verificationID):
                UserDefaults.standard.set(verificationID, forKey: "authVerificationID")
                completion(.success(verificationID))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func requestLogin(verificationCode: String, completion: @escaping ((Result<AuthDataResult,FirebaseError>) -> Void)) {
        firebaseApiService.requestLogin(verificationCode: verificationCode) { result in
            switch result{
            case .success(let idToken):
                completion(.success(idToken))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
