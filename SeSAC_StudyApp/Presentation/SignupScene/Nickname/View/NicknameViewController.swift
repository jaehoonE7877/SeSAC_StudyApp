//
//  NicknameViewController.swift
//  SeSAC_StudyApp
//
//  Created by Seo Jae Hoon on 2022/11/10.
//

import UIKit

import RxSwift
import RxCocoa

final class NicknameViewController: BaseViewController {
    
    private let mainView = NicknameView()
    
    private let disposeBag = DisposeBag()
    private let viewModel = NicknameViewModel()
    
    override func loadView() {
        self.view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func setBinding() {
        
        let input = NicknameViewModel.Input(nicknameText: mainView.nicknameTextField.rx.text.orEmpty,
                                            nextButtonTapped: mainView.mainButton.rx.tap,
                                            textFieldBeginEdit: mainView.nicknameTextField.rx.controlEvent(.editingDidBegin),
                                            textFieldEndEdit: mainView.nicknameTextField.rx.controlEvent(.editingDidEnd))
        let output = viewModel.transform(input: input)
        
        output.nicknameValid
            .drive { [weak self] valid in
                guard let self = self else { return }
                self.mainView.mainButton.status = valid ? .fill : .disable
            }
            .disposed(by: disposeBag)
        
        output.textFieldBeginEdit
            .withUnretained(self)
            .bind { weakSelf, _ in
                weakSelf.mainView.lineView.backgroundColor = .textColor
            }
            .disposed(by: disposeBag)
        
        output.textFieldEndEdit
            .withUnretained(self)
            .bind { weakSelf, _ in
                weakSelf.mainView.lineView.backgroundColor = .gray3
            }
            .disposed(by: disposeBag)
        
        output.nextButtonTapped
            .withUnretained(self)
            .bind { weakSelf, _ in
                // UserDefault에 저장
                weakSelf.mainView.makeToast("\(weakSelf.mainView.nicknameTextField.text)저장!")
            }
            .disposed(by: disposeBag)
    }
}
