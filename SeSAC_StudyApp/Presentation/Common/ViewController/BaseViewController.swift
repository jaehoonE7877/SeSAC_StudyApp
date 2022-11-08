//
//  BaseViewController.swift
//  SeSAC_StudyApp
//
//  Created by Seo Jae Hoon on 2022/11/07.
//

import UIKit

import SnapKit
import Then

class BaseViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configure()
        setConstraint()
        setNavigationController()
        setBinding()
    }
    
    
    func configure() { }
    
    func setConstraint() { }
    
    func setNavigationController() {
        let appearance = UINavigationBarAppearance()
        self.navigationController?.navigationBar.standardAppearance = appearance
        self.navigationController?.navigationBar.scrollEdgeAppearance = appearance
    }
    
    func setBinding() { }
    
    
    
}
