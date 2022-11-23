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
    
    let firstVC = SeSACSearchViewController()
    let secondVC = ReceivedViewController()
    
    private let disposeBag = DisposeBag()
    
    lazy var callOffButton = UIBarButtonItem(title: "찾기중단", style: .plain, target: self, action: nil)
    lazy var backButton = UIBarButtonItem(image: UIImage(named: "arrow"), style: .plain, target: self, action: nil)
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupTabMan()
        setNavigation()
        bindUI()
    }
    
    private func setNavigation() {
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
    
    private func bindUI() {
        backButton.rx.tap
            .withUnretained(self)
            .bind { weakSelf, _ in
                weakSelf.navigationController?.popViewController(animated: true)
            }
            .disposed(by: disposeBag)
        
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
