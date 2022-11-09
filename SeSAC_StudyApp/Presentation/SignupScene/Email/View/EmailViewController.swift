//
//  EmailViewController.swift
//  SeSAC_StudyApp
//
//  Created by Seo Jae Hoon on 2022/11/10.
//

import UIKit

import RxCocoa
import RxSwift

final class EmailViewController: BaseViewController {
    
    private let mainView = EmailView()
    
    private let disposeBag = DisposeBag()
    private let viewModel = EmailViewModel()
    
    override func loadView() {
        self.view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func setBinding() {
        
    }
}
