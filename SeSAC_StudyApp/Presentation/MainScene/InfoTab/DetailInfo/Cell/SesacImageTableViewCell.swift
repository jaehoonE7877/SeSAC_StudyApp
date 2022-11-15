//
//  InfoImageCell.swift
//  SeSAC_StudyApp
//
//  Created by Seo Jae Hoon on 2022/11/14.
//
import UIKit

import SnapKit
import Then

final class SesacImageTableViewCell: UITableViewCell {
    
    //MARK: Property
    lazy var bgImageView = UIImageView().then {
        $0.layer.cornerRadius = 8
        $0.layer.masksToBounds = true
        $0.image = UIImage(named: "sesac_bg_01")
        $0.contentMode = .scaleAspectFill
    }
    
    lazy var sesacImageView = UIImageView().then {
        $0.image = UIImage(named: "sesac_face_2")
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
        [bgImageView, sesacImageView].forEach { contentView.addSubview($0) }
    }
    
    private func setConstraint(){
        bgImageView.snp.makeConstraints { make in
            make.top.equalTo(contentView).offset(16)
            make.horizontalEdges.bottom.equalToSuperview()
        }
        
        sesacImageView.snp.makeConstraints { make in
            make.top.equalTo(bgImageView.snp.top).offset(20)
            make.centerX.equalTo(bgImageView)
            make.height.equalTo(bgImageView.snp.height).multipliedBy(0.98)
            make.width.equalTo(sesacImageView.snp.height)
        }
    }
}
