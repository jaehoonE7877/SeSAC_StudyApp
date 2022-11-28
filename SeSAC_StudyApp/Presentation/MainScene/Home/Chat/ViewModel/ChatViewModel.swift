//
//  ChatViewModel.swift
//  SeSAC_StudyApp
//
//  Created by Seo Jae Hoon on 2022/11/28.
//

import Foundation

import RxSwift
import RxCocoa

final class ChatViewModel {
    
    private let sesacAPIService = DefaultSeSACAPIService.shared
    private let disposeBag = DisposeBag()
    
    var chatData: MatchDataDTO?
    
}

extension ChatViewModel {
    
    func cancelMatch() {
        
    }
    
}
