//
//  ChatViewModel.swift
//  SeSAC_StudyApp
//
//  Created by Seo Jae Hoon on 2022/11/28.
//

import Foundation

import RxSwift
import RxCocoa

final class ChatViewModel: ViewModelType {
    
    private let sesacAPIService = DefaultSeSACAPIService.shared
    private let disposeBag = DisposeBag()
    
    var chatData: MatchDataDTO?
    
    struct Input {
        
    }
    
    struct Output {
        
    }
    
    func transform(input: Input) -> Output {
        
        return Output()
    }
}

extension ChatViewModel {
    
    func cancelMatch(completion: @escaping (Int) -> Void) {
        guard let otheruid = chatData?.matchedUid else { return }
        sesacAPIService.requestSeSACAPI(router: .dodge(otheruid: otheruid)) { [weak self] statusCode in
            guard let self = self else { return }
            switch SeSACDodgeError(rawValue: statusCode) {
            case .firebaseTokenError:
                self.refreshToken()
                completion(statusCode)
            default:
                completion(statusCode)
            }
        }
    }
    
}
