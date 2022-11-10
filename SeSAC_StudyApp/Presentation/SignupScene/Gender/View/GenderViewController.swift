//
//  GenderViewController.swift
//  SeSAC_StudyApp
//
//  Created by Seo Jae Hoon on 2022/11/10.
//

import UIKit

import RxCocoa
import RxSwift

final class GenderViewController: BaseViewController {
    
    private let mainView = GenderView()
    
    private let disposeBag = DisposeBag()
    private let viewModel = GenderViewModel()
    
    private var selectedIndex: IndexPath?
    
    override func loadView() {
        self.view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mainView.collectionView.collectionViewLayout = configureCellLayout()
        mainView.collectionView.register(GenderCollectionViewCell.self, forCellWithReuseIdentifier: GenderCollectionViewCell.identifier)
        mainView.collectionView.delegate = self
        mainView.collectionView.dataSource = self
    }
    
    override func setBinding() {
        
        let input = GenderViewModel.Input(nextButtonTap: mainView.mainButton.rx.tap)
        let output = viewModel.transform(input: input)
        
        output.nextButtonTap
            .withUnretained(self)
            .bind { weakSelf, _ in
                if weakSelf.selectedIndex?.item == 0 {// 남자선택
                    UserManager.gender = 1
                    
                } else {
                    UserManager.gender = 0
                    
                }
            }
            .disposed(by: disposeBag)
        

    }
}

//MARK: Compositional Layout
extension GenderViewController {
    
    private func configureCellLayout() -> UICollectionViewLayout {

        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                              heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 4, bottom: 0, trailing: 4)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                               heightDimension: .fractionalHeight(1.0))
        
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 2)
        
        let section = NSCollectionLayoutSection(group: group)
        
        let layout = UICollectionViewCompositionalLayout(section: section)
        
        return layout
    }
}

extension GenderViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: GenderCollectionViewCell.identifier, for: indexPath) as? GenderCollectionViewCell
        else { return UICollectionViewCell() }
        
        cell.setData(data: indexPath.item)
        cell.backgroundColor = selectedIndex == indexPath ? .ssWhiteGreen : .clear
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        selectedIndex = indexPath
        mainView.mainButton.isEnabled = true
        mainView.mainButton.status = .fill
        collectionView.reloadData()
    }
    

}
