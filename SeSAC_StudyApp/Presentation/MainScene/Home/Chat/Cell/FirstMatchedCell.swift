//
//  FirstMatchedCell.swift
//  SeSAC_StudyApp
//
//  Created by Seo Jae Hoon on 2022/11/27.
//

import UIKit

final class FirstMatchedCell: UITableViewCell {
    
    let mainLabel = UILabel().then {
        $0.textColor = .gray7
        $0.font = .notoSans(size: 14, family: .Medium)
        $0.text = "고래밥님과 매칭되었습니다"
    }
    
    let bellImage = UIImageView(frame: CGRect(x: 0, y: 0, width: 16, height: 16)).then {
        $0.contentMode = .scaleAspectFill
        $0.tintColor = .gray7
        $0.image = UIImage(named: "bell")
    }
    
    let subLabel = UILabel().then {
        $0.textColor = .gray6
        $0.font = .notoSans(size: 14, family: .Regular)
        $0.text = "채팅을 통해 약속을 정해보세요 :)"
    }
    
    lazy var horizontalStackView = UIStackView(arrangedSubviews: [bellImage, mainLabel]).then {
        $0.distribution = .fillProportionally
        $0.spacing = 4
        $0.axis = .horizontal
    }
    
    lazy var mainStackView = UIStackView(arrangedSubviews: [horizontalStackView, subLabel]).then {
        $0.distribution = .fillEqually
        $0.spacing = 2
        $0.axis = .vertical
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    private func setUI() {
        contentView.addSubview(mainStackView)
        
        mainStackView.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
    
}
