//
//  SearchViewController.swift
//  SeSAC_StudyApp
//
//  Created by Seo Jae Hoon on 2022/11/19.
//

import UIKit

import RxCocoa
import RxSwift
import RxKeyboard

final class SearchViewController: BaseViewController{
    
    //MARK: Property
    private lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewLayout.init()).then {
        $0.keyboardDismissMode = .onDrag
        $0.showsVerticalScrollIndicator = false
        $0.register(SearchCollectionViewCell.self, forCellWithReuseIdentifier: SearchCollectionViewCell.reuseIdentifier)
    }
    
    private lazy var searchBar = UISearchBar(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width - 68, height: 0))
    
    private lazy var searchButton = NextButton(title: "새싹 찾기", status: .fill)
    
    let viewModel = SearchViewModel()
    private let disposeBag = DisposeBag()
    
    private var dataSource: DataSource!
    private typealias DataSource = UICollectionViewDiffableDataSource<Int, StudyTag>
    private typealias Snapshot = NSDiffableDataSourceSnapshot<Int, StudyTag>

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setNavigationController()
        
        collectionView.collectionViewLayout = configureCellLayout()
        viewModelBinding()
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
        self.tabBarController?.tabBar.isHidden = true
        navigationController?.navigationBar.isHidden = false
        searchBar.placeholder = "띄어쓰기로 복수 입력이 가능해요"
        searchBar.enablesReturnKeyAutomatically = false
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: searchBar)
        
        let backButton = UIBarButtonItem(image: UIImage(named: "arrow"), style: .plain, target: self, action: nil)
        backButton.tintColor = .textColor
        navigationItem.leftBarButtonItem = backButton
        
        backButton.rx.tap
            .throttle(.seconds(2), scheduler: MainScheduler.instance)
            .withUnretained(self)
            .bind { weakSelf, _ in
                weakSelf.navigationController?.popViewController(animated: true)
            }
            .disposed(by: disposeBag)
    }
    
    private func viewModelBinding() {
        
        let input = SearchViewModel.Input(viewDidLoadEvent: Observable.just(()),
                                          searchTap: searchBar.rx.searchButtonClicked,
                                          findTap: searchButton.rx.tap)
        let output = viewModel.transform(input: input)
        
        output.searchTap
            .withUnretained(self)
            .bind { weakSelf, text in
                guard let text = weakSelf.searchBar.text else {return}
                let separatedText = text.components(separatedBy: " ").filter {$0 != ""}
                let resultText = separatedText.map({StudyTag(tag: $0)})
                let study = weakSelf.viewModel.searchList.map { $0.tag }
                
                if separatedText.filter({ $0.count > 8}).count != 0 {
                    weakSelf.view.makeToast(StudySearchMessage.searchBarTextRequire, duration: 1, position: .center)
                } else if separatedText.filter({ study.contains($0)}).count != 0 || separatedText.count != Set(separatedText).count {
                    weakSelf.view.makeToast(StudySearchMessage.overlapWord, duration: 1, position: .center)
                } else {
                    if weakSelf.viewModel.searchList.count >= 8 {
                        weakSelf.view.makeToast(StudySearchMessage.maxStudyRegister, duration: 1, position: .center)
                    } else {
                        weakSelf.viewModel.searchList.append(contentsOf: resultText)
                        weakSelf.updateSnapshot()
                    }
                }
            }
            .disposed(by: disposeBag)
            
        output.searchInfo
            .withUnretained(self)
            .bind { weakSelf, _ in
                weakSelf.updateSnapshot()
            }
            .disposed(by: disposeBag)
        
        output.isFailed
            .asDriver(onErrorJustReturn: true)
            .drive { [weak self] isFailed in
                guard let self = self else { return }
                if isFailed {
                    self.view.makeToast("데이터 통신에 실패했습니다", duration: 1, position: .center)
                }
            }
            .disposed(by: disposeBag)
        
        collectionView.rx.itemSelected
            .withUnretained(self)
            .bind { weakSelf, indexPath in
                let study = weakSelf.viewModel.searchList.map { $0.tag }
                if indexPath.section == 0 {
                    let insertStudy = weakSelf.viewModel.baseList[indexPath.item].tag
                    if study.contains(insertStudy){
                        weakSelf.view.makeToast(StudySearchMessage.overlapWord, duration: 1, position: .center)
                    } else {
                        if weakSelf.viewModel.searchList.count >= 8 {
                            weakSelf.view.makeToast(StudySearchMessage.maxStudyRegister, duration: 1, position: .center)
                        } else {
                            weakSelf.viewModel.searchList.append(StudyTag(tag: insertStudy))
                            weakSelf.updateSnapshot()
                        }
                    }
                } else if indexPath.section == 1 {
                    let insertStudy = weakSelf.viewModel.friendList[indexPath.item].tag
                    if study.contains(insertStudy) {
                        weakSelf.view.makeToast(StudySearchMessage.overlapWord, duration: 1, position: .center)
                    } else {
                        if weakSelf.viewModel.searchList.count >= 8 {
                            weakSelf.view.makeToast(StudySearchMessage.maxStudyRegister, duration: 1, position: .center)
                        } else {
                            weakSelf.viewModel.searchList.append(StudyTag(tag: insertStudy))
                            weakSelf.updateSnapshot()
                        }
                    }
                } else {
                    weakSelf.viewModel.searchList.remove(at: indexPath.item)
                    weakSelf.updateSnapshot()
                }
            }
            .disposed(by: disposeBag)
        
        output.searchSuccess
            .withUnretained(self)
            .bind { weakSelf, value in
                if value {
                    let vc = SeSACTabManViewController()
                    vc.firstVC.viewModel.location = weakSelf.viewModel.location
                    vc.secondVC.viewModel.location = weakSelf.viewModel.location
                    weakSelf.transitionViewController(viewController: vc, transitionStyle: .push)
                }
            }
            .disposed(by: disposeBag)
        
        output.searchFailed
            .withUnretained(self)
            .bind { weakSelf, error in
                weakSelf.view.makeToast(error, duration: 1, position: .center)
            }
            .disposed(by: disposeBag)
        
        searchBar.rx.searchButtonClicked
            .withUnretained(self)
            .bind { weakSelf, _ in
                weakSelf.searchBar.text = nil
                weakSelf.searchBar.endEditing(true)
            }
            .disposed(by: disposeBag)
        
        RxKeyboard.instance.visibleHeight
            .skip(1)
            .drive { [weak self] keyboardHeight in
                guard let self = self else { return }
                
                UIView.animate(withDuration: 0) {
                    if keyboardHeight == 0 {
                        self.searchButton.snp.updateConstraints { make in
                            make.horizontalEdges.equalToSuperview().inset(16)
                            make.bottom.equalToSuperview().offset(-50)
                        }
                        self.searchButton.layer.cornerRadius = 8
                    } else {
                        let totalHeight = keyboardHeight - self.view.safeAreaInsets.bottom
                        self.searchButton.snp.updateConstraints { make in
                            make.horizontalEdges.equalToSuperview()
                            make.bottom.equalToSuperview().offset(-totalHeight - 34)
                        }
                        self.searchButton.layer.cornerRadius = 0
                    }
                    self.view.layoutIfNeeded()
                }
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
        
        let cellRegisteration = UICollectionView.CellRegistration<SearchCollectionViewCell,StudyTag>(handler: { cell, indexPath, itemIdentifier in
            if indexPath.section == 0 {
                cell.searchButton.status = .redOutline
                cell.searchButton.text = itemIdentifier.tag
            } else if indexPath.section == 1{
                cell.searchButton.status = .inactive
                cell.searchButton.text = itemIdentifier.tag
            } else {
                cell.searchButton.status = .outline
                cell.searchButton.text = "\(itemIdentifier.tag) X"
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
