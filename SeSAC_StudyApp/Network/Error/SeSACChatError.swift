//
//  SeSACChatError.swift
//  SeSAC_StudyApp
//
//  Created by Seo Jae Hoon on 2022/12/03.
//

import Foundation

enum SeSACChatError: Int, Error {
    case success = 200
    case fail = 201
    case firebaseTokenError = 401
    case unknownUser = 406
    case serverError = 500
    case clientError = 501
}

extension SeSACChatError: LocalizedError {
    var errorDescription: String?{
        switch self {
        case .success:
            return "채팅전송 성공"
        case .fail:
            return "채팅전송 불가"
        case .firebaseTokenError:
            return nil
        case .unknownUser:
            return "미등록 회원"
        case .serverError:
            return "서버 에러"
        case .clientError:
            return "클라이언트 에러"
        }
    }
}
