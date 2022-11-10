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
    
    func ageValidation(age: Date) -> Bool {
        let now = Date()
        let americanAge = age.americanAge
        
        guard let americanAge = americanAge else { return false }
        
        let month = age.month * 100
        let day = age.day * 100
        
        let currentMonth = now.month * 100
        let currentDay = now.day
        
        if americanAge - 17 >= 0 || (americanAge - 17 == 0 && (month + day) <= (currentMonth + currentDay)) {
            return true
        } else {
            return false
        }
    }
}
