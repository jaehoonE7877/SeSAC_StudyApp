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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setNavigationController()
    }
}
