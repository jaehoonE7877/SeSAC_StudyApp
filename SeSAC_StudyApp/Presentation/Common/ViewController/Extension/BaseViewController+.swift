//
//  BaseViewController+.swift
//  SeSAC_StudyApp
//
//  Created by Seo Jae Hoon on 2022/11/07.
//

import UIKit

enum TransitionStyle {
    case present
    case presentFullWithoutAni
    case presentFullNavigation
    case push
    case pushWithoutAni
}

extension UIViewController {
    
    func transitionViewController<T: UIViewController>(viewController vc: T, transitionStyle: TransitionStyle){
        let nav = UINavigationController(rootViewController: vc)
        
        switch transitionStyle {
        case .present:
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
