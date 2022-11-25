//
//  MapViewModel.swift
//  SeSAC_StudyApp
//
//  Created by Seo Jae Hoon on 2022/11/22.
//

import Foundation
import CoreLocation
import MapKit
import FirebaseAuth
import RxSwift
import RxCocoa

final class MapViewModel: ViewModelType {
    
    private let sesacAPIService = DefaultSeSACAPIService.shared
    private let disposeBag = DisposeBag()
    
    var location: CLLocationCoordinate2D = .init()
        
    //var userLocation = PublishRelay<CLLocationCoordinate2D>()
    var isTokenRefreshFailed = BehaviorRelay(value: false)
    
    struct Input {
        let viewWillAppearEvent: ControlEvent<Bool>
        let currentButtonTap: ControlEvent<Void>
        let searchButtonTap: ControlEvent<Void>
    }
    
    struct Output {
        var searchLocation = PublishSubject<SeSACUserDataDTO>()
        var isFailed = BehaviorRelay(value: false)
        let currentButtonTap: ControlEvent<Void>
        let searchButtonTap: ControlEvent<Void>
        var normalStatus = BehaviorRelay(value: false)
        var resultMatch = PublishSubject<MatchDataDTO>()
        var matchFailed = PublishRelay<String>()
    }
    
    func transform(input: Input) -> Output {

        let output = Output(currentButtonTap: input.currentButtonTap, searchButtonTap: input.searchButtonTap)
        //화면 처음 실행
        input.viewWillAppearEvent
            .withUnretained(self)
            .subscribe(onNext: { weakSelf, appear in
                if appear{
                    weakSelf.requestMatch(output: output)
                    weakSelf.requestSesacUser(userCurrentLocation: weakSelf.location, output: output)
                }
                
            })
            .disposed(by: disposeBag)

        return output
        
    }
}

extension MapViewModel {
    //이부분 다시
    func requestMatch(output: Output) {
        sesacAPIService.requestQueue(type: MatchDataDTO.self, router: .match) { result in
            switch result{
            case .success(let result):
                output.resultMatch.onNext(result)
            case .failure(let error):
                if error.rawValue == 201 {
                    output.normalStatus.accept(true)
                } else {
                    output.matchFailed.accept(error.localizedDescription)
                }
            }
        }
    }
    
    func requestSesacUser(userCurrentLocation: CLLocationCoordinate2D, output: Output) {
        sesacAPIService.requestQueue(type: SeSACUserDataDTO.self, router: .search(location: userCurrentLocation)) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let result):
                output.searchLocation.onNext(result)
            case .failure(let error):
                switch error {
                case .firebaseTokenError:
                    self.refreshRequest(output: output)
                default:
                    output.isFailed.accept(true)
                }
            }
        }
    }
    
    func requestSesacUser(userCurrentLocation: CLLocationCoordinate2D, completion: @escaping ((Result<SeSACUserDataDTO, SeSACSearchError>) -> Void)) {
        sesacAPIService.requestQueue(type: SeSACUserDataDTO.self, router: .search(location: userCurrentLocation)) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let result):
                completion(.success(result))
            case .failure(let error):
                if error == .firebaseTokenError {
                    self.refreshRequest()
                } else {
                    completion(.failure(error))
                }
            }
        }
    }
    
    private func refreshRequest(output: Output) {
        let currentUser = Auth.auth().currentUser
        currentUser?.getIDTokenForcingRefresh(true) { [weak self] idToken, error in
            guard let self = self else { return }
            if let _ = error {
                output.isFailed.accept(true)
            }
            guard let token = idToken else { return }
            UserManager.token = token
            self.requestSesacUser(userCurrentLocation: self.location, output: output)
        }
    }
    
    private func refreshRequest() {
        let currentUser = Auth.auth().currentUser
        currentUser?.getIDTokenForcingRefresh(true) { [weak self] idToken, error in
            guard let self = self else { return }
            if let _ = error {
                self.isTokenRefreshFailed.accept(true)
            }
            guard let token = idToken else { return }
            UserManager.token = token
        }
    }
}
