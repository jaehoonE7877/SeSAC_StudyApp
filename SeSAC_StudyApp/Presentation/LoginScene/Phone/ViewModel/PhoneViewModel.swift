//
//  LoginViewModel.swift
//  SeSAC_StudyApp
//
//  Created by Seo Jae Hoon on 2022/11/08.
//

import Foundation

import RxCocoa
import RxSwift

final class PhoneViewModel: ViewModelType {
    
    private let disposeBag = DisposeBag()
    private let firebaseApiService = DefaultFirebaseAPIService.shared
        
    struct Input{
        let phoneNumberText: ControlProperty<String>
        let sendButtonTapped: ControlEvent<Void>
        let textFieldBeginEdit: ControlEvent<Void>
        let textFieldEndEdit: ControlEvent<Void>
    }
    
    struct Output {
        let phoneNumberValid: Driver<Bool>
        let phoneNumberText: Observable<String>
        let sendButtonTapped: ControlEvent<Void>
        let textFieldBeginEdit: ControlEvent<Void>
        let textFieldEndEdit: ControlEvent<Void>
    }
    
    func transform(input: Input) -> Output {
        
        let phoneText = input.phoneNumberText
            .distinctUntilChanged()
            .map { text in
                switch text.count {
                case 13:
                    return text.formated(by: "###-####-####")
                default :
                    return text.formated(by: "###-###-####")
                }
            }
        
        let phoneValid = phoneText
            .withUnretained(self)
            .map { vm, phone in
                vm.isValidPhone(phone: phone)
            }
            .asDriver(onErrorJustReturn: false)

        return Output(phoneNumberValid: phoneValid, phoneNumberText: phoneText, sendButtonTapped: input.sendButtonTapped, textFieldBeginEdit: input.textFieldBeginEdit, textFieldEndEdit: input.textFieldEndEdit)
    }
    
    private func isValidPhone(phone: String) -> Bool {
        let phoneReg = "^01(0)-?([0-9]{3,4})-?([0-9]{4})$"
        let pred = NSPredicate(format: "SELF MATCHES %@", phoneReg)
        return pred.evaluate(with: phone)
    }
    
}

extension PhoneViewModel {
    
    func requestAuth(phoneNumber: String, completion: @escaping ((Result<String, FirebaseError>) -> Void) ) {
        print(phoneNumber)
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
    
}
