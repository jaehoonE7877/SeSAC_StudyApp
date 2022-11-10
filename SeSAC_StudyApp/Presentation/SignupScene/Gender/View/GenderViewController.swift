//
//  GenderViewController.swift
//  SeSAC_StudyApp
//
//  Created by Seo Jae Hoon on 2022/11/10.
//

import UIKit

import RxCocoa
import RxSwift

final class GenderViewController: BaseViewController {
    
    private let mainView = GenderView()
    
    private let disposeBag = DisposeBag()
    private let viewModel = GenderViewModel()
    
    override func loadView() {
        self.view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func setBinding() {
        
        let input = GenderViewModel.Input(nextButtonTap: mainView.mainButton.rx.tap)
        let output = viewModel.transform(input: input)
        
//        output.nextButtonTap
//            .withUnretained(self)
//            .bind { weakSelf, _ in
//                if weakSelf.selectedIndex?.item == 0 {// 남자선택
//                    UserManager.gender = 1
//                    
//                } else {
//                    UserManager.gender = 0
//                    
//                }
//            }
//            .disposed(by: disposeBag)
        

    }
}

