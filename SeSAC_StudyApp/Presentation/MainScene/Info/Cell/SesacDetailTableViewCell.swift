//
//  SesacDetailTableViewCell.swift
//  SeSAC_StudyApp
//
//  Created by Seo Jae Hoon on 2022/11/14.
//

import UIKit

final class SesacDetailTableViewCell: UITableViewCell {
    
    //MARK: Porperty
    lazy var nameLabel = UILabel().then {
        $0.font = UIFont.notoSans(size: 16, family: .Regular)
        $0.textColor = .textColor
    }
    
    lazy var chevornImageView = UIImageView().then {
        $0.image = UIImage(named: "more_arrow 1")
        $0.contentMode = .scaleAspectFill
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configure()
        setConstraint()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    private func configure() {
        contentView.layer.masksToBounds = false
        contentView.layer.cornerRadius = 8
        contentView.layer.borderColor = UIColor.gray2.cgColor
        [nameLabel, chevornImageView].forEach { contentView.addSubview($0) }
    }
    
    private func setConstraint() {
        nameLabel.snp.makeConstraints { make in
            make.leading.equalTo(contentView).offset(16)
            make.centerY.equalTo(contentView)
        }
        
        chevornImageView.snp.makeConstraints { make in
            make.centerY.equalTo(nameLabel.snp.centerY)
            make.trailing.equalTo(contentView).offset(-16)
            make.size.equalTo(16)
        }
    }
}
