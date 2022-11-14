//
//  InfoTableViewCell.swift
//  SeSAC_StudyApp
//
//  Created by Seo Jae Hoon on 2022/11/13.
//

import UIKit
import SnapKit
import Then

final class InfoTableViewCell: UITableViewCell {
    
    //MARK: Porperty
    lazy var mainImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFill
    }
    
    lazy var mainLabel = UILabel().then {
        $0.textColor = .textColor
        $0.font = UIFont.notoSans(size: 16, family: .Regular)
    }
    
    lazy var detailImage = UIImageView().then {
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
        [mainImageView, mainLabel, detailImage].forEach { contentView.addSubview($0) }
    }
    
    private func setConstraint(){
        mainImageView.snp.makeConstraints { make in
            make.leading.equalTo(contentView).offset(16)
            make.centerY.equalTo(contentView)
            make.size.equalTo(24)
        }
        
        mainLabel.snp.makeConstraints { make in
            make.leading.equalTo(mainImageView.snp.trailing).offset(12)
            make.centerY.equalTo(mainImageView)
        }
        
        detailImage.snp.makeConstraints { make in
            make.trailing.equalTo(contentView).offset(-16)
            make.centerY.equalTo(mainLabel)
            make.size.equalTo(24)
        }
    }
}
