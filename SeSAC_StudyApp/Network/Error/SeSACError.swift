//
//  SeSACError.swift
//  SeSAC_StudyApp
//
//  Created by Seo Jae Hoon on 2022/11/09.
//

import Foundation

enum SeSACError: Int, Error {
    case firebaseTokenError = 401
    case unknownUser = 406
    case serverError = 500
    case clientError = 501
}
