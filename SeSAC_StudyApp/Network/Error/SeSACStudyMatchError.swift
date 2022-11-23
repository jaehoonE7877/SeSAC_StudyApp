//
//  SeSACStudyRequestError.swift
//  SeSAC_StudyApp
//
//  Created by Seo Jae Hoon on 2022/11/23.
//

import Foundation

enum SeSACStudyRequestError: Int, Error {
    case success = 200
    case alreadyRequested = 201
    case friendDodged = 202
    case firebaseTokenError = 401
    case unknownUser = 406
    case serverError = 500
    case clientError = 501
}

extension SeSACStudyRequestError: LocalizedError {
    var errorDescription: String?{
        switch self {
        case .success:
            return "스터디 요청을 보냈습니다."
        case .alreadyRequested:
            return "상대방이 이미 요청했습니다."
        case .friendDodged:
            return "상대방이 스터디 찾기를 그만두었습니다."
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
