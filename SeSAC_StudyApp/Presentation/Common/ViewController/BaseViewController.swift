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
        tapGesture()
    }
    
    
    func configure() { }
    
    func setConstraint() { }
    
    func setNavigationController() {
        
        let appearance = UINavigationBarAppearance()
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        
        let backButton = UIBarButtonItem(image: UIImage(named: "arrow"), style: .plain, target: self, action: #selector(backButtonTapped))
        backButton.tintColor = .textColor
        self.navigationItem.leftBarButtonItem = backButton
    }
    
    @objc private func backButtonTapped() {
        self.navigationController?.popViewController(animated: true)
    }
    
    func setBinding() { }
    
    private func tapGesture(){
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapEndEditing))
        view.addGestureRecognizer(tap)
    }
    
    @objc private func tapEndEditing(){
        view.endEditing(true)
    }
    
}
