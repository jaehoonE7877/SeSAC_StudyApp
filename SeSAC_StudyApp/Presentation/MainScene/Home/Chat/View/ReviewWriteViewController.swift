//
//  ReviewWriteViewController.swift
//  SeSAC_StudyApp
//
//  Created by Seo Jae Hoon on 2022/12/04.
//

import UIKit

import RxSwift
import RxCocoa

final class ReviewWriteViewController: BaseViewController {
    
    private let mainView = ReviewWriteView()

    let viewModel = ChatViewModel()
    
    private var reviewTitleButtonValue = Array(repeating: false, count: 6)
    
    override func loadView() {
        self.view = mainView
    }
    
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        bindingUI()
        guard let nick = viewModel.matchedUserData?.matchedNick else { return }
        mainView.subTitleLabel.text = "\(nick)님과의 스터디는 어떠셨나요?"
        
    }
    
    private func bindingUI() {
        
        mainView.cancelButton.rx.tap
            .withUnretained(self)
            .bind { weakSelf, _ in
                weakSelf.dismiss(animated: true)
            }
            .disposed(by: disposeBag)
        
        mainView.reviewView.mannerButton.rx.tap
            .withUnretained(self)
            .bind { weakSelf, _ in
                weakSelf.reviewTitleButtonValue[weakSelf.mainView.reviewView.mannerButton.tag].toggle()
                weakSelf.mainView.reviewView.mannerButton.status = weakSelf.reviewTitleButtonValue[weakSelf.mainView.reviewView.mannerButton.tag] ? .active : .inactive
            }
            .disposed(by: disposeBag)
        
        mainView.reviewView.exactTimeButton.rx.tap
            .withUnretained(self)
            .bind { weakSelf, _ in
                weakSelf.reviewTitleButtonValue[weakSelf.mainView.reviewView.exactTimeButton.tag].toggle()
                weakSelf.mainView.reviewView.exactTimeButton.status = weakSelf.reviewTitleButtonValue[weakSelf.mainView.reviewView.exactTimeButton.tag] ? .active : .inactive
            }
            .disposed(by: disposeBag)
        
        mainView.reviewView.fastResponseButton.rx.tap
            .withUnretained(self)
            .bind { weakSelf, _ in
                weakSelf.reviewTitleButtonValue[weakSelf.mainView.reviewView.fastResponseButton.tag].toggle()
                weakSelf.mainView.reviewView.fastResponseButton.status = weakSelf.reviewTitleButtonValue[weakSelf.mainView.reviewView.fastResponseButton.tag] ? .active : .inactive
            }
            .disposed(by: disposeBag)
        
        mainView.reviewView.kindButton.rx.tap
            .withUnretained(self)
            .bind { weakSelf, _ in
                weakSelf.reviewTitleButtonValue[weakSelf.mainView.reviewView.kindButton.tag].toggle()
                weakSelf.mainView.reviewView.kindButton.status = weakSelf.reviewTitleButtonValue[weakSelf.mainView.reviewView.kindButton.tag] ? .active : .inactive
            }
            .disposed(by: disposeBag)
        
        mainView.reviewView.skillfullButton.rx.tap
            .withUnretained(self)
            .bind { weakSelf, _ in
                weakSelf.reviewTitleButtonValue[weakSelf.mainView.reviewView.skillfullButton.tag].toggle()
                weakSelf.mainView.reviewView.skillfullButton.status = weakSelf.reviewTitleButtonValue[weakSelf.mainView.reviewView.skillfullButton.tag] ? .active : .inactive
            }
            .disposed(by: disposeBag)
        
        mainView.reviewView.beneficialButton.rx.tap
            .withUnretained(self)
            .bind { weakSelf, _ in
                weakSelf.reviewTitleButtonValue[weakSelf.mainView.reviewView.beneficialButton.tag].toggle()
                weakSelf.mainView.reviewView.beneficialButton.status = weakSelf.reviewTitleButtonValue[weakSelf.mainView.reviewView.beneficialButton.tag] ? .active : .inactive
            }
            .disposed(by: disposeBag)
        
        mainView.writeButton.rx.tap
            .withUnretained(self)
            .bind { weakSelf, _ in
                //weakSelf
            }
            .disposed(by: disposeBag)
    }
    
}
