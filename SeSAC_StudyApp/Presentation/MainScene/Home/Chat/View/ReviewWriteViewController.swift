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
    
    private var reviewTitleButtonValue = Array(repeating: false, count: 8)
    
    override func loadView() {
        self.view = mainView
    }
    
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        bindingUI()
        guard let nick = viewModel.matchedUserData?.matchedNick else { return }
        mainView.subTitleLabel.text = "\(nick)님과의 스터디는 어떠셨나요?"
        
        if mainView.writeButton.status == .fill {
            mainView.writeButton.isEnabled = true
        } else if mainView.writeButton.status == .disable {
            mainView.writeButton.isEnabled = false
        }
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
                guard let comment = weakSelf.mainView.textView.text else { return }
                if comment.count == 0 {
                    weakSelf.view.makeToast("최소 한 글자 입력해주세요.", duration: 1, position: .center)
                } else {
                    weakSelf.viewModel.writeReview(reputation: weakSelf.reviewTitleButtonValue, comment: comment) { statusCode in
                        switch SeSACError(rawValue: statusCode){
                        case .success:
                            weakSelf.dismiss(animated: false) {
                                guard let vc = (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.window?.rootViewController?.topViewController else { return }
                                vc.navigationController?.popToRootViewController(animated: false)
                            }
                        default:
                            weakSelf.dismiss(animated: false) {
                                guard let vc = (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.window?.rootViewController?.topViewController else { return }
                                vc.view.makeToast(SeSACError(rawValue: statusCode)?.localizedDescription, duration: 1, position: .center)
                            }
                        }
                    }
                }
            }
            .disposed(by: disposeBag)
    }
    
}
