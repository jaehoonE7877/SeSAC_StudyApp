//
//  MapViewModel.swift
//  SeSAC_StudyApp
//
//  Created by Seo Jae Hoon on 2022/11/22.
//

import Foundation
import CoreLocation

import FirebaseAuth
import RxSwift
import RxCocoa

final class MapViewModel: ViewModelType {
    
    private let sesacAPIService = DefaultSeSACAPIService.shared
    private let disposeBag = DisposeBag()
    
    var userCurrentLocation: CLLocationCoordinate2D = .init(latitude: 37.517819364682694, longitude: 126.88647317074734)
    
    struct Input {
        let viewDidLoadEvent: ControlEvent<Void>
    }
    
    struct Output {
        var searchLocation = PublishSubject<SeSACUserDataDTO>()
        var isFailed = BehaviorRelay(value: false)
    }
    
    func transform(input: Input) -> Output {
        let output = Output()
        input.viewDidLoadEvent
            .withUnretained(self)
            .subscribe(onNext: { weakSelf, _ in
                weakSelf.requestSesacUser(userCurrentLocation: weakSelf.userCurrentLocation, output: output)
            })
            .disposed(by: disposeBag)
        
        return output
    }
    
    
}

extension MapViewModel {
    
    private func requestSesacUser(userCurrentLocation: CLLocationCoordinate2D, output: Output) {
        sesacAPIService.request(type: SeSACUserDataDTO.self, router: .search(location: userCurrentLocation)) { [weak self] result in
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
    
    private func refreshRequest(output: Output) {
        
        let currentUser = Auth.auth().currentUser
        currentUser?.getIDTokenForcingRefresh(true) { [weak self] idToken, error in
            guard let self = self else { return }
            if let _ = error {
                output.isFailed.accept(true)
            }
            guard let token = idToken else { return }
            UserManager.token = token
            self.requestSesacUser(userCurrentLocation: self.userCurrentLocation, output: output)
        }
    }
}
