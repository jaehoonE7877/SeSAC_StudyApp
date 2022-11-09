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
}

extension SeSACAPIRouter {
    
    var url: URL {
        switch self {
        case .login:
            return URL(string: "\(SeSACConfiguration.baseURL)/v1/user")!
        }
    }
    
    var headers: HTTPHeaders {
        switch self {
        case .login:
            return [
                "idtoken": "\(String(describing: UserDefaults.standard.string(forKey: "token")))",
                "Content-Type": "application/x-www-form-urlencoded",
                "accept": "application/json"
            ]
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .login:
            return .get
        }
    }
    
    var parameters: [String: String] {
        switch self {
        case .login:
            return ["" : ""]
        }
    }
    
    func asURLRequest() throws -> URLRequest {
        
        var request = try URLRequest(url: url)
        request.method = method
        request.headers = headers
        
        switch self {
        case .login:
            request = try URLEncoding.default.encode(request, with: parameters)
        }
        
        return request
    }
        
}
