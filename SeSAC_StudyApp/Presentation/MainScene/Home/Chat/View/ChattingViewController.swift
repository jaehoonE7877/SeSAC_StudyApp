//
//  ChattingViewController.swift
//  SeSAC_StudyApp
//
//  Created by Seo Jae Hoon on 2022/11/27.
//

import UIKit

import RxSwift
import RxCocoa

final class ChatViewController: BaseViewController {
    
    private let mainView = ChatView()
    
    override func loadView() {
        self.view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setNavigationController()
    }
    
}
