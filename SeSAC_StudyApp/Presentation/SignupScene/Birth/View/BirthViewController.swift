//
//  BirthViewController.swift
//  SeSAC_StudyApp
//
//  Created by Seo Jae Hoon on 2022/11/10.
//

import UIKit

import RxCocoa
import RxSwift

final class BirthViewController: BaseViewController {
    
    private let mainView = BirthView()
    
    private let disposeBag = DisposeBag()
    private let viewModel = BirthViewModel()
    
    override func loadView() {
        self.view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func setNavigationController() {
        let backButton = UIBarButtonItem(image: UIImage(named: "arrow"), style: .plain, target: self, action: #selector(backButtonTapped))
        backButton.tintColor = .textColor
        self.navigationItem.leftBarButtonItem = backButton
    }
    
    @objc private func backButtonTapped() {
        
    }
    
    override func setBinding() {
        
    }
}
