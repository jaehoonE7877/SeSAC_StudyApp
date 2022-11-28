//
//  SeSACDodgeError.swift
//  SeSAC_StudyApp
//
//  Created by Seo Jae Hoon on 2022/11/28.
//

import Foundation

enum SeSACDodgeError: Int, Error {
    case success = 200
    case wrongUid = 201
    case firebaseTokenError = 401
    case unknownUser = 406
    case serverError = 500
    case clientError = 501
}

extension SeSACDodgeError: LocalizedError {
    var errorDescription: String?{
        switch self {
        case .success:
            return "스터디 요청을 보냈습니다."
        case .wrongUid:
            return "상대방이 이미 요청했습니다."
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
