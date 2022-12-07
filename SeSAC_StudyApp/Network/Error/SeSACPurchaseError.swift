//
//  SeSACPurchaseError.swift
//  SeSAC_StudyApp
//
//  Created by Seo Jae Hoon on 2022/12/07.
//

import Foundation

enum SeSACPurchaseError: Int, Error {
    case success = 200
    case receiptError = 201
    case firebaseTokenError = 401
    case unknownUser = 406
    case serverError = 500
    case clientError = 501
}

extension SeSACPurchaseError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .success:
            return "성공적으로 구매했습니다."
        case .receiptError:
            return "영수증 검증실패"
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
