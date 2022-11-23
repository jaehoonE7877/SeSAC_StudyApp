//
//  SeSACSearchViewController.swift
//  SeSAC_StudyApp
//
//  Created by Seo Jae Hoon on 2022/11/23.
//

import UIKit

import RxSwift
import RxCocoa
import RxDataSources


final class SeSACSearchViewController: BaseViewController {
    
    private let mainView = SeSACSearchView()
    private let disposeBag = DisposeBag()
    let viewModel = SeSACSearchViewModel()
    
    private var sesacFriend: [SeSACCardModel]?
    
    var foldValues = [Bool]()
    
    override func loadView() {
        self.view = mainView
    }
    
    lazy var dataSource = RxTableViewSectionedReloadDataSource<SeSACCardSectionModel>(configureCell: { [weak self] dataSource, tableView, indexPath, item in
        guard let self = self else { return UITableViewCell()}
        
        guard let cell = self.mainView.tableView.dequeueReusableCell(withIdentifier: CardViewCell.reuseIdentifier, for: indexPath) as? CardViewCell else { return UITableViewCell()}
        cell.selectionStyle = .none
        cell.sesacStudyListView.collectionView.dataSource = self
        cell.sesacStudyListView.collectionView.register(SearchCollectionViewCell.self, forCellWithReuseIdentifier: SearchCollectionViewCell.reuseIdentifier)
        cell.sesacStudyListView.collectionView.collectionViewLayout = self.configureCellLayout()
        cell.sesacStudyListView.collectionView.tag = indexPath.section
        
        cell.chevornImageView.image = self.foldValues[indexPath.section] ? UIImage(named: "more_arrow_down") : UIImage(named: "more_arrow_up")
        cell.sesacTitleView.isHidden = self.foldValues[indexPath.section]
        cell.sesacReviewView.isHidden = self.foldValues[indexPath.section]
        cell.sesacStudyListView.isHidden = self.foldValues[indexPath.section]
        
        cell.sesacReviewView.reviewButton.rx.tap
            .bind { _ in
                let vc = ReviewViewController()
                vc.reviews = item.reviews
                self.transitionViewController(viewController: vc, transitionStyle: .push)
            }
            .disposed(by: self.disposeBag)
        
        cell.sesacStudyListView.collectionView.reloadData()
        
        cell.setDatas(item: item)
                
        return cell
    })
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindingViewModel()
        mainView.tableView.rx.setDelegate(self)
            .disposed(by: disposeBag)
    }
    
    private func bindingViewModel() {
        let input = SeSACSearchViewModel.Input(viewWillAppearEvent: self.rx.viewWillAppear)
        let output = viewModel.transform(input: input)
        
        output.fetchFailed
            .withUnretained(self)
            .bind { weakSelf, error in
                weakSelf.view.makeToast(error, duration: 1, position: .center)
            }
            .disposed(by: disposeBag)
        
        output.friendData
            .withUnretained(self)
            .subscribe { weakSelf, data in
                if data.count == 0 {
                    weakSelf.mainView.tableView.isHidden = true
                    weakSelf.mainView.friendEmptyView.isHidden = false
                } else {
                    weakSelf.sesacFriend = data
                    weakSelf.foldValues.append(contentsOf: Array<Bool>(repeating: true, count: data.count ))
                    weakSelf.bindingTableView(sesacFriends: data)
                }
            }
            .disposed(by: disposeBag)
    }
    
    override func setBinding() {
        mainView.friendEmptyView.studyChangeButton.rx.tap
            .withUnretained(self)
            .bind { weakSelf, _ in
                weakSelf.navigationController?.popViewController(animated: true)
            }
            .disposed(by: disposeBag)
    }
    
    private func bindingTableView(sesacFriends: [SeSACCardModel]) {
        
        var sections: [SeSACCardSectionModel] = []
        
        for friend in sesacFriends{
            sections.append(SeSACCardSectionModel(items: [SeSACCardModel(background: friend.background, sesac: friend.sesac, nick: friend.nick, reputation: friend.reputation, reviews: friend.reviews, studylist: friend.studylist)]))
        }
        
        Observable.just(sections)
            .bind(to: mainView.tableView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
        
        mainView.tableView.rx.itemSelected
            .withUnretained(self)
            .bind { weakSelf, indexPath in
                weakSelf.foldValues[indexPath.section].toggle()
                weakSelf.mainView.tableView.reloadSections(IndexSet(integer: indexPath.section), with: .fade)
            }
            .disposed(by: disposeBag)
    }
}
extension SeSACSearchViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 200
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let headerCell = tableView.dequeueReusableHeaderFooterView(withIdentifier: ProfileImageHeaderView.reuseIdentifier) as? ProfileImageHeaderView else { return nil}
        
        headerCell.requireButton.isHidden = false
        
        guard let items = sesacFriend else { return nil }
        headerCell.bgImageView.image = UIImage(named: "sesac_background_\(items[section].background)")
        headerCell.sesacImageView.image = UIImage(named: "sesac_face_\(items[section].sesac)")
        
        headerCell.requireButton.rx.tap
            .withUnretained(self)
            .bind { weakSelf, _ in
                let vc = RequireViewController()
                vc.viewModel.uid = items[section].uid
                vc.modalPresentationStyle = .overFullScreen
                weakSelf.present(vc, animated: false)
            }
            .disposed(by: disposeBag)
        
        return headerCell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return foldValues[indexPath.section] ? 60 : UITableView.automaticDimension
    }
}

extension SeSACSearchViewController: UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return sesacFriend?[collectionView.tag].studylist.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SearchCollectionViewCell.reuseIdentifier, for: indexPath) as? SearchCollectionViewCell else { return UICollectionViewCell()}
        
        guard var studyList = sesacFriend?[collectionView.tag].studylist else { return UICollectionViewCell()}
        studyList.indices.filter { studyList[$0] == "anything" }.forEach { studyList[$0] = "아무거나" }
        cell.searchButton.status = .inactive
        cell.searchButton.text = studyList[indexPath.item]
        
        return cell
    }
    
    private func configureCellLayout() -> UICollectionViewLayout {
        let itemSize = NSCollectionLayoutSize(widthDimension: .estimated(60), heightDimension: .estimated(32))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(96))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        group.interItemSpacing = .fixed(8)
        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = 8
        section.contentInsets = NSDirectionalEdgeInsets(top: 8, leading: 0, bottom: 8, trailing: 0)
        let layout = UICollectionViewCompositionalLayout(section: section)
        return layout
    }
}
