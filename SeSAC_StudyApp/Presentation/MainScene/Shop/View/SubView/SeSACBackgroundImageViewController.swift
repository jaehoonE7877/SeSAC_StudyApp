//
//  SeSACBackgroundImageViewController.swift
//  SeSAC_StudyApp
//
//  Created by Seo Jae Hoon on 2022/12/05.
//

import UIKit
import RxSwift
import RxCocoa

final class SeSACBackgroundImageViewController: BaseViewController {
    
    var backgroundArray: [Int]?
    
    lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: self.configureCellLayout()).then {
        $0.dataSource = self
        $0.delegate = self
        $0.showsVerticalScrollIndicator = false
        $0.backgroundColor = .systemBackground
        $0.register(SeSACBackgroundImageCollectionViewCell.self, forCellWithReuseIdentifier: SeSACBackgroundImageCollectionViewCell.reuseIdentifier)
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

extension SeSACBackgroundImageViewController {
    
    private func configureCellLayout() -> UICollectionViewLayout {
        
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(0.6))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(0.52))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        group.contentInsets = NSDirectionalEdgeInsets(top: 16, leading: 16, bottom: 0, trailing: 16)
        let section = NSCollectionLayoutSection(group: group)
        
        let layout = UICollectionViewCompositionalLayout(section: section)
        
        return layout
    }
    
}

extension SeSACBackgroundImageViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return SeSACImageDescription.background.description.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SeSACBackgroundImageCollectionViewCell.reuseIdentifier, for: indexPath) as? SeSACBackgroundImageCollectionViewCell else { return UICollectionViewCell()}
        
        cell.setData(indexPath: indexPath)

        return cell
    }
    
}
