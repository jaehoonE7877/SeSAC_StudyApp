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
    
    var matchedUserData: MatchDataDTO?

    var sections = [ChatSectionModel]()
    
    struct Input {
        let viewWillAppearEvent: ControlEvent<Bool>
    }
    
    struct Output {
        var fetchFail = PublishRelay<String>()
        var chat = PublishSubject<[ChatSectionModel]>()
    }
    
    func transform(input: Input) -> Output {
        
        let output = Output()
        input.viewWillAppearEvent
            .withUnretained(self)
            .subscribe { weakSelf, _ in
                    weakSelf.fetchChatData(output: output)
            }
            .disposed(by: disposeBag)
        
        return output
    }
}

extension ChatViewModel {
    
    func fetchChatData(output: Output) {
        guard let uid = matchedUserData?.matchedUid else { return }
        sesacAPIService.request(type: SeSACChat.self, router: .fetchChat(from: uid, lastchatDate: "2000-01-01T00:00:00.000Z")) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let result):
                result.payload.forEach { payload in
                    print(payload)

                    let createdAtDate =  payload.createdAt.stringToDate()
//                    print(createdAtDate.MMddaHHmm)
                    let chatItem = SeSACChat(payload: [Payload(id: payload.id, to: payload.to, from: payload.from, chat: payload.chat, createdAt: payload.createdAt)])
                    print(chatItem)
                    self.sections[0].items.append(chatItem)
                    output.chat.onNext(self.sections)
                }
                
            case .failure(let error):
                if error == .firebaseTokenError {
                    self.refreshToken {
                        self.fetchChatData(output: output)
                    }
                } else {
                    output.fetchFail.accept(error.localizedDescription)
                }
            }
        }
    }
    
    func cancelMatch(completion: @escaping (Int) -> Void) {
        guard let otheruid = matchedUserData?.matchedUid else { return }
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
    
    func getMyStatus(completion: @escaping (Result<MatchDataDTO, SeSACSearchError>) -> Void) {
        sesacAPIService.requestQueue(type: MatchDataDTO.self, router: .match) { result in
            switch result{
            case .success(let data):
                completion(.success(data))
            case .failure(let error):
                switch error {
                case .firebaseTokenError:
                    self.refreshToken()
                    completion(.failure(error))
                default:
                    completion(.failure(error))
                }
            }
        }
    }
}

//                    if payload.createdAt.stringToDate()?.day == Date().day {
//                        guard let createdAt = payload.createdAt.stringToDate()?.aHHmm else { return }
//                        let chatItem = SeSACChat(payload: [Payload(id: payload.id, to: payload.to, from: payload.from, chat: payload.chat, createdAt: createdAt)])
//                        self.sections[0].items.append(chatItem)
//                        print(chatItem)
//                    } else {
//                        guard let createdAt =  payload.createdAt.stringToDate()?.MMddaHHmm else { return }
//                        let chatItem = SeSACChat(payload: [Payload(id: payload.id, to: payload.to, from: payload.from, chat: payload.chat, createdAt: createdAt)])
//                        self.sections[0].items.append(chatItem)
//                    }
