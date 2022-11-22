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
    case match
    case queuePost(location: CLLocationCoordinate2D, studylist: [String])
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
        case .match:
            return URL(string: "\(SeSACConfiguration.baseURL)/v1/queue/myQueueState")!
        case .queuePost:
            return URL(string: "\(SeSACConfiguration.baseURL)/v1/queue")!
        }
    }
    
    var headers: HTTPHeaders {
        switch self {
        case .login, .signup, .mypage, .withdraw, .search, .match, .queuePost:
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
        case .match:
            return .get
        case .queuePost:
            return .post
        }
    }
    
    var parameters: Parameters {
        
        switch self {
        case .login, .withdraw, .match:
            return ["" : ""]
        case .signup:
            guard let birth = UserManager.birth,
                  let email = UserManager.email,
                  let gender = UserManager.gender else { return ["" : ""] }
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
            return ["lat": "\(location.latitude)",
                    "long": "\(location.longitude)"
                    ]
        case .queuePost(let location, let studylist):
            return ["lat": "\(location.latitude)",
                    "long": "\(location.longitude)",
                    "studylist": studylist
                    ]
        }
    }
    
    func asURLRequest() throws -> URLRequest {
        
        var request = URLRequest(url: url)
        request.method = method
        request.headers = headers
        
        switch self {
        case .login, .withdraw, .match:
            return request
        case .signup, .mypage, .search, .queuePost:
            return try URLEncoding(arrayEncoding: .noBrackets).encode(request, with: parameters)
        }
        
    }
    
    private func saveNumber(phoneNumber: String) -> String {
        let saveText = phoneNumber.components(separatedBy: [" ","-"]).joined()
        return saveText
    }
        
}
