//
//  PropertyWapper.swift
//  SeSAC_StudyApp
//
//  Created by Seo Jae Hoon on 2022/11/10.
//

import Foundation

@propertyWrapper
struct UserDefault<T> {
    
    let key: String
    let defaultValue: T
    let storage: UserDefaults
    
    var wrappedValue: T {
        get { self.storage.object(forKey: self.key) as? T ?? self.defaultValue }
        set { self.storage.set(newValue, forKey: self.key) }
    }
    
    init(key: String, defaultValue: T, storage: UserDefaults = .standard) {
        self.key = key
        self.defaultValue = defaultValue
        self.storage = storage
    }
}

class UserManager {
    
    @UserDefault(key: "onboarding", defaultValue: false)
    static var onboarding: Bool
    
    @UserDefault(key: "authVerificationID", defaultValue: "")
    static var authVerificationID: String
    
    @UserDefault(key: "phone", defaultValue: "")
    static var phone: String
    
    @UserDefault(key: "token", defaultValue: "")
    static var token: String
    
    @UserDefault(key: "nickname", defaultValue: "")
    static var nickname: String
    
}
