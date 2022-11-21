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
        $0.showsVerticalScrollIndicator = false
        $0.register(SearchCollectionViewCell.self, forCellWithReuseIdentifier: SearchCollectionViewCell.reuseIdentifier)
    }
    
    private lazy var searchBar = UISearchBar(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width - 68, height: 0))
    
    private lazy var searchButton = NextButton(title: "새싹 찾기", status: .fill)
    
    private let viewModel = SearchViewModel()
    private let disposeBag = DisposeBag()
    
    private var dataSource: DataSource!
    private typealias DataSource = UICollectionViewDiffableDataSource<Int, String>
    private typealias Snapshot = NSDiffableDataSourceSnapshot<Int, String>

    override func viewDidLoad() {
        super.viewDidLoad()
        setNavigationController()
        collectionView.collectionViewLayout = configureCellLayout()
        configureDataSource()
        
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
        
        searchBar.placeholder = "띄어쓰기로 복수 입력이 가능해요"
        searchBar.enablesReturnKeyAutomatically = false
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: searchBar)
        
        let backButton = UIBarButtonItem(image: UIImage(named: "arrow"), style: .plain, target: self, action: nil)
        backButton.tintColor = .textColor
        navigationItem.leftBarButtonItem = backButton
        
        backButton.rx.tap
            .withUnretained(self)
            .bind { weakSelf, _ in
                weakSelf.dismiss(animated: true)
            }
            .disposed(by: disposeBag)
    }
    
    override func setBinding() {
        
        let input = SearchViewModel.Input(viewDidLoadEvent: Observable.just(()),
                                          searchText: searchBar.rx.searchButtonClicked)
        let output = viewModel.transform(input: input)
        
        output.searchText
            .withUnretained(self)
            .bind { weakSelf, text in
                weakSelf.viewModel.searchList.append(weakSelf.searchBar.text ?? "")
                weakSelf.updateSnapshot()
            }
            .disposed(by: disposeBag)
            
    }
    

}

extension SearchViewController {
    
    private func configureCellLayout() -> UICollectionViewLayout {
        
        let sectionProvider = { (sectionIndex: Int, layoutEnvironment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection? in
            if sectionIndex == 1 {
                let itemSize = NSCollectionLayoutSize(widthDimension: .estimated(60), heightDimension: .absolute(32))
                let item = NSCollectionLayoutItem(layoutSize: itemSize)
                let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(32))
                let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
                group.interItemSpacing = .fixed(8)
                let section = NSCollectionLayoutSection(group: group)
                section.interGroupSpacing = 8
                section.contentInsets = NSDirectionalEdgeInsets(top: 8, leading: 16, bottom: 8, trailing: 16)
                return section
            } else {
                let itemSize = NSCollectionLayoutSize(widthDimension: .estimated(60), heightDimension: .absolute(32))
                let item = NSCollectionLayoutItem(layoutSize: itemSize)
                let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(32))
                let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
                group.interItemSpacing = .fixed(8)
                let section = NSCollectionLayoutSection(group: group)
                section.interGroupSpacing = 8
                section.contentInsets = NSDirectionalEdgeInsets(top: 8, leading: 16, bottom: 8, trailing: 16)
                section.boundarySupplementaryItems = [NSCollectionLayoutBoundarySupplementaryItem(layoutSize:
                                                                                                    NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(40)),
                                                                                                  elementKind: UICollectionView.elementKindSectionHeader,
                                                                                                  alignment: .top)]
                return section
            }
        }
        let layout = UICollectionViewCompositionalLayout(sectionProvider: sectionProvider)
        return layout
    }
    
    private func configureDataSource() {
        
        let cellRegisteration = UICollectionView.CellRegistration<SearchCollectionViewCell,String>(handler: { cell, indexPath, itemIdentifier in
            if indexPath.section == 0 {
                cell.searchButton.status = .redOutline
                cell.searchButton.text = itemIdentifier
            } else if indexPath.section == 1{
                cell.searchButton.status = .inactive
                cell.searchButton.text = itemIdentifier
            } else {
                cell.searchButton.status = .outline
                cell.searchButton.text = "\(itemIdentifier) X"
            }
        })
        
        let headerRegisteration = UICollectionView.SupplementaryRegistration<UICollectionViewListCell>(elementKind: UICollectionView.elementKindSectionHeader) { headerView, elementKind, indexPath in
            var configuration = headerView.defaultContentConfiguration()
            configuration.text = indexPath.section == 0 ? "지금 주변에는" : "내가 하고 싶은"
            configuration.textProperties.font = UIFont.notoSans(size: 12, family: .Regular)
            configuration.textProperties.color = UIColor.textColor!
            headerView.contentConfiguration = configuration
        }
        
        dataSource = UICollectionViewDiffableDataSource(collectionView: collectionView, cellProvider: { collectionView, indexPath, itemIdentifier in
            
            let cell = collectionView.dequeueConfiguredReusableCell(using: cellRegisteration, for: indexPath, item: itemIdentifier)
            
            return cell
        })
        
        dataSource.supplementaryViewProvider = { [weak self] (collectionView, elementKind, indexPath) -> UICollectionReusableView? in
            return self?.collectionView.dequeueConfiguredReusableSupplementary(using: headerRegisteration, for: indexPath)
        }
        
        updateSnapshot()
    }
    
    private func updateSnapshot() {
        var snapshot = Snapshot()
        snapshot.appendSections([0, 1, 2])
        snapshot.appendItems(viewModel.baseList, toSection: 0)
        snapshot.appendItems(viewModel.friendList, toSection: 1)
        snapshot.appendItems(viewModel.searchList, toSection: 2)
        dataSource.apply(snapshot)
    }
    
}
