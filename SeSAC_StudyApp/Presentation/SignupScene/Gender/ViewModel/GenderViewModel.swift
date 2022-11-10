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
    
    private let sesacAPIService = DefaultSeSACAPIService.shared
    
    struct Input{
        let nextButtonTap: ControlEvent<Void>
        let manButtonTap: ControlEvent<Void>
        let womanButtonTap: ControlEvent<Void>
    }
    
    struct Output{
        let nextButtonTap: ControlEvent<Void>
        let manButtonTap: ControlEvent<Void>
        let womanButtonTap: ControlEvent<Void>
    }
    
    func transform(input: Input) -> Output {
        
        return Output(nextButtonTap: input.nextButtonTap, manButtonTap: input.manButtonTap, womanButtonTap: input.womanButtonTap)
    }
    
}

extension GenderViewModel {
    
    func signup(completion: @escaping (Result<UserData,SeSACError>) -> Void) {
        sesacAPIService.request(type: UserData.self, router: .signup) { result in
            switch result {
            case .success(let success):
                completion(.success(success))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
}
