//
//  ShopViewModel.swift
//  SeSAC_StudyApp
//
//  Created by Seo Jae Hoon on 2022/12/06.
//

import Foundation

import RxSwift
import RxCocoa

final class ShopViewModel: ViewModelType {
    
    private let sesacAPIService = DefaultSeSACAPIService.shared
    private let disposeBag = DisposeBag()
    
    struct Input {
        let viewWillAppearEvent: ControlEvent<Bool>
    }
    
    struct Output {
        var fetchFailed = PublishRelay<String>()
        var myInfoData = PublishSubject<SeSACImage>()
    }
    
    func transform(input: Input) -> Output {
        
        let output = Output()
        
        input.viewWillAppearEvent
            .withUnretained(self)
            .subscribe { weakSelf, _ in
                weakSelf.requestShopMyInfo(output: output)
            }
            .disposed(by: disposeBag)
        
        return output
    }

}

extension ShopViewModel {
    
    private func requestShopMyInfo(output: Output) {
        sesacAPIService.request(type: UserDataDTO.self, router: .shopMyinfo) { result in
            switch result {
            case .success(let data):
                output.myInfoData.onNext(data.toDomain())
            case .failure(let error):
                output.fetchFailed.accept(error.localizedDescription)
            }
        }
    }
    
    func checkShopMyInfo(completion: @escaping (Result<SeSACImage, SeSACError>) -> Void) {
        sesacAPIService.request(type: UserDataDTO.self, router: .shopMyinfo) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let result):
                completion(.success(result.toDomain()))
            case .failure(let error):
                switch error {
                case .firebaseTokenError:
                    self.refreshToken {
                        self.checkShopMyInfo { result in
                            switch result {
                            case .success(let result):
                                completion(.success(result))
                            case .failure(let error):
                                completion(.failure(error))
                            }
                        }
                    }
                default:
                    completion(.failure(error))
                }
            }
        }
    }
    
    func checkReceipt(product: String, receipt: String, completion: @escaping (Int) -> Void) {
        sesacAPIService.requestSeSACAPI(router: .ios(product: product, receipt: receipt)) { [weak self] statusCode in
            guard let self = self else { return }
            switch SeSACPurchaseError(rawValue: statusCode) {
            case .firebaseTokenError:
                self.refreshToken {
                    self.checkReceipt(product: product, receipt: receipt) { statusCode in
                        completion(statusCode)
                    }
                }
            default:
                completion(statusCode)
            }
        }
    }
    
}
