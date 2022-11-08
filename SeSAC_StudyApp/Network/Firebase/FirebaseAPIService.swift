//
//  FirebaseAPI.swift
//  SeSAC_StudyApp
//
//  Created by Seo Jae Hoon on 2022/11/09.
//

import Foundation

import FirebaseAuth

class FirebaseAPIService {
    
    static let shared = FirebaseAPIService()
    
    func createAuth(phoneNumber: String, completion: @escaping (Result<String, FirebaseError>) -> Void ){
        
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
}
