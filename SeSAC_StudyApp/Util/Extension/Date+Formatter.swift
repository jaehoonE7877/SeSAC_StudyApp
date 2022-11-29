//
//  Date+Formatter.swift
//  SeSAC_StudyApp
//
//  Created by Seo Jae Hoon on 2022/11/10.
//

import Foundation

extension Date {
    
    static let formatter = DateFormatter()
    
    var year: Int {
        return Calendar.current.component(.year, from: self)
    }
    
    var month: Int {
        return Calendar.current.component(.month, from: self)
    }
    
    var day: Int {
        return Calendar.current.component(.day, from: self)
    }
    
    var americanAge: Int? {
        return Calendar.current.dateComponents([.year], from: self, to: Date()).year
    }
    
    func dateTimeString() -> String {
        Date.formatter.dateFormat = "yyyy.MM.dd"
        Date.formatter.locale = Locale(identifier: "ko_KR")
        return Date.formatter.string(from: self)
    }
    
    func toDateString(format: String) -> String {
        Date.formatter.dateFormat = format
        Date.formatter.locale = Locale(identifier: "ko_KR")
        return Date.formatter.string(from: self)
    }
    
    var yyyyMMddTHHmmssSSZ: String {
        Date.formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        return Date.formatter.string(from: self)
    }
    
    var aHHmm: String {
        Date.formatter.dateFormat = "a HH:mm"
        return Date.formatter.string(from: self)
    }
    
    var MMddaHHmm: String {
        Date.formatter.dateFormat = "MM/dd a HH:mm"
        return Date.formatter.string(from: self)
    }
}

extension String {
    
    func stringToDate() -> Date? {
        Date.formatter.dateFormat = "yyyy.MM.dd"
        Date.formatter.locale = Locale(identifier: "ko_KR")
        return Date.formatter.date(from: self)
    }
    
    func fetchBirthWithFormat(format: String) -> String {
        Date.formatter.dateFormat = format
        Date.formatter.locale = Locale(identifier: "ko_KR")
        guard let date = Date.formatter.date(from: self) else { return ""}
        return Date.formatter.string(from: date)
    }
}


