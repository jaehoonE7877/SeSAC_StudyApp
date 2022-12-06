//
//  SeSACImageViewController.swift
//  SeSAC_StudyApp
//
//  Created by Seo Jae Hoon on 2022/12/05.
//

import UIKit
import RxSwift
import RxCocoa

final class SeSACImageViewController: BaseViewController {
    
    var sesacArray: [Int]?
    
    lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: self.configureCellLayout()).then {
        $0.dataSource = self
        $0.delegate = self
        $0.showsVerticalScrollIndicator = false
        $0.backgroundColor = .systemBackground
        $0.register(SeSACImageCollectionViewCell.self, forCellWithReuseIdentifier: SeSACImageCollectionViewCell.reuseIdentifier)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func configure() {
        view.addSubview(collectionView)
        
        collectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        collectionView.collectionViewLayout = self.configureCellLayout()
    }

}

extension SeSACImageViewController {
    
    private func configureCellLayout() -> UICollectionViewLayout {
        
        let itemWidthFraction = 1.0 / 2.0
        
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(itemWidthFraction), heightDimension: .fractionalHeight(0.92))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets(top: 6, leading: 6, bottom: 6, trailing: 6)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(0.8))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        group.contentInsets = NSDirectionalEdgeInsets(top: 8, leading: 10, bottom: 0, trailing: 10)
        let section = NSCollectionLayoutSection(group: group)
        
        let layout = UICollectionViewCompositionalLayout(section: section)
        
        return layout
    }
    
}

extension SeSACImageViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return SeSACImageDescription.sesac.name.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SeSACImageCollectionViewCell.reuseIdentifier, for: indexPath) as? SeSACImageCollectionViewCell else { return UICollectionViewCell()}
        guard let sesacCollection = sesacArray else { return UICollectionViewCell() }
        cell.setData(collection: sesacCollection, indexPath: indexPath)

        return cell
    }

}
