//
//  SearchCollectionViewCell.swift
//  SeSAC_StudyApp
//
//  Created by Seo Jae Hoon on 2022/11/21.
//

import UIKit

import SnapKit

final class SearchCollectionViewCell: UICollectionViewCell {
    
    //MARK: Property
    lazy var searchButton = SearchButton(title: "sda", status: .redOutline)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    private func configure(){
        contentView.addSubview(searchButton)
        searchButton.snp.makeConstraints { make in
            make.edges.equalTo(contentView)
        }
    }
}
