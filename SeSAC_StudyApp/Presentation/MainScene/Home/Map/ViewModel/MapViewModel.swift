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
    
    var location: CLLocationCoordinate2D = .init(latitude: 37.517819364682694, longitude: 126.88647317074734)
    
    struct Input {
        let viewDidLoadEvent: Observable<Void>
        //let userCurrentLocation: Observable<CLLocationCoordinate2D>
        let currentButtonTap: ControlEvent<Void>
        let searchButtonTap: ControlEvent<Void>
    }
    
    struct Output {
        var searchLocation = PublishSubject<SeSACUserDataDTO>()
        var isFailed = BehaviorRelay(value: false)
        let currentButtonTap: ControlEvent<Void>
        let searchButtonTap: ControlEvent<Void>
    }
    
    func transform(input: Input) -> Output {
        let output = Output(currentButtonTap: input.currentButtonTap, searchButtonTap: input.searchButtonTap)
        //화면 처음 실행
        input.viewDidLoadEvent
            .withUnretained(self)
            .subscribe(onNext: { weakSelf, _ in
                weakSelf.requestSesacUser(userCurrentLocation: weakSelf.location, output: output)
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
            self.requestSesacUser(userCurrentLocation: self.location, output: output)
        }
    }
}
