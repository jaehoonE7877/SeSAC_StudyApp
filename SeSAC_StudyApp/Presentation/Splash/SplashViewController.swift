//
//  SplashViewController.swift
//  SeSAC_StudyApp
//
//  Created by Seo Jae Hoon on 2022/11/11.
//

import UIKit

import FirebaseAuth

final class SplashViewController: UIViewController {
    
    //MARK: Property
    private let sesacAPIService = DefaultSeSACAPIService.shared
    
    private let imageView = UIImageView().then {
        $0.image = UIImage(named: "splash_logo")
        $0.contentMode = .scaleAspectFill
    }
    
    private let labelImageView = UIImageView().then {
        $0.image = UIImage(named: "splash_text")
        $0.contentMode = .scaleAspectFit
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        setConstraint()
        print(UserManager.token)
        animation()
        
    }
    
    func configure() {
        view.backgroundColor = .systemBackground
        [imageView, labelImageView].forEach{ view.addSubview($0)}
    }
    
    func setConstraint() {
        imageView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().multipliedBy(0.82)
            make.width.equalToSuperview().multipliedBy(0.58)
            make.height.equalTo(imageView.snp.width).multipliedBy(1.19)
        }
        
        labelImageView.snp.makeConstraints { make in
            make.top.equalTo(imageView.snp.bottom).offset(36)
            make.centerX.equalToSuperview()
            make.width.equalTo(imageView.snp.width).multipliedBy(1.34)
            make.height.equalTo(labelImageView.snp.width).multipliedBy(0.35)
        }
    }
}

extension SplashViewController {
    
    private func animation() {
        imageView.alpha = 0
        labelImageView.alpha = 0
        
        UIView.animate(withDuration: 1.0, delay: 1.5, options: .curveEaseOut, animations: {
            self.imageView.alpha = 1
            self.labelImageView.alpha = 1
        }) { [weak self] _ in
            guard let self = self else { return }
            self.splash()
        }
    }
    
    private func splash() {
        
        if UserManager.onboarding {
            // ⭐️네트워크 상태 확인
            tryLogin { [weak self] result in
                guard let self = self else { return }
                switch result {
                case .success(_):
                    // ⭐️로그인 성공! => 이미 가입한 유저 + 토큰 만료 안됨 (나중에 홈탭바 뷰컨으로 수정)
                    let vc = HomeViewController()
                    vc.modalPresentationStyle = .fullScreen
                    self.present(vc, animated: true)
                case .failure(let error):
                    switch error {
                    case .firebaseTokenError:
                        self.refreshRequest()
                    case .unknownUser:
                        UserManager.authDone = error.rawValue
                        let vc = PhoneViewController()
                        self.transitionViewController(viewController: vc, transitionStyle: .presentFullNavigation)
                    default:
                        let vc = PhoneViewController()
                        self.transitionViewController(viewController: vc, transitionStyle: .presentFullNavigation)
                    }
                }
            }
        } else {
            let vc = OnboardingViewController()
            vc.modalPresentationStyle = .fullScreen
            self.present(vc, animated: false)
        }
    }
    
    private func tryLogin(completion: @escaping (Result<UserData,SeSACError>) -> Void) {
        sesacAPIService.request(type: UserData.self, router: .login) { result in
            switch result {
            case .success(let success):
                completion(.success(success))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    private func refreshRequest() {
        let currentUser = Auth.auth().currentUser
        currentUser?.getIDTokenForcingRefresh(true) { [weak self] idToken, error in
            guard let self = self else { return }
            if let error = error {
                self.view.makeToast(error.localizedDescription, duration: 1, position: .center)
            }
            guard let token = idToken else { return }
            UserManager.token = token
            self.tryLogin { result in
                switch result {
                case .success(_):
                    let vc = HomeViewController()
                    vc.modalPresentationStyle = .fullScreen
                    self.present(vc, animated: true)
                case .failure(let error):
                    switch error{
                    case .unknownUser:
                        UserManager.authDone = error.rawValue
                        let vc = PhoneViewController()
                        self.transitionViewController(viewController: vc, transitionStyle: .presentFullNavigation)
                    default :
                        let vc = PhoneViewController()
                        self.transitionViewController(viewController: vc, transitionStyle: .presentFullNavigation)
                    }
                }
            }
        }
    }
    
}
