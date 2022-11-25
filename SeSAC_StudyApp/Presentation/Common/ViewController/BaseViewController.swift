//
//  BaseViewController.swift
//  SeSAC_StudyApp
//
//  Created by Seo Jae Hoon on 2022/11/07.
//

import UIKit

import SnapKit
import Then
import JGProgressHUD

class BaseViewController: UIViewController {
    
    lazy var hud: JGProgressHUD = {
        let loader = JGProgressHUD(style: .dark)
        return loader
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configure()
        setConstraint()
        setBinding()
    }
    
    
    func configure() { }
    
    func setConstraint() { }
    
    func setNavigationController() {
        navigationItem.backButtonTitle = ""
        navigationController?.navigationBar.tintColor = .textColor

        let appearance = UINavigationBarAppearance()
        appearance.setBackIndicatorImage(UIImage(named: "arrow"), transitionMaskImage: UIImage(named: "arrow"))
        appearance.backgroundColor = .systemBackground
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        
    }
    
    func setBinding() { }
    
    func showLoading() {
        DispatchQueue.main.async {
            self.hud.show(in: self.view, animated: true)
        }
    }
    
    func hideLoading() {
        DispatchQueue.main.async {
            self.hud.dismiss(animated: true)
        }
    }
    
}
