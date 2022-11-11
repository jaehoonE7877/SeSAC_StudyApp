//
//  AuthViewController.swift
//  SeSAC_StudyApp
//
//  Created by Seo Jae Hoon on 2022/11/08.
//

import UIKit

import FirebaseAuth
import RxSwift
import RxCocoa

final class AuthViewController: BaseViewController {
    
    private let mainView = AuthView()
    private let disposeBag = DisposeBag()
    private let viewModel = AuthViewModel()
    
    var timerDisposable: Disposable?
    
    override func loadView() {
        self.view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.makeToast(LoginMessage.sentMessage, duration: 1, position: .center)
    }
    
    override func setBinding() {
        
        let input = AuthViewModel.Input(verifyText: mainView.authTextField.rx.text.orEmpty,
                                        textFieldBeginEdit: mainView.authTextField.rx.controlEvent([.editingDidBegin]),
                                        textFieldEndEdit: mainView.authTextField.rx.controlEvent(.editingDidEnd),
                                        resendButtonTap: mainView.resendButton.rx.tap,
                                        verifyButtonTap: mainView.mainButton.rx.tap)
        let output = viewModel.transform(input: input)
        
        startTimer(time: output.timer)
        
        output.verifyTextValid
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
        
        output.resendButtonTap
            .withUnretained(self)
            .throttle(.seconds(5), scheduler: MainScheduler.instance)
            .bind { weakSelf, _ in
                weakSelf.mainView.makeToast(LoginMessage.resendMessage, duration: 1, position: .center)
                weakSelf.viewModel.requestAuth(phoneNumber: UserManager.phone) { result in
                    switch result {
                    case .success(_):
                        break
                    case .failure(let error):
                        weakSelf.mainView.makeToast(error.localizedDescription, duration: 1, position: .center)
                    }
                }
                weakSelf.mainView.authTextField.text = nil
                weakSelf.startTimer(time: output.timer)
            }
            .disposed(by: disposeBag)
            
        output.verifyButtonTap
            .withUnretained(self)
            .bind { weakSelf, _ in
                //네트워크 통신, 값이 있으면 mapview 없으면 회원가입으로 가는 로직
                guard let text = weakSelf.mainView.authTextField.text else { return }
                weakSelf.viewModel.requestLogin(verificationCode: text) { result in
                    switch result {
                    case .success(let idToken):
                        idToken.user.getIDTokenForcingRefresh(true) { token, error in
                            if let error = error {
                                let errorCode = (error as NSError)
                                weakSelf.mainView.makeToast("\(error.localizedDescription)", duration: 1, position: .center)
                            }
                            guard let token = token else { return }
                            UserManager.token = token
                            weakSelf.viewModel.login { result in
                                switch result {
                                case .success(_):
                                    weakSelf.transitionViewController(viewController: HomeViewController(), transitionStyle: .presentFullNavigation)
                                case .failure(let error):
                                    if error.rawValue == 406 {
                                        UserManager.authDone = 406
                                        weakSelf.transitionViewController(viewController: NicknameViewController(), transitionStyle: .push)
                                    } else {
                                        weakSelf.mainView.makeToast("\(error.localizedDescription)", duration: 1, position: .center)
                                    }
                                }
                            }
                        }
                    case .failure(let error):
                        weakSelf.mainView.makeToast(error.localizedDescription, duration: 1, position: .center)
                    }
                }
            }
            .disposed(by: disposeBag)

    }
    
    private func startTimer(time: Observable<Int>) {
        timerDisposable?.dispose()
        timerDisposable = time
            .withUnretained(self)
            .subscribe(onNext: { weakSelf, value in
                if value <= 60 {
                    weakSelf.mainView.timeLabel.text = "0:\(String(format: "%02d", 60-value))"
                } else {
                    weakSelf.timerDisposable?.dispose()
                }
            }, onDisposed: {
                UserManager.authVerificationID = ""
            })
    }
}
