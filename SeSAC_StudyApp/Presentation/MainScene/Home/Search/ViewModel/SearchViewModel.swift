//
//  SearchViewModel.swift
//  SeSAC_StudyApp
//
//  Created by Seo Jae Hoon on 2022/11/21.
//

import Foundation
import CoreLocation

import FirebaseAuth
import RxSwift
import RxCocoa

struct StudyTag: Hashable {
    let id = UUID().uuidString
    var tag: String
}

final class SearchViewModel: ViewModelType {
    
    private let disposeBag = DisposeBag()
    
    private let sesacAPIService = DefaultSeSACAPIService.shared
    
    var location: CLLocationCoordinate2D?
    
    private let campusLocation: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: 37.517819364682694, longitude: 126.88647317074734)
    
    var baseList = [StudyTag]()
    var friendList = [StudyTag]()
    var searchList = [StudyTag]()
    
    private var total = [String]()
    
    struct Input {
        let viewDidLoadEvent: Observable<Void>
        let searchTap: ControlEvent<Void>
        let findTap: ControlEvent<Void>
    }
    
    struct Output {
        let searchTap: ControlEvent<Void>
        let findTap: ControlEvent<Void>
        let isFailed = BehaviorRelay(value: false)
        let searchInfo = PublishSubject<SeSACUserDataDTO>()
        let searchSuccess = BehaviorRelay(value: false)
        let searchFailed = BehaviorRelay(value: "")
    }
    
    func transform(input: Input) -> Output {
        let output = Output(searchTap: input.searchTap, findTap: input.findTap)
        input.viewDidLoadEvent
            .withUnretained(self)
            .subscribe { weakSelf, _ in
                weakSelf.request(location: weakSelf.location ?? weakSelf.campusLocation, output: output)
            }
            .disposed(by: disposeBag)
        
        input.findTap
            .withUnretained(self)
            .subscribe { weakSelf, _ in
                let studylist = self.fetchStudyList(list: self.searchList)
                weakSelf.requestFriend(location: weakSelf.location ?? weakSelf.campusLocation, studylist: studylist, output: output)
            }
            .disposed(by: disposeBag)
        
        return output
    }
    
}

extension SearchViewModel {
    
    private func requestFriend(location: CLLocationCoordinate2D, studylist: [String], output: Output) {
        sesacAPIService.requestSeSACAPI(router: .queuePost(location: location, studylist: studylist)) { [weak self] statusCode in
            guard let self = self else { return }
            switch SeSACSearchError(rawValue: statusCode){
            case .success:
                output.searchSuccess.accept(true)
            case .firebaseTokenError:
                self.refreshSearch(output: output)
            default :
                output.searchFailed.accept(SeSACSearchError(rawValue: statusCode)?.localizedDescription ?? "")
            }
        }
    }
    
    private func request(location: CLLocationCoordinate2D, output: Output) {
        sesacAPIService.requestQueue(type: SeSACUserDataDTO.self, router: .search(location: location)) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let success):
                success.fromRecommend.forEach { self.baseList.append(StudyTag(tag: $0))}
                success.fromQueueDB.forEach { self.total.append(contentsOf: $0.studylist)}
                success.fromQueueDBRequested.forEach { self.total.append(contentsOf: $0.studylist)}
                let erasedTotal = self.eraseSameStudy(total: self.total)
                erasedTotal.forEach { self.friendList.append(StudyTag(tag: $0))}
                
                output.searchInfo.onNext(success)

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
    
    private func refreshSearch(output: Output) {
        let currentUser = Auth.auth().currentUser
        currentUser?.getIDTokenForcingRefresh(true) { [weak self] idToken, error in
            guard let self = self else { return }
            if let _ = error {
                output.isFailed.accept(true)
            }
            guard let token = idToken else { return }
            UserManager.token = token
            let studylist = self.fetchStudyList(list: self.searchList)
            self.requestFriend(location: self.location ?? CLLocationCoordinate2D(latitude: 37.517819364682694, longitude: 126.88647317074734), studylist: studylist, output: output)
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
            self.request(location: self.location ?? CLLocationCoordinate2D(latitude: 37.517819364682694, longitude: 126.88647317074734), output: output)
        }
    }
    
    private func eraseSameStudy(total: [String]) -> [String] {
        
        return Array(Set(total))
    }
    
    private func fetchStudyList(list: [StudyTag]) -> [String] {
        if list.count == 0 {
            return ["anything"]
        } else {
            return list.map { $0.tag }
        }
    }
}

