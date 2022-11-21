//
//  SearchViewController.swift
//  SeSAC_StudyApp
//
//  Created by Seo Jae Hoon on 2022/11/19.
//

import UIKit

import RxCocoa
import RxSwift

final class SearchViewController: BaseViewController {
    
    //MARK: Property
    private lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewLayout.init()).then {
        $0.register(SearchCollectionViewCell.self, forCellWithReuseIdentifier: SearchCollectionViewCell.reuseIdentifier)
    }
    
    private lazy var searchButton = NextButton(title: "새싹 찾기", status: .fill)
    
    private var dataSource: DataSource!
    private typealias DataSource = UICollectionViewDiffableDataSource<Int, String>
    private typealias Snapshot = NSDiffableDataSourceSnapshot<Int, String>
    
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setNavigationController()
    }
    
    override func configure() {
        view.backgroundColor = .systemBackground
        view.addSubview(collectionView)
        view.addSubview(searchButton)
    }
    
    override func setConstraint() {
        collectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        searchButton.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(16)
            make.height.equalTo(48)
            make.bottom.equalToSuperview().offset(-50)
        }
    }
    
    override func setNavigationController() {
        let searchBar = UISearchBar(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width - 68, height: 0))
        searchBar.placeholder = "띄어쓰기로 복수 입력이 가능해요"
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: searchBar)
        
        let backButton = UIBarButtonItem(image: UIImage(named: "arrow"), style: .plain, target: self, action: nil)
        backButton.tintColor = .textColor
        navigationItem.leftBarButtonItem = backButton
        
        backButton.rx.tap
            .withUnretained(self)
            .bind { weakSelf, _ in
                weakSelf.navigationController?.popViewController(animated: true)
            }
            .disposed(by: disposeBag)
    }
    

}

extension SearchViewController {
    
//    private func configureCellLayout() -> UICollectionViewLayout {
//
//
//        let section = NSCollectionLayoutSection(group: nestedGroup)
//
//        let layout = UICollectionViewCompositionalLayout(section: section)
//
//        return layout
//    }
    
}
