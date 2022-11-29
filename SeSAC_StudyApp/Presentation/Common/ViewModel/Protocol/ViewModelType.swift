//
//  ViewModelType.swift
//  SeSAC_StudyApp
//
//  Created by Seo Jae Hoon on 2022/11/07.
//

import Foundation

import FirebaseAuth

protocol ViewModelType: AnyObject {
    associatedtype Input
    associatedtype Output
    func transform(input: Input) -> Output
}

extension ViewModelType {
    func validateEmail(_ text: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: text)
    }
    
    func refreshToken(){
        let currentUser = Auth.auth().currentUser
        currentUser?.getIDTokenForcingRefresh(true) { idToken, error in
            if let error = error {
                print(error)
            }
            guard let token = idToken else { return }
            UserManager.token = token
        }
    }
    
    func refreshToken(completion : @escaping () -> Void){
        let currentUser = Auth.auth().currentUser
        currentUser?.getIDTokenForcingRefresh(true) { idToken, error in
            if let error = error {
                print(error)
            }
            guard let token = idToken else { return }
            UserManager.token = token
            completion()
        }
    }
}

