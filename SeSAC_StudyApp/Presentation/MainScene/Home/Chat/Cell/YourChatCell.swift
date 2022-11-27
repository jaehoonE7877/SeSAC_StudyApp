//
//  YourChatCell.swift
//  SeSAC_StudyApp
//
//  Created by Seo Jae Hoon on 2022/11/27.
//

import UIKit

import SnapKit
import Then

final class YourChatCell: UITableViewCell {
    
    let chatLabel = Chatlabel(style: .your)
    
    let timeLabel = UILabel().then {
        $0.font = .notoSans(size: 12, family: .Regular)
        $0.textColor = . gray6
    }
    
    lazy var chatStackView = UIStackView(arrangedSubviews: [timeLabel, chatLabel]).then {
        $0.alignment = .bottom
        $0.axis = .horizontal
        $0.distribution = .fillProportionally
        $0.spacing = 8
        
    }
        
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    private func setUI() {
        contentView.addSubview(chatStackView)
        
        chatStackView.snp.makeConstraints { make in
            make.trailing.equalToSuperview()
            make.verticalEdges.equalToSuperview().inset(12)
        }
    }
}
