//
//  SeSACBackgroundImageTableViewCell.swift
//  SeSAC_StudyApp
//
//  Created by Seo Jae Hoon on 2022/12/05.
//
import UIKit

import SnapKit
import Then

import RxCocoa
import RxSwift

final class SeSACBackgroundImageCollectionViewCell: UICollectionViewCell {
    
    var cellDisposeBag = DisposeBag()
    
    let backgroundImageView = UIImageView().then {
        $0.layer.borderColor = UIColor.gray2.cgColor
        $0.layer.masksToBounds = true
        $0.layer.cornerRadius = 8
        $0.layer.borderWidth = 1
        $0.contentMode = .scaleAspectFill
    }
    
    let titleLabel = UILabel().then {
        $0.textColor = .textColor
        $0.font = .notoSans(size: 16, family: .Regular)
    }
    
    let buyButton = BuyButton(status: .bought())
    
    let subLabel = UILabel().then {
        $0.lineBreakMode = .byCharWrapping
        $0.numberOfLines = 2
        $0.textColor = .textColor
        $0.font = .notoSans(size: 14, family: .Regular)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        cellDisposeBag = DisposeBag()
    }
    
    private func configureUI() {
        [backgroundImageView, titleLabel, buyButton, subLabel].forEach { contentView.addSubview($0) }
        
        backgroundImageView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.5)
            make.height.equalTo(backgroundImageView.snp.width)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.leading.equalTo(backgroundImageView.snp.trailing).offset(12)
            make.centerY.equalTo(backgroundImageView.snp.centerY).multipliedBy(0.8)
        }
        
        buyButton.snp.makeConstraints { make in
            make.centerY.equalTo(titleLabel.snp.centerY)
            make.width.equalTo(52)
            make.height.equalTo(20)
            make.trailing.equalToSuperview()
        }
        
        subLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(8)
            make.leading.equalTo(titleLabel.snp.leading)
            make.trailing.equalToSuperview()
            make.height.equalTo(48)
        }

    }
    
    func setData(collection: [Int], indexPath: IndexPath, sesacImage: [SeSACImageModel]){
        backgroundImageView.image = UIImage(named: "sesac_background_\(indexPath.item)")
        titleLabel.text = sesacImage[indexPath.item].title
        subLabel.text = sesacImage[indexPath.item].description
        for item in collection {
            if item == indexPath.item {
                buyButton.status = .bought()
            } else {
                buyButton.status = .cost(cost: sesacImage[indexPath.item].price)
            }
        }
    }
}
