//
//  SearchViewModel.swift
//  SeSAC_StudyApp
//
//  Created by Seo Jae Hoon on 2022/11/21.
//

import Foundation
import RxSwift
import RxCocoa

struct StudyTag: Hashable {
    let id = UUID().uuidString
    var tag: String
}

final class SearchViewModel: ViewModelType {
    
    private let disposeBag = DisposeBag()
    
    var baseList = [StudyTag]()
    var friendList = [StudyTag]()
    var searchList = [StudyTag]()
    
    struct Input {
        //viewdidload , searchtap, button
        let viewDidLoadEvent: Observable<Void>
        let searchTap: ControlEvent<Void>
        
    }
    
    struct Output {
        let searchTap: ControlEvent<Void>
    }
    
    func transform(input: Input) -> Output {
        
        input.viewDidLoadEvent
            .withUnretained(self)
            .subscribe { weakSelf, _ in
                weakSelf.request()
            }
            .disposed(by: disposeBag)

        let output = Output(searchTap: input.searchTap)
        return output
    }
    
}

extension SearchViewModel {
    
    private func request() {
        
    }
    
}

