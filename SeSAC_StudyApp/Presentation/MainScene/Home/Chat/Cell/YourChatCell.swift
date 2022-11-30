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
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        setUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    private func setUI() {
        [chatLabel, timeLabel].forEach { contentView.addSubview($0)}
        
        chatLabel.snp.makeConstraints { make in
            make.verticalEdges.equalToSuperview().inset(12)
            make.leading.equalToSuperview()
        }
        
        timeLabel.snp.makeConstraints { make in
            make.bottom.equalTo(chatLabel.snp.bottom)
            make.leading.equalTo(chatLabel.snp.trailing).offset(8)
        }
    }
    
    func setData(data: ChatData){
        chatLabel.text = data.chat
        timeLabel.text = data.createdAt
    }
}
