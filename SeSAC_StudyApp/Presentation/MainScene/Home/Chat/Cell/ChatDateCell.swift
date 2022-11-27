//
//  ChatDateCell.swift
//  SeSAC_StudyApp
//
//  Created by Seo Jae Hoon on 2022/11/27.
//

import UIKit

final class ChatDateCell: UITableViewCell {
    
    let dateLabel = UILabel().then {
        $0.layer.cornerRadius = 20
        $0.textColor = .white
        $0.font = UIFont.notoSans(size: 12, family: .Medium)
        $0.textAlignment = .center
        $0.backgroundColor = .gray7
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    private func setUI() {
        contentView.addSubview(dateLabel)
        
        dateLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(16)
            make.center.equalToSuperview()
        }
    }
    
}
