//
//  FirebaseError.swift
//  SeSAC_StudyApp
//
//  Created by Seo Jae Hoon on 2022/11/09.
//

import Foundation

enum FirebaseError: Int, Error {
    case tooManyRequests = 17010
    case etcError
}

extension FirebaseError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .tooManyRequests:
            return "과도한 인증 시도가 있었습니다. 나중에 다시 시도해 주세요."
        case .etcError:
            return "에러가 발생했습니다. 다시 시도해주세요"
        }
    }
}
