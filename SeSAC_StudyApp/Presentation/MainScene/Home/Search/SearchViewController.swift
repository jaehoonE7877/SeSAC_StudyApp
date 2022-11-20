//
//  SearchViewController.swift
//  SeSAC_StudyApp
//
//  Created by Seo Jae Hoon on 2022/11/19.
//

import UIKit

final class SearchViewController: BaseViewController {
    
    //MARK: Property
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setNavigationController()
    }
    
    override func setNavigationController() {
        let searchBar = UISearchBar()
        searchBar.placeholder = "띄어쓰기로 복수 입력이 가능해요"
        navigationItem.titleView = searchBar
    }
    
}
