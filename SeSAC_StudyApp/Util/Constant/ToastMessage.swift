//
//  SignupMessage.swift
//  SeSAC_StudyApp
//
//  Created by Seo Jae Hoon on 2022/11/10.
//

import Foundation

enum SignupMessage {
    static let nicknameLength = "닉네임은 1자 이상 10자 이내로 부탁드려요."
    static let forbiddenNickname = "해당 닉네임은 사용할 수 없습니다."
    static let ageTooYoung = "새싹스터디는 만 17세 이상만 사용할 수 있습니다."
    static let emailValid = "이메일 형식이 올바르지 않습니다."
}

enum LoginMessage {
    static let phoneValidOk = "전화 번호 인증 시작"
    static let phoneValidError = "잘못된 전화번호 형식입니다."
    static let resendMessage = "인증번호를 재전송했습니다"
    static let sentMessage = "인증번호를 보냈습니다."
}
