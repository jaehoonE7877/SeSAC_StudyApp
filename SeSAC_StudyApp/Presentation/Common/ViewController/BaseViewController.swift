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
        setBinding()
    }
    
    
    func configure() { }
    
    func setConstraint() { }
    
    func setNavigationController() {
        navigationItem.backButtonTitle = ""
        navigationController?.navigationBar.tintColor = .textColor
        
        let appearance = UINavigationBarAppearance()
        appearance.setBackIndicatorImage(UIImage(named: "arrow"), transitionMaskImage: UIImage(named: "arrow"))
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        
    }
    
    func setBinding() { }
    
//    private func tapGesture(){
//        let tap = UITapGestureRecognizer(target: self, action: #selector(tapEndEditing))
//        view.addGestureRecognizer(tap)
//    }
    
//    @objc private func tapEndEditing(){
//        view.endEditing(true)
//    }
    
}
