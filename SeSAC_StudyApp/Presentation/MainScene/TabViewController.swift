//
//  HomeViewController.swift
//  SeSAC_StudyApp
//
//  Created by Seo Jae Hoon on 2022/11/11.
//

import UIKit

final class TabViewController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTabbar()
        setTabbarAppearence()
    }
    
    private func setTabBar<T: UIViewController>(_ viewController: T, title: String, image: String) -> T {
            
            viewController.tabBarItem.title = title
            viewController.tabBarItem.image = UIImage(named: image)
         
            return viewController
        }
    
    private func configureTabbar() {
        let homeVC = setTabBar(MapViewController(), title: "홈", image: "home")
        let shopVC = setTabBar(ShopViewController(), title: "새싹샵", image: "shop")
        let friendVC = setTabBar(FriendViewController(), title: "새싹친구", image: "friend")
        let infoVC = setTabBar(InfoViewController(), title: "내정보", image: "info")
        let home = UINavigationController(rootViewController: homeVC)
        let shop = UINavigationController(rootViewController: shopVC)
        let info = UINavigationController(rootViewController: infoVC)
        
        setViewControllers([home, shop, friendVC, info], animated: true)
    }
    
    private func setTabbarAppearence() {
        let itemAppearance = UITabBarItemAppearance()
        let appearance = UITabBarAppearance()
        
        appearance.backgroundColor = .white
        itemAppearance.selected.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.ssGreen , NSAttributedString.Key.font: UIFont.notoSans(size: 12, family: .Regular)]
        appearance.stackedLayoutAppearance = itemAppearance
        tabBar.standardAppearance = appearance
        tabBar.scrollEdgeAppearance = appearance
   
        tabBar.backgroundColor = .white
        tabBar.tintColor = .ssGreen
        
    }
    
    
}
