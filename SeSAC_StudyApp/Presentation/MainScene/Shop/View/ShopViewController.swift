//
//  ShopViewController.swift
//  SeSAC_StudyApp
//
//  Created by Seo Jae Hoon on 2022/11/12.
//

import UIKit

import RxCocoa
import RxSwift

final class ShopViewController: BaseViewController {
    
    //이미지 + 저장하기 버튼 + 컨테이너뷰 -> 탭 맨 뷰컨 -> 뷰컨 2개(왼쪽 컬렉션 뷰 오른쪽 테이블 뷰)
    private let mainView = ShopView()
    
    private let tabmanVC = ShopTabManViewController()
    
    override func loadView() {
        self.view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setNavigationController()
        
        self.addChild(tabmanVC)
        self.view.addSubview(tabmanVC.view)
        tabmanVC.view.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview()
            make.top.equalTo(mainView.sesacImageView.snp.bottom)
            make.bottom.equalTo(mainView.safeAreaLayoutGuide)
        }
        tabmanVC.didMove(toParent: self)
    }
    override func setNavigationController() {
        title = "새싹샵"
        navigationController?.navigationBar.tintColor = .textColor
    }
        
        
}
