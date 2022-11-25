//
//  SeSACSearchError.swift
//  SeSAC_StudyApp
//
//  Created by Seo Jae Hoon on 2022/11/21.
//

import Foundation

enum SeSACSearchError: Int, Error {
    case success = 200
    case reported = 201
    case penalty_1 = 203
    case penalty_2 = 204
    case penalty_3 = 205
    case firebaseTokenError = 401
    case unknownUser = 406
    case serverError = 500
    case clientError = 501
}

extension SeSACSearchError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .success:
            return "스터디 함께할 친구 찾기 요청 성공"
        case .reported:
            return "신고가 누적되어 이용하실 수 없습니다"
        case .penalty_1:
            return "스터디 취소 패널티로, 1분동안 이용하실 수 없습니다"
        case .penalty_2:
            return "스터디 취소 패널티로, 2분동안 이용하실 수 없습니다"
        case .penalty_3:
            return "스터디 취소 패널티로, 3분동안 이용하실 수 없습니다"
        case .firebaseTokenError:
            return "토큰이 일치하지 않습니다"
        case .unknownUser:
            return "미등록 회원"
        case .serverError:
            return "서버 에러"
        case .clientError:
            return "클라이언트 에러"
        }
    }
}
