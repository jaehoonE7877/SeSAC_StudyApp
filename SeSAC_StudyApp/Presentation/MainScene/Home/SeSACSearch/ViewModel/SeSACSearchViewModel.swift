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
    
    struct Input {
        let viewWillAppearEvent: ControlEvent<Bool> // viewdidload는 void viewwillappear는 bool
    }
    
    struct Output {
        var friendData = PublishSubject<[SeSACCardModel]>()
        var fetchFailed = PublishRelay<String>()
    }
    
    func transform(input: Input) -> Output {
        let output = Output()
        input.viewWillAppearEvent
            .withUnretained(self)
            .subscribe { weakSelf, _ in
                guard let location = weakSelf.location else { return }
                weakSelf.fetchFriend(location: location, output: output)
            }
            .disposed(by: disposeBag)
        
        return output
    }
    
}

extension SeSACSearchViewModel {
    
    private func fetchFriend(location: CLLocationCoordinate2D, output: Output) {
        sesacAPIService.requestQueue(type: SeSACUserDataDTO.self, router: .search(location: location)) { [weak self] result in
            guard let self = self else { return }
            switch result{
            case .success(let result):
                let data = result.fromQueueDB.map { $0.toDomain() }
                output.friendData.onNext(data)
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
            self.fetchFriend(location: self.location ?? CLLocationCoordinate2D(latitude: 37.517819364682694, longitude: 126.88647317074734), output: output)
        }
    }
    
    func requireMatch(completion: @escaping (Int) -> Void){
        guard let uid = self.uid else { return }
        sesacAPIService.requestSeSACAPI(router: .require(otheruid: uid)) { [weak self] statusCode in
            guard let self = self else { return }
            switch statusCode {
            case 201:
                print(statusCode)
            case 401:
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
            //guard let self = self else { return }
            if let error = error {
                print(error)
            }
            guard let token = idToken else { return }
            UserManager.token = token
        }
    }
}
