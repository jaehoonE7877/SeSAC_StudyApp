//
//  SeSACImageViewController.swift
//  SeSAC_StudyApp
//
//  Created by Seo Jae Hoon on 2022/12/05.
//

import UIKit
import RxSwift
import RxCocoa

final class SeSACImageViewController : BaseViewController {
    
    //collectionView
    let collectionView = UICollectionView().then {
        $0.showsVerticalScrollIndicator = false
        //$0.contentInset = .init(top: 16, left: 0, bottom: 0, right: 0)
        $0.backgroundColor = .systemBackground
        $0.register(CardViewCell.self, forCellReuseIdentifier: CardViewCell.reuseIdentifier)
        $0.separatorStyle = .none
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
}
