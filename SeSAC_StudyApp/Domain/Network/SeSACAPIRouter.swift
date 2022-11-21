//
//  EndPoint.swift
//  SeSAC_StudyApp
//
//  Created by Seo Jae Hoon on 2022/11/09.
//

import Foundation
import CoreLocation

import Alamofire

enum SeSACAPIRouter: URLRequestConvertible {
    case login
    case signup
    case mypage(updateData: SeSACInfo)
    case withdraw
    case search(location: CLLocationCoordinate2D)
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
        case .search:
            return URL(string: "\(SeSACConfiguration.baseURL)/v1/queue/search")!
        }
    }
    
    var headers: HTTPHeaders {
        switch self {
        case .login, .signup, .mypage, .withdraw, .search:
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
        case .search:
            return .post
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
        case .search(let location):
            return ["lat": String(location.latitude),
                    "long": String(location.longitude)
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
        case .signup, .mypage, .search:
            return try URLEncoding.default.encode(request, with: parameters)
        }
        
    }
    
    private func saveNumber(phoneNumber: String) -> String {
        let saveText = phoneNumber.components(separatedBy: [" ","-"]).joined()
        return saveText
    }
        
}
