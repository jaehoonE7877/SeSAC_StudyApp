//
//  BirthViewModel.swift
//  SeSAC_StudyApp
//
//  Created by Seo Jae Hoon on 2022/11/10.
//

import Foundation

import RxCocoa
import RxSwift

final class BirthViewModel: ViewModelType {
    
    struct Input {
        let datePickerTap: ControlEvent<Void>
        let nextButtonTapped: ControlEvent<Void>
    }
    
    struct Output {
        let datePickerTap: Driver<Void>
        let nextButtonTapped: ControlEvent<Void>
    }
    
    func transform(input: Input) -> Output {
            
        let datePickerTap = input.datePickerTap
            .asDriver()
        
        return Output(datePickerTap: datePickerTap, nextButtonTapped: input.nextButtonTapped)
    }
    
    private func toDate(_ dateString: String) -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ko_KR")
        dateFormatter.dateFormat = "yyyy MM dd"
        return dateFormatter.date(from: dateString)
    }
    
    func ageValidation(age: Date) -> Bool {
        let calendar = Calendar.current
        let now = Date()
        let currentYear = calendar.dateComponents([.year], from: age, to: now).year
        
        guard let currentYear = currentYear else { return false }
        
        let month = Int(dateToString(date: age, format: "MM"))! * 100
        let day = Int(dateToString(date: age, format: "dd"))!
        
        let currentMonth = Int(dateToString(date: now, format: "MM"))! * 100
        let currentDay = Int(dateToString(date: now, format: "dd"))!
        
        if currentYear - 17 >= 0 || (currentYear - 17 == 0 && (month + day) <= (currentMonth + currentDay)) {
            return true
        } else {
            return false
        }
    }
    
    func dateToString(date: Date, format: String) -> String {
        
        let formatter = DateFormatter()
        formatter.dateFormat = format
        formatter.locale = Locale(identifier: "ko_KR")
        
        return formatter.string(from: date)
    }
}
