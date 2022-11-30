//
//  ChatCell.swift
//  SeSAC_StudyApp
//
//  Created by Seo Jae Hoon on 2022/11/27.
//

import UIKit

import SnapKit
import Then

final class MyChatCell: UITableViewCell {
    
    let chatLabel = Chatlabel(style: .my)
    
    let timeLabel = UILabel().then {
        $0.font = .notoSans(size: 12, family: .Regular)
        $0.textColor = . gray6
    }
    
    lazy var chatStackView = UIStackView(arrangedSubviews: [chatLabel, timeLabel]).then {
        $0.alignment = .bottom
        $0.axis = .horizontal
        $0.distribution = .fillProportionally
        $0.spacing = 8
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
            make.trailing.equalToSuperview()
            make.width.lessThanOrEqualTo(254)
        }
        
        timeLabel.snp.makeConstraints { make in
            make.bottom.equalTo(chatLabel.snp.bottom)
            make.trailing.equalTo(chatLabel.snp.leading).offset(-8)
        }
    }
    
    func setData(data: ChatData){
        let calendar = Calendar.current
        chatLabel.text = data.chat
        guard let date = data.createdAt.fetchDate() else { return }
        if calendar.isDateInToday(date) {
            timeLabel.text = date.aHHmm
        } else {
            timeLabel.text = date.MMddaHHmm
        }
        
    }
}
