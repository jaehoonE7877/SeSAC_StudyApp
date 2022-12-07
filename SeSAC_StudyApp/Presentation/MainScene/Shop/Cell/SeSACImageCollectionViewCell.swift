//
//  SeSACImageCollectionViewCell.swift
//  SeSAC_StudyApp
//
//  Created by Seo Jae Hoon on 2022/12/05.
//

import UIKit

import SnapKit
import Then

import RxCocoa
import RxSwift

final class SeSACImageCollectionViewCell: UICollectionViewCell {
    
    var cellDisposeBag = DisposeBag()
    
    let sesacImageView = UIImageView().then {
        $0.layer.borderColor = UIColor.gray2.cgColor
        $0.layer.masksToBounds = true
        $0.layer.cornerRadius = 8
        $0.layer.borderWidth = 1
        $0.contentMode = .scaleAspectFit
    }
    
    let titleLabel = UILabel().then {
        $0.textColor = .textColor
        $0.font = .notoSans(size: 16, family: .Regular)
    }
    
    let buyButton = BuyButton(status: .bought())
    
    let subLabel = UILabel().then {
        $0.lineBreakMode = .byCharWrapping
        $0.numberOfLines = 3
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
        [sesacImageView, titleLabel, buyButton, subLabel].forEach { contentView.addSubview($0) }
        
        sesacImageView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.horizontalEdges.equalToSuperview()
            make.height.equalTo(sesacImageView.snp.width)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(sesacImageView.snp.bottom).offset(8)
            make.height.equalTo(26)
            make.leading.equalToSuperview()
        }
        
        buyButton.snp.makeConstraints { make in
            make.centerY.equalTo(titleLabel.snp.centerY)
            make.width.equalTo(52)
            make.height.equalTo(20)
            make.trailing.equalToSuperview().inset(10)
        }
        
        subLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(8)
            make.horizontalEdges.equalToSuperview()
            make.bottom.equalToSuperview()
            make.height.equalTo(72)
        }
    }
    
    func setData(collection: [Int], indexPath: IndexPath, sesacImage: [SeSACImageModel]){
        sesacImageView.image = UIImage(named: "sesac_face_\(indexPath.item)")
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
