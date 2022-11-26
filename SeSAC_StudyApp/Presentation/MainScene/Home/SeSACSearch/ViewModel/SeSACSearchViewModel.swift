//
//  SeSACSearchViewModel.swift
//  SeSAC_StudyApp
//
//  Created by Seo Jae Hoon on 2022/11/23.
//

import Foundation
import CoreLocation

import FirebaseAuth
import RxSwift
import RxCocoa

final class SeSACSearchViewModel: ViewModelType {
    
    private let sesacAPIService = DefaultSeSACAPIService.shared
    private let disposeBag = DisposeBag()
    
    var location: CLLocationCoordinate2D?
    
    var uid: String?
    
    var change = BehaviorRelay(value: false)
    let refresh = PublishRelay<Bool>()
    struct Input {
        
        // 테이블뷰 새로고침 스크롤
        // 빈화면 버튼들
    }
    
    struct Output {
        var friendData = PublishSubject<[SeSACCardModel]>()
        var requestedData = PublishSubject<[SeSACCardModel]>()
        var fetchFailed = PublishRelay<String>()
        let timer: Observable<Int>
    }
    
    func transform(input: Input) -> Output {
      
        let timer = Observable<Int>
            .timer(.seconds(1), period: .seconds(5), scheduler: MainScheduler.instance)

        return Output(timer: timer)
    }
    
}

extension SeSACSearchViewModel {
    
    func fetchFriend(output: Output) {
        guard let location = location else { return }
        sesacAPIService.requestQueue(type: SeSACUserDataDTO.self, router: .search(location: location)) { [weak self] result in
            guard let self = self else { return }
            switch result{
            case .success(let result):
                let data = result.fromQueueDB.map { $0.toDomain() }
                let requested = result.fromQueueDBRequested.map { $0.toDomain() }
                output.friendData.onNext(data)
                output.requestedData.onNext(requested)
                DispatchQueue.main.asyncAfter(wallDeadline: .now() + 2) {
                    self.refresh.accept(false)
                }
            case .failure(let error):
                switch error {
                case .firebaseTokenError:
                    self.refreshToken(output: output)
                default:
                    output.fetchFailed.accept(error.localizedDescription)
                }
            }
        }
    }
    
    private func refreshToken(output: Output){
        let currentUser = Auth.auth().currentUser
        currentUser?.getIDTokenForcingRefresh(true) { [weak self] idToken, error in
            guard let self = self else { return }
            if let _ = error {
                output.fetchFailed.accept("토큰을 가져오는데 실패했습니다.")
            }
            guard let token = idToken else { return }
            UserManager.token = token
            self.fetchFriend(output: output)
        }
    }
}

extension SeSACSearchViewModel {
    //요청하기 버튼
    func requireMatch(completion: @escaping (Int) -> Void){
        guard let uid = self.uid else { return }
        sesacAPIService.requestSeSACAPI(router: .require(otheruid: uid)) { [weak self] statusCode in
            guard let self = self else { return }
            switch SeSACStudyRequestError(rawValue: statusCode){
            case .alreadyRequested:
                self.acceptMatch { status in
                    if SeSACStudyAcceptError(rawValue: status) == .success {
                        completion(statusCode)
                    } else {
                        print(status)
                    }
                }
            case .firebaseTokenError:
                self.refreshToken()
                completion(statusCode)
            default:
                completion(statusCode)
            }
        }
    }
    // 수락하기 버튼
    func acceptMatch(completion: @escaping (Int) -> Void) {
        guard let uid = self.uid else { return }
        sesacAPIService.requestSeSACAPI(router: .accept(otheruid: uid)) { [weak self] statusCode in
            guard let self = self else { return }
            switch SeSACStudyAcceptError(rawValue: statusCode){
            case .firebaseTokenError:
                self.refreshToken()
                completion(statusCode)
            default:
                completion(statusCode)
            }
        }
    }
    
    private func refreshToken(){
        let currentUser = Auth.auth().currentUser
        currentUser?.getIDTokenForcingRefresh(true) { idToken, error in
            if let error = error {
                print(error)
            }
            guard let token = idToken else { return }
            UserManager.token = token
        }
    }
    
    func callOffSearch(completion: @escaping (Int) -> Void) {
        sesacAPIService.requestSeSACAPI(router: .queueDelete) { [weak self] statusCode in
            guard let self = self else { return }
            switch SeSACCallOffError(rawValue: statusCode) {
            case .firebaseTokenError:
                self.refreshToken()
                completion(statusCode)
            default:
                completion(statusCode)
            }
        }
    }
    
    // 매칭상태 get
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
