//
//  GenderCollectionViewCell.swift
//  SeSAC_StudyApp
//
//  Created by Seo Jae Hoon on 2022/11/10.
//

import UIKit

import SnapKit
import Then

final class GenderCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "gender"
    
    lazy var imageView = UIImageView().then {
        $0.contentMode = .scaleToFill
    }
    
    lazy var titleLabel = UILabel().then {
        $0.font = UIFont.notoSans(size: 16, family: .Regular)
        $0.textColor = .textColor
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.layer.cornerRadius = 8
        contentView.layer.borderWidth = 1
        contentView.layer.borderColor = UIColor.gray3.cgColor
        configureUI()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    private func configureUI() {
        [imageView, titleLabel].forEach{ contentView.addSubview($0)}
        
        imageView.snp.makeConstraints { make in
            make.centerX.equalTo(contentView)
            make.centerY.equalTo(contentView).multipliedBy(0.76)
            make.height.equalTo(contentView).multipliedBy(0.5)
            make.width.equalTo(imageView.snp.height)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.centerX.equalTo(contentView)
            make.top.equalTo(imageView.snp.bottom).offset(4)
        }
    }
    
    func setData(data: Int) {
        if data == 0 {
            self.imageView.image = UIImage(named: "man")!
            self.titleLabel.text = "남자"
        } else {
            self.imageView.image = UIImage(named: "woman")!
            self.titleLabel.text = "여자"
        }
    }
}
