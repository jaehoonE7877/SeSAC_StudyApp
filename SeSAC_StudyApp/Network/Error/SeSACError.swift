//
//  SeSACError.swift
//  SeSAC_StudyApp
//
//  Created by Seo Jae Hoon on 2022/11/09.
//

import Foundation

enum SeSACError: Int, Error {
    case success = 200
    case alreadySignedup = 201
    case forbiddenNick = 202
    case firebaseTokenError = 401
    case unknownUser = 406
    case serverError = 500
    case clientError = 501
}

extension SeSACError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .success:
            return "성공"
        case .alreadySignedup:
            return "이미 가입한 유저입니다."
        case .forbiddenNick:
            return "해당 닉네임은 사용할 수 없습니다."
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
