//
//  ChatItemButton.swift
//  SeSAC_StudyApp
//
//  Created by Seo Jae Hoon on 2022/11/28.
//

import UIKit

enum ChatItem {
    case report
    case cancelMatch
    case review
}

extension ChatItem {
    var image: UIImage {
        switch self {
        case .report:
            return UIImage(named: "siren")!
        case .cancelMatch:
            return UIImage(named: "cancel_match")!
        case .review:
            return UIImage(named: "review_write")!
        }
    }
    
    var text: String {
        switch self {
        case .report:
            return "새싹 신고"
        case .cancelMatch:
            return "스터디 취소"
        case .review:
            return "리뷰 등록"
        }
    }
}

final class ChatItemButton: UIButton {
    
    let mainImageView = UIImageView().then {
        $0.tintColor = .textColor
        $0.contentMode = .scaleAspectFill
    }
    
    let itemLabel = UILabel().then {
        $0.font = .notoSans(size: 14, family: .Medium)
        $0.textColor = .textColor
    }
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    convenience init(item: ChatItem) {
        self.init()
        mainImageView.image = item.image
        itemLabel.text = item.text
    }
    
    private func configure() {
        [mainImageView, itemLabel].forEach { self.addSubview($0)}
    }
    
    private func setConstraints() {
        mainImageView.snp.makeConstraints { make in
            make.size.equalTo(24)
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(11)
        }
        
        itemLabel.snp.makeConstraints { make in
            make.top.equalTo(mainImageView.snp.bottom).offset(4)
            make.centerX.equalToSuperview()
        }
    }
    
    
    
}
