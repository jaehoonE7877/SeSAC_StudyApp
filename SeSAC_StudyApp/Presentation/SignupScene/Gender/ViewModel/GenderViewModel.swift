//
//  GenderViewModel.swift
//  SeSAC_StudyApp
//
//  Created by Seo Jae Hoon on 2022/11/10.
//

import Foundation

import RxCocoa
import RxSwift

final class GenderViewModel: ViewModelType {
    
    struct Input{
        let nextButtonTap: ControlEvent<Void>
    }
    
    struct Output{
        let nextButtonTap: ControlEvent<Void>
    }
    
    func transform(input: Input) -> Output {
        return Output(nextButtonTap: input.nextButtonTap)
    }
    
}
