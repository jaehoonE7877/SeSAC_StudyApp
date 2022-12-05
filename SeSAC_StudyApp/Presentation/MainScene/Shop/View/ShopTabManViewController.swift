//
//  ShopTabManViewController.swift
//  SeSAC_StudyApp
//
//  Created by Seo Jae Hoon on 2022/12/05.
//

import UIKit

import RxCocoa
import RxSwift
import Tabman
import Pageboy

final class ShopTabManViewController: TabmanViewController {
    
    private var viewControllers = [UIViewController]()
    
    let firstVC = SeSACImageViewController()
    let secondVC = SeSACBackgroundImageViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupTabMan()
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

extension ShopTabManViewController: PageboyViewControllerDataSource, TMBarDataSource {
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
            return TMBarItem(title: "새싹")
        case 1:
            return TMBarItem(title: "배경")
        default:
            let title = "Page \(index)"
            return TMBarItem(title: title)
        }
        
    }
}
