//
//  EndPoint.swift
//  SeSAC_StudyApp
//
//  Created by Seo Jae Hoon on 2022/11/09.
//

import Foundation
import CoreLocation

import Alamofire
// 라우터 파일 자체를 분리 (user queue, chat)
enum SeSACAPIRouter: URLRequestConvertible {
    case login
    case signup
    case mypage(updateData: SeSACInfo)
    case withdraw
    case search(location: CLLocationCoordinate2D)
    case match
    case queuePost(location: CLLocationCoordinate2D, studylist: [String])
    case queueDelete
    case require(otheruid: String)
    case accept(otheruid: String)
    case dodge(otheruid: String)
    case fetchChat(from: String, lastchatDate: String)
    case sendChat(chat: String, to: String)
    case updateFCM(fcmToken: String)
    case writeReview(otheruid: String, reputation: String, comment: String)
    case shopMyinfo
    case ios(product: String, receipt: String)
}

extension SeSACAPIRouter {

    var url: URL {
        switch self {
        case .login, .signup:
            return URL(string: "\(SeSACConfiguration.baseURL)/\(Version.ver)/user")!
        case .withdraw:
            return URL(string: "\(SeSACConfiguration.baseURL)/\(Version.ver)/user/withdraw")!
        case .mypage:
            return URL(string: "\(SeSACConfiguration.baseURL)/\(Version.ver)/user/mypage")!
        case .search:
            return URL(string: "\(SeSACConfiguration.baseURL)/\(Version.ver)/queue/search")!
        case .match:
            return URL(string: "\(SeSACConfiguration.baseURL)/\(Version.ver)/queue/myQueueState")!
        case .queuePost, .queueDelete:
            return URL(string: "\(SeSACConfiguration.baseURL)/\(Version.ver)/queue")!
        case .require:
            return URL(string: "\(SeSACConfiguration.baseURL)/\(Version.ver)/queue/studyrequest")!
        case .accept:
            return URL(string: "\(SeSACConfiguration.baseURL)/\(Version.ver)/queue/studyaccept")!
        case .dodge:
            return URL(string: "\(SeSACConfiguration.baseURL)/\(Version.ver)/queue/dodge")!
        case .fetchChat(let from, _):
            return URL(string: "\(SeSACConfiguration.baseURL)/\(Version.ver)/chat/\(from)")!
        case .sendChat(_ ,let to):
            return URL(string: "\(SeSACConfiguration.baseURL)/\(Version.ver)/chat/\(to)")!
        case .updateFCM:
            return URL(string: "\(SeSACConfiguration.baseURL)/\(Version.ver)/user/update_fcm_token")!
        case .writeReview(let otheruid, _ , _):
            return URL(string: "\(SeSACConfiguration.baseURL)/\(Version.ver)/queue/rate/\(otheruid)")!
        case .shopMyinfo:
            return URL(string: "\(SeSACConfiguration.baseURL)/\(Version.ver)/user/shop/myinfo")!
        case .ios:
            return URL(string: "\(SeSACConfiguration.baseURL)/\(Version.ver)/user/shop/ios")!
        }
    }
    
    var headers: HTTPHeaders {
        switch self {
        case .login, .signup, .mypage, .withdraw, .search, .match, .queuePost, .queueDelete, .require, .accept, .dodge, .fetchChat, .sendChat, .updateFCM, .writeReview, .shopMyinfo, .ios :
            return [
                "idtoken": UserManager.token,
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
        case .queueDelete:
            return .delete
        case .require:
            return .post
        case .accept:
            return .post
        case .dodge:
            return .post
        case .fetchChat:
            return .get
        case .sendChat:
            return .post
        case .updateFCM:
            return .put
        case .writeReview:
            return .post
        case .shopMyinfo:
            return .get
        case .ios:
            return .post
        }
    }
    
    var parameters: Parameters {
        
        switch self {
        case .login, .withdraw, .match, .queueDelete, .shopMyinfo:
            return ["" : ""]
        case .signup:
            guard let birth = UserManager.birth,
                  let email = UserManager.email,
                  let gender = UserManager.gender else { return ["" : ""] }
            return [
                "phoneNumber" : saveNumber(phoneNumber: UserManager.phone),
                "FCMtoken" : UserManager.fcmToken,
                "nick" : UserManager.nickname,
                "birth" : birth.yyyyMMddTHHmmssSSZ,
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
        case .require(let otheruid):
            return ["otheruid": otheruid]
        case .accept(let otheruid):
            return ["otheruid": otheruid]
        case .dodge(let otheruid):
            return ["otheruid": otheruid]
        case .fetchChat(_ , let lastchatDate):
            return ["lastchatDate" : lastchatDate]
        case .sendChat(let chat, _):
            return ["chat" : chat]
        case .updateFCM(let fcmToken):
            return ["FCMtoken" : fcmToken]
        case .writeReview(let otheruid, let reputation, let comment):
            return [
                "otheruid" : otheruid,
                "reputation" : reputation,
                "comment" : comment
                ]
        case .ios(let product, let receipt):
            return [
                "receipt" : receipt,
                "product" : product
                ]
        }
    }
    
    func asURLRequest() throws -> URLRequest {
        
        var request = URLRequest(url: url)
        request.method = method
        request.headers = headers
        
        switch self {
        case .login, .withdraw, .match, .queueDelete, .shopMyinfo:
            return request
        case .signup, .mypage, .search, .queuePost, .require, .accept, .dodge, .fetchChat, .sendChat, .updateFCM, .writeReview, .ios:
            return try URLEncoding(arrayEncoding: .noBrackets).encode(request, with: parameters)
        }
        
    }
    
    private func saveNumber(phoneNumber: String) -> String {
        let saveText = phoneNumber.components(separatedBy: [" ","-"]).joined()
        return saveText
    }
        
}
