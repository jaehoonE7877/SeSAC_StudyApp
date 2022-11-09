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

    }
    
    override func setNavigationController() {
        let backButton = UIBarButtonItem(image: UIImage(named: "arrow"), style: .plain, target: self, action: #selector(backButtonTapped))
        backButton.tintColor = .textColor
        self.navigationItem.leftBarButtonItem = backButton
    }
    
    @objc private func backButtonTapped(){
        self.navigationController?.popViewController(animated: true)
    }
    
    override func setBinding() {
        
        let input = AuthViewModel.Input(verifyText: mainView.authTextField.rx.text.orEmpty,
                                        textFieldBeginEdit: mainView.authTextField.rx.controlEvent(.editingDidBegin),
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
            .bind { vc, _ in
                vc.mainView.lineView.backgroundColor = .textColor
            }
            .disposed(by: disposeBag)
        
        output.textFieldEndEdit
            .withUnretained(self)
            .bind { vc, _ in
                vc.mainView.lineView.backgroundColor = .gray3
            }
            .disposed(by: disposeBag)
        
        output.resendButtonTap
            .withUnretained(self)
            .throttle(.seconds(5), scheduler: MainScheduler.instance)
            .bind { vc, _ in
                vc.mainView.makeToast("인증번호를 재전송했습니다", duration: 1, position: .center)
                vc.viewModel.requestAuth(phoneNumber: UserDefaults.standard.string(forKey: "phone")!) { result in
                    switch result {
                    case .success(_):
                        break
                    case .failure(let error):
                        vc.mainView.makeToast(error.localizedDescription, duration: 1, position: .center)
                    }
                }
                vc.startTimer(time: output.timer)
            }
            .disposed(by: disposeBag)
            
        output.verifyButtonTap
            .withUnretained(self)
            .bind { vc, _ in
                //네트워크 통신, 값이 있으면 mapview 없으면 회원가입으로 가는 로직
                guard let text = vc.mainView.authTextField.text else { return }
                vc.viewModel.requestLogin(verificationCode: text) { result in
                    switch result {
                    case .success(let idToken):
                        idToken.user.getIDTokenForcingRefresh(true) { token, error in
                            if let error = error {
                                let errorCode = (error as NSError)
                                print(errorCode)
                            }
                            guard let token = token else { return }
                            UserDefaults.standard.set(token, forKey: "token")
                            vc.viewModel.login { result in
                                switch result {
                                case .success(_):
                                    print("로그인 성공 -> 홈 화면으로 이동")
                                case .failure(let error):
                                    if error.rawValue == 406 {
                                        print("미가입 유저!")
                                    } else {
                                        vc.mainView.makeToast("\(error.localizedDescription)", duration: 1, position: .center)
                                    }
                                }
                            }
                        }
                    case .failure(let error):
                        vc.mainView.makeToast(error.localizedDescription, duration: 1, position: .center)
                    }
                }
            }
            .disposed(by: disposeBag)

    }
    
    private func startTimer(time: Observable<Int>) {
        timerDisposable?.dispose()
        timerDisposable = time
            .withUnretained(self)
            .subscribe(onNext: { vc, value in
                if value <= 60 {
                    vc.mainView.timeLabel.text = "0:\(String(format: "%02d", 60-value))"
                } else {
                    vc.timerDisposable?.dispose()
                }
            }, onDisposed: {
                UserDefaults.standard.set("", forKey: "authVerificationID")
            })
    }
}
