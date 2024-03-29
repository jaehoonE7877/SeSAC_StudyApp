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
    //MARK: Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if UserManager.nickError {
            mainView.mainButton.status = .fill
            switch UserManager.gender {
            case Gender.man.rawValue:
                mainView.manView.backgroundColor = .ssWhiteGreen
            case Gender.woman.rawValue:
                mainView.womanView.backgroundColor = .ssWhiteGreen
            default:
                break
            }
        }
    }
    
    override func setBinding() {
        
        let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene
        let sceneDelegate = windowScene?.delegate as? SceneDelegate
        
        let input = GenderViewModel.Input(nextButtonTap: mainView.mainButton.rx.tap,
                                          manButtonTap: mainView.manView.button.rx.tap,
                                          womanButtonTap: mainView.womanView.button.rx.tap)
        let output = viewModel.transform(input: input)
        
        output.manButtonTap
            .withUnretained(self)
            .bind { weakSelf, _ in
                weakSelf.mainView.manView.backgroundColor = .ssWhiteGreen
                weakSelf.mainView.womanView.backgroundColor = .clear
                weakSelf.mainView.mainButton.status = .fill
                
            }
            .disposed(by: disposeBag)
        
        output.womanButtonTap
            .withUnretained(self)
            .bind { weakSelf, _ in
                weakSelf.mainView.womanView.backgroundColor = .ssWhiteGreen
                weakSelf.mainView.manView.backgroundColor = .clear
                weakSelf.mainView.mainButton.status = .fill
            }
            .disposed(by: disposeBag)
        
        output.nextButtonTap
            .withUnretained(self)
            .throttle(.seconds(5), scheduler: MainScheduler.instance)
            .bind { weakSelf, _ in
                if weakSelf.mainView.manView.backgroundColor == .ssWhiteGreen {
                    UserManager.gender = Gender.man.rawValue
                    weakSelf.viewModel.signup { result in
                        switch result {
                        case .success(_):
                            UserManager.nickError = false
                            sceneDelegate?.window?.rootViewController = TabViewController()
                        case .failure(let error):
                            switch error {
                            case .alreadySignedup:
                                weakSelf.popToVC(viewController: PhoneViewController(), errorMessage: SeSACError.alreadySignedup.localizedDescription)
                            case .forbiddenNick:
                                UserManager.nickError = true
                                weakSelf.popToVC(viewController: NicknameViewController(), errorMessage: SeSACError.forbiddenNick.localizedDescription)
                            default:
                                UserManager.nickError = false
                                weakSelf.mainView.makeToast(error.localizedDescription, duration: 1, position: .center)
                            }
                        }
                    }
                } else if weakSelf.mainView.womanView.backgroundColor == .ssWhiteGreen {
                    UserManager.gender = Gender.woman.rawValue
                    weakSelf.viewModel.signup { result in
                        switch result {
                        case .success(_):
                            UserManager.nickError = false
                            sceneDelegate?.window?.rootViewController = TabViewController()
                        case .failure(let error):
                            switch error {
                            case .alreadySignedup:
                                weakSelf.popToVC(viewController: PhoneViewController(), errorMessage: SeSACError.alreadySignedup.localizedDescription)
                            case .forbiddenNick:
                                UserManager.nickError = true
                                weakSelf.popToVC(viewController: NicknameViewController(), errorMessage: SeSACError.forbiddenNick.localizedDescription)
                            default:
                                UserManager.nickError = false
                                weakSelf.mainView.makeToast(error.localizedDescription, duration: 1, position: .center)
                            }
                        }
                    }
                } else {
                    weakSelf.mainView.makeToast("성별을 선택해주세요", duration: 1, position: .center)
                }
                sceneDelegate?.window?.makeKeyAndVisible()
            }
            .disposed(by: disposeBag)
    }
}
extension GenderViewController {
    
    private func popToVC<T: BaseViewController>(viewController: T, errorMessage: String){
        guard let viewControllerStack = self.navigationController?.viewControllers else { return }
        
        for viewController in viewControllerStack {
            if let viewController = viewController as? T {
                self.navigationController?.popToViewController(viewController, animated: true)
                viewController.view.makeToast(errorMessage, duration: 1, position: .center)
            }
        }
    }
}
