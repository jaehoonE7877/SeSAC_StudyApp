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
    case mypage(updateData: SeSACInfo)
    case withdraw
}

extension SeSACAPIRouter {
    
    var url: URL {
        switch self {
        case .login, .signup:
            return URL(string: "\(SeSACConfiguration.baseURL)/v1/user")!
        case .withdraw:
            return URL(string: "\(SeSACConfiguration.baseURL)/v1/user/withdraw")!
        case .mypage:
            return URL(string: "\(SeSACConfiguration.baseURL)/v1/user/mypage")!
        }
    }
    
    var headers: HTTPHeaders {
        switch self {
        case .login, .signup, .mypage, .withdraw:
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
        case .signup, .withdraw:
            return .post
        case .mypage:
            return .put
        }
    }
    
    var parameters: [String: String] {
        
        guard let birth = UserManager.birth,
              let email = UserManager.email,
              let gender = UserManager.gender else { return ["" : ""] }
        
        switch self {
        case .login, .withdraw:
            return ["" : ""]
        case .signup:
            return [
                "phoneNumber" : saveNumber(phoneNumber: UserManager.phone),
                "FCMtoken" : UserManager.fcmToken,
                "nick" : UserManager.nickname,
                "birth" : "\(birth.yyyyMMddTHHmmssSSZ)",
                "email" : email,
                "gender" : String(gender)
            ]
        case .mypage(let data):
            return [
                "searchable" : String(data.searchable),
                "ageMin" : String(data.ageMin),
                "ageMax" : String(data.ageMax),
                "gender" : String(data.gender),
                "study" : data.study
                ]
        }
    }
    
    func asURLRequest() throws -> URLRequest {
        
        var request = URLRequest(url: url)
        request.method = method
        request.headers = headers
        
        switch self {
        case .login, .withdraw:
            return request
        case .signup, .mypage:
            return try URLEncoding.default.encode(request, with: parameters)
        }
        
    }
    
    private func saveNumber(phoneNumber: String) -> String {
        let saveText = phoneNumber.components(separatedBy: [" ","-"]).joined()
        return saveText
    }
        
}
