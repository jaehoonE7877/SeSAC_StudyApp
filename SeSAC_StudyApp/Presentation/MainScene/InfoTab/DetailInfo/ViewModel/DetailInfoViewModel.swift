//
//  DetailInfoViewModel.swift
//  SeSAC_StudyApp
//
//  Created by Seo Jae Hoon on 2022/11/15.
//

import Foundation
import FirebaseAuth
import RxCocoa
import RxSwift

final class DetailViewModel: ViewModelType {
    
    private let sesacAPIService = DefaultSeSACAPIService.shared
    
    private let disposeBag = DisposeBag()

    struct Input {
        let viewDidLoadEvent: Observable<Void>
        let saveButtonTap: ControlEvent<Void>
    }
    
    struct Output {
        var userData = PublishSubject<SeSACInfo>()
        var isFailed = BehaviorRelay(value: false)
        let saveButtonTap: ControlEvent<Void>
    }
    
    func transform(input: Input) -> Output {
        let output = Output(saveButtonTap: input.saveButtonTap)
        input.viewDidLoadEvent
            .withUnretained(self)
            .subscribe(onNext: { weakSelf, _ in
                weakSelf.requestInfo(output: output)
            })
            .disposed(by: disposeBag)
        
        return output
    }
}

extension DetailViewModel {
    
    private func requestInfo(output: Output) {
        sesacAPIService.request(type: UserDataDTO.self, router: .login) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let result):
               output.userData.onNext(result.toDomain())
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
            self.requestInfo(output: output)
        }
    }
    
    func updateInfo(updataData: SeSACInfo, completion: @escaping (Result<UserDataDTO,SeSACError>) -> Void ) {
        
        sesacAPIService.request(type: UserDataDTO.self, router: .mypage(updateData: updataData)) { result in
            switch result {
            case .success(let result):
                completion(.success(result))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func withdraw(completion: @escaping (Result<UserDataDTO,SeSACError>) -> Void) {
        sesacAPIService.request(type: UserDataDTO.self, router: .withdraw) { result in
            switch result {
            case .success(let success):
                completion(.success(success))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
}
