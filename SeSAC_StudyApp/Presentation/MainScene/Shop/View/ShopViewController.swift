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
    
    private let disposeBag = DisposeBag()
    
    private let viewModel = ShopViewModel()
    
    override func loadView() {
        self.view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setNavigationController()
        
        self.addChild(tabmanVC)
        self.view.addSubview(tabmanVC.view)
        tabmanVC.view.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview()
            make.top.equalTo(mainView.sesacImageView.snp.bottom)
            make.bottom.equalTo(mainView.safeAreaLayoutGuide)
        }
        tabmanVC.didMove(toParent: self)
        viewModelBinding()
        
    }
    override func setNavigationController() {
        title = "새싹샵"
        navigationController?.navigationBar.tintColor = .textColor
    }
        
    private func viewModelBinding() {
        
        let input = ShopViewModel.Input(viewWillAppearEvent: self.rx.viewWillAppear)
        let output = viewModel.transform(input: input)
        
        output.fetchFailed
            .asDriver(onErrorJustReturn: "")
            .drive { [weak self] error in
                guard let self = self else { return }
                self.view.makeToast(error, duration: 1, position: .center)
            }
            .disposed(by: disposeBag)
        
        output.myInfoData
            .withUnretained(self)
            .subscribe { weakSelf, data in
                weakSelf.mainView.sesacImageView.image = UIImage(named: "sesac_face_\(data.sesac)")
                weakSelf.mainView.bgImageView.image = UIImage(named: "sesac_background_\(data.background)")
                weakSelf.tabmanVC.firstVC.sesacArray = data.sesacCollection
                weakSelf.tabmanVC.secondVC.backgroundArray = data.backgroundCollection
                weakSelf.tabmanVC.firstVC.collectionView.reloadData()
                weakSelf.tabmanVC.secondVC.collectionView.reloadData()
            }
            .disposed(by: disposeBag)
            
        
    }
}
