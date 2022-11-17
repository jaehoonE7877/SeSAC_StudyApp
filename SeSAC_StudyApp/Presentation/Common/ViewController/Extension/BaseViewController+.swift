//
//  BaseViewController+.swift
//  SeSAC_StudyApp
//
//  Created by Seo Jae Hoon on 2022/11/07.
//

import UIKit

enum TransitionStyle {
    case present
    case presentFull
    case presentFullWithoutAni
    case presentFullNavigation
    case push
    case pushWithoutAni
    case presentOverFull
}

extension UIViewController {
    
    func transitionViewController<T: UIViewController>(viewController vc: T, transitionStyle: TransitionStyle){
        let nav = UINavigationController(rootViewController: vc)
        
        switch transitionStyle {
        case .present:
            self.present(vc, animated: true)
        case .presentOverFull:
            vc.modalPresentationStyle = .overFullScreen
            self.present(vc, animated: false)
        case .presentFull:
            vc.modalPresentationStyle = .fullScreen
            self.present(vc, animated: true)
        case .presentFullWithoutAni:
            vc.modalPresentationStyle = .fullScreen
            self.present(vc, animated: false)
        case .presentFullNavigation:
            nav.modalPresentationStyle = .fullScreen
            self.present(nav, animated: true)
        case .push:
            self.navigationController?.pushViewController(vc, animated: true)
        case .pushWithoutAni:
            self.navigationController?.pushViewController(vc, animated: false)
        }
    }
}

extension UIViewController {
    
    var topViewController: UIViewController {
        return self.topViewController(currentViewController: self)
    }
    
    // 최상위 뷰컨트롤러를 판단해주는 메서드
    // 1. 탭바
    // 2. 네비게이션
    // 3. 둘 다 없을 때
    func topViewController(currentViewController: UIViewController) -> UIViewController {
        
        if let tabBarController = currentViewController as? UITabBarController,
           let selectedViewController = tabBarController.selectedViewController {
            
            return self.topViewController(currentViewController: selectedViewController)
            
        } else if let navigationController = currentViewController as? UINavigationController,
                  let visibleViewController = navigationController.visibleViewController {
            
            return self.topViewController(currentViewController: visibleViewController)
            
        } else if let presentedViewController = currentViewController.presentedViewController {
            
            return self.topViewController(currentViewController: presentedViewController)
            
        } else {
            return currentViewController
        }
        

    }
    
}
