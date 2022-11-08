//
//  AuthViewController.swift
//  SeSAC_StudyApp
//
//  Created by Seo Jae Hoon on 2022/11/08.
//

import UIKit

import RxSwift
import RxCocoa

final class AuthViewController: BaseViewController {
    
    private let mainView = AuthView()
    
    override func loadView() {
        self.view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
}
