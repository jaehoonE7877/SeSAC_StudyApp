//
//  SeSACTabManViewController.swift
//  SeSAC_StudyApp
//
//  Created by Seo Jae Hoon on 2022/11/23.
//

import UIKit

import RxSwift
import RxCocoa
import Tabman
import Pageboy

final class SeSACTabManViewController: TabmanViewController {
    
    private var viewControllers = [UIViewController]()
    let viewModel = SeSACSearchViewModel()
    let firstVC = SeSACSearchViewController()
    let secondVC = ReceivedViewController()
    
    var timerDisposable: Disposable?
    
    private let disposeBag = DisposeBag()
    
    lazy var callOffButton = UIBarButtonItem(title: "찾기중단", style: .plain, target: self, action: nil)
    lazy var backButton = UIBarButtonItem(image: UIImage(named: "arrow"), style: .plain, target: self, action: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupTabMan()
        setNavigation()
        bindViewModel()
        NotificationCenter.default.addObserver(self, selector: #selector(removeTimer), name: NSNotification.Name("timer"), object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        timerDisposable?.dispose()
    }
    
    private func setNavigation() {
        tabBarController?.tabBar.isHidden = true
        navigationController?.navigationBar.isHidden = false
        title = "새싹 찾기"
        navigationItem.backButtonTitle = ""
        navigationController?.navigationBar.tintColor = .textColor
        
        navigationItem.leftBarButtonItem = backButton
        navigationItem.rightBarButtonItem = callOffButton
        
        let appearance = UINavigationBarAppearance()
        navigationController?.navigationBar.backgroundColor = .white
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
    }
    
    private func bindViewModel() {
        
        let timer = Observable<Int>
            .timer(.seconds(1), period: .seconds(5), scheduler: MainScheduler.instance)
        
        startTimer(time: timer)
        
        backButton.rx.tap
            .withUnretained(self)
            .bind { weakSelf, _ in
                weakSelf.navigationController?.popToRootViewController(animated: true)
            }
            .disposed(by: disposeBag)
        
        callOffButton.rx.tap
            .withUnretained(self)
            .subscribe { weakSelf, _ in
                weakSelf.viewModel.callOffSearch { statusCode in
                    switch SeSACCallOffError(rawValue: statusCode){
                    case .success:
                        weakSelf.navigationController?.popToRootViewController(animated: true)
                    case .firebaseTokenError:
                        weakSelf.view.makeToast("토큰 갱신에 실패했습니다. 잠시 후 다시 시도해주세요", duration: 1, position: .center)
                    default:
                        weakSelf.view.makeToast(SeSACCallOffError(rawValue: statusCode)?.errorDescription, position: .center)
                    }
                }
            }
            .disposed(by: disposeBag)
    }
    
    private func startTimer(time: Observable<Int>) {
        timerDisposable?.dispose()
        timerDisposable = time
            .withUnretained(self)
            .subscribe(onNext: { weakSelf, _ in
                weakSelf.viewModel.getMyStatus { result in
                    switch result{
                    case .success(let data):
                        print(data.matched)
                        if data.matched == 1{
                            print(data.matchedUid)
                            NotificationCenter.default.post(name: NSNotification.Name("timer"), object: nil)
                            guard let nick = data.matchedNick else { return }
                            weakSelf.view.makeToast("\(nick)님과 매칭되셨습니다. 잠시 후 채팅방으로 이동합니다", duration: 1 ,position: .center) { _ in
                                let chatVC = ChatViewController()
                                chatVC.viewModel.matchedUserData = data
                                chatVC.title = nick
                                weakSelf.transitionViewController(viewController: chatVC, transitionStyle: .push)
                            }
                        }
                    case .failure(let error):
                        weakSelf.view.makeToast(error.errorDescription, position: .center)
                    }
                }
            })
    }
    
    private func setupTabMan() {
        
        [firstVC, secondVC].forEach { viewControllers.append($0)}
        
        self.dataSource = self
        
        let bar = TMBar.ButtonBar()
        bar.backgroundView.style = .blur(style: .light)
        bar.layout.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        bar.layout.contentMode = .fit
        bar.buttons.customize { (button) in
            button.selectedTintColor = .ssGreen
            button.tintColor = .gray6
            button.font = .notoSans(size: 14, family: .Regular)
            button.selectedFont = .notoSans(size: 14, family: .Medium)
        }
        bar.indicator.overscrollBehavior = .bounce
        bar.indicator.weight = .custom(value: 1)
        bar.indicator.tintColor = .ssGreen
        addBar(bar, dataSource: self, at: .top)
    }
    
    @objc private func removeTimer() {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name("timer"), object: nil)
        timerDisposable?.dispose()
    }
}

extension SeSACTabManViewController: PageboyViewControllerDataSource, TMBarDataSource {
    func numberOfViewControllers(in pageboyViewController: Pageboy.PageboyViewController) -> Int {
        return viewControllers.count
    }
    
    func viewController(for pageboyViewController: Pageboy.PageboyViewController, at index: Pageboy.PageboyViewController.PageIndex) -> UIViewController? {
        return viewControllers[index]
    }
    
    func defaultPage(for pageboyViewController: Pageboy.PageboyViewController) -> Pageboy.PageboyViewController.Page? {
        return nil
    }
    
    func barItem(for bar: Tabman.TMBar, at index: Int) -> Tabman.TMBarItemable {
        
        switch index {
        case 0:
            return TMBarItem(title: "주변 새싹")
        case 1:
            return TMBarItem(title: "받은 요청")
        default:
            let title = "Page \(index)"
            return TMBarItem(title: title)
        }
        
    }
    
    
}
