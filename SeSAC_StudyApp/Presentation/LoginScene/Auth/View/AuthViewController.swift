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
    
    @objc func login(){
        guard let text = mainView.authTextField.text else { return }
        textLogin(verificationCode: text)
    }
    
    override func setBinding() {
        
        
        
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
