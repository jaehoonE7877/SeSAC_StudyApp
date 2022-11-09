//
//  FirebaseAPI.swift
//  SeSAC_StudyApp
//
//  Created by Seo Jae Hoon on 2022/11/09.
//

import Foundation

import FirebaseAuth

class DefaultFirebaseAPIService: FirebaseAPIService {
    
    static let shared = DefaultFirebaseAPIService()
    
    func createAuth(phoneNumber: String, completion: @escaping (Result<String, FirebaseError>) -> Void){
        
        PhoneAuthProvider.provider().verifyPhoneNumber(phoneNumber, uiDelegate: nil) { verificationID, error in
            
            if let error = error {
                let errorCode = (error as NSError).code
                switch errorCode {
                case 17010:
                    completion(.failure(.tooManyRequests))
                default :
                    completion(.failure(.etcError))
                }
                return
            }
            guard let verificationID = verificationID else { return }
            
            completion(.success(verificationID))

        }
    }
    
    func requestLogin(verificationCode: String, completion: @escaping (Result<AuthDataResult, FirebaseError>) -> Void) {
        let verificationID = UserDefaults.standard.string(forKey: "authVerificationID") ?? ""
        
        let credential = PhoneAuthProvider.provider().credential(
            withVerificationID:verificationID,
            verificationCode:verificationCode
        )
        
        Auth.auth().signIn(with: credential) { idToken, error in
            
            if let error = error { // 로그인 불일치
                let errorcode = (error as NSError).code
                switch errorcode {
                case 17043, 17045:
                    completion(.failure(.validityExpire))
                case 17044:
                    completion(.failure(.invalidVerificationCode))
                case 17046:
                    completion(.failure(.invalidVericationID))
                default :
                    completion(.failure(.etcError))
                }
            }
            guard let idToken = idToken else { return }
            completion(.success(idToken))
        }
    }
}
