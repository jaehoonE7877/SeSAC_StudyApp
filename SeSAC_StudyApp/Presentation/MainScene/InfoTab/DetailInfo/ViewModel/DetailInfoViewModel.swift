//
//  DetailInfoViewModel.swift
//  SeSAC_StudyApp
//
//  Created by Seo Jae Hoon on 2022/11/15.
//

import Foundation

import RxCocoa
import RxSwift

final class DetailViewModel {
    
    private let sesacAPIService = DefaultSeSACAPIService.shared
    
    func infoNetwork() {
        sesacAPIService.request(type: UserData.self, router: .login) { result in
            switch result {
            case .success(let result):
                result.
            }
        }
        
        
    }
    
}
