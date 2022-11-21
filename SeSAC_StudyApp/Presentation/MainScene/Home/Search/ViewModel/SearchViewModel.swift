//
//  SearchViewModel.swift
//  SeSAC_StudyApp
//
//  Created by Seo Jae Hoon on 2022/11/21.
//

import Foundation
import RxSwift
import RxCocoa

struct studyTag: Hashable {
    let id = UUID().uuidString
    var tag: String
}

final class SearchViewModel: ViewModelType {
    
    private let disposeBag = DisposeBag()
    
    var baseList = ["아무거나", "SeSAC", "코딩"]
    var friendList = ["Swift", "SwiftUI", "CoreData", "Python", "Java"]
    var searchList = ["코딩", "부동산투자", "주식", "너?", "불어", "HIG", "알고리즘"]
    
    struct Input {
        //viewdidload , searchtap, button
        let viewDidLoadEvent: Observable<Void>
        let searchText: ControlEvent<Void>
    }
    
    struct Output {
        let searchText: ControlEvent<Void>
    }
    
    func transform(input: Input) -> Output {
        let output = Output(searchText: input.searchText)
        input.viewDidLoadEvent
            .withUnretained(self)
            .subscribe { weakSelf, _ in
                weakSelf.request()
            }
            .disposed(by: disposeBag)
        
        return output
    }
    
}

extension SearchViewModel {
    
    private func request() {
        
    }
    
}

