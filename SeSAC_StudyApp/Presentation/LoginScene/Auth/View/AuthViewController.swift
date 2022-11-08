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
    
    override func loadView() {
        self.view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mainView.mainButton.addTarget(self, action: #selector(login), for: .touchUpInside)
    }
    
    override func setNavigationController() {
        let backButton = UIBarButtonItem(image: UIImage(named: "arrow"), style: .plain, target: self, action: #selector(backButtonTapped))
        backButton.tintColor = .black
        self.navigationItem.leftBarButtonItem = backButton
    }
    
    @objc private func backButtonTapped(){
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func login(){
        guard let text = mainView.authTextField.text else { return }
        textLogin(verificationCode: text)
    }
    
    override func setBinding() {
        
        let input = AuthViewModel.Input(verifyText: mainView.authTextField.rx.text.orEmpty,
                                        //timerText: mainView.timeLabel.rx.text.orEmpty,
                                        textFieldBeginEdit: mainView.authTextField.rx.controlEvent(.editingDidBegin),
                                        textFieldEndEdit: mainView.authTextField.rx.controlEvent(.editingDidEnd),
                                        resendButtonTap: mainView.resendButton.rx.tap,
                                        verifyButtonTap: mainView.mainButton.rx.tap)
        let output = viewModel.transform(input: input)
        
        output.verifyTextValid
            .drive { [weak self] valid in
                guard let self = self else { return }
                self.mainView.mainButton.status = valid ? .fill : .disable
            }
            .disposed(by: disposeBag)
        
        output.textFieldBeginEdit
            .withUnretained(self)
            .bind { vc, _ in
                vc.mainView.lineView.backgroundColor = .black
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
            .bind { vc, _ in
                //타이머 재 시작 로직
                vc.mainView.timeLabel.text = "1:00"
            }
            .disposed(by: disposeBag)
            
        output.verifyButtonTap
            .withUnretained(self)
            .bind { vc, _ in
                //네트워크 통신, 값이 있으면 mapview 없으면 회원가입으로 가는 로직
                //vc.transitionViewController(viewController: <#T##T#>, transitionStyle: <#T##TransitionStyle#>)
            }
            .disposed(by: disposeBag)
        
    }
    
    // ViewModel
    func textLogin(verificationCode: String) {
        let verificationID = UserDefaults.standard.string(forKey: "authVerificationID") ?? ""
        print(verificationID)
        print(verificationCode)
        
        let credential = PhoneAuthProvider.provider().credential(
            withVerificationID:verificationID,
            verificationCode:verificationCode
        )
        
        Auth.auth().signIn(with: credential) { authResult, error in
            if let error = error {
                print(error.localizedDescription)
                print("LogIn Failed...")
            }
        }
    }
}
