//
//  FirebaseAPIService.swift
//  SeSAC_StudyApp
//
//  Created by Seo Jae Hoon on 2022/11/09.
//

import Foundation

import FirebaseAuth

protocol FirebaseAPIService {
    func createAuth(phoneNumber: String, completion: @escaping (Result<String, FirebaseError>) -> Void)
    func requestLogin(verificationCode: String, completion: @escaping (Result<AuthDataResult, FirebaseError>) -> Void)
}
