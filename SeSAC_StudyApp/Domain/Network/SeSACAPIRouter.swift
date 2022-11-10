//
//  EndPoint.swift
//  SeSAC_StudyApp
//
//  Created by Seo Jae Hoon on 2022/11/09.
//

import Foundation
import Alamofire

enum SeSACAPIRouter: URLRequestConvertible {
    case login
    case signup
}

extension SeSACAPIRouter {
    
    var url: URL {
        switch self {
        case .login, .signup:
            return URL(string: "\(SeSACConfiguration.baseURL)/v1/user")!
        }
    }
    
    var headers: HTTPHeaders {
        switch self {
        case .login, .signup:
            return [
                "idtoken": "\(UserManager.token)",
                "Content-Type": "application/x-www-form-urlencoded",
            ]
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .login:
            return .get
        case .signup:
            return .post
        }
    }
    
    var parameters: [String: String] {
        guard let gender = UserManager.gender else { return ["" : ""] }
        
        switch self {
        case .login:
            return ["" : ""]
        case .signup:
            return [
                "phoneNumber" : saveNumber(phoneNumber: UserManager.phone),
                "FCMtoken" : UserManager.fcmToken,
                "nick" : UserManager.nickname,
                "birth" : UserManager.birth,
                "email" : UserManager.email,
                "gender" : String(gender)
            ]
        }
    }
    
    func asURLRequest() throws -> URLRequest {
        
        var request = URLRequest(url: url)
        request.method = method
        request.headers = headers
        
        switch self {
        case .login:
            return request
        case .signup:
            return try URLEncoding.default.encode(request, with: parameters)
        }
        
    }
    
    private func saveNumber(phoneNumber: String) -> String {
        let saveText = phoneNumber.components(separatedBy: [" ","-"]).joined()
        return saveText
    }
        
}
