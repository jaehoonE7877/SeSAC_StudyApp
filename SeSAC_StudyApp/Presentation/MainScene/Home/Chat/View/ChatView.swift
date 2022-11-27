//
//  ChatView.swift
//  SeSAC_StudyApp
//
//  Created by Seo Jae Hoon on 2022/11/27.
//

import UIKit

final class ChatView: BaseView {
    
    lazy var tableView = UITableView(frame: .zero, style: .plain).then {
        $0.showsVerticalScrollIndicator = false
        $0.backgroundColor = .systemBackground
        $0.register(ChatDateCell.self, forHeaderFooterViewReuseIdentifier: ChatDateCell.reuseIdentifier)
        $0.register(FirstMatchedCell.self, forHeaderFooterViewReuseIdentifier: FirstMatchedCell.reuseIdentifier)
        $0.register(MyChatCell.self, forHeaderFooterViewReuseIdentifier: MyChatCell.reuseIdentifier)
        $0.register(YourChatCell.self, forHeaderFooterViewReuseIdentifier: YourChatCell.reuseIdentifier)
        $0.separatorStyle = .none
    }
        
    let textView = UITextView().then {
        $0.sizeToFit()
        $0.isScrollEnabled = false
        $0.backgroundColor = .gray1
        $0.layer.cornerRadius = 8
        $0.contentInset = .init(top: 14, left: 12, bottom: 14, right: 44)
        $0.textColor = .gray7
        $0.text = "메세지를 입력하세요"
        $0.font = .notoSans(size: 14, family: .Regular)
    }
    
    let sendButton = UIButton().then {
        $0.contentMode = .scaleAspectFill
        $0.setImage(UIImage(named: "willsend"), for: .normal)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    override func configure() {
        [tableView,textView, sendButton].forEach { self.addSubview($0)}
    }
    
    override func setConstraints() {
        tableView.snp.makeConstraints { make in
            make.verticalEdges.equalToSuperview()
            make.horizontalEdges.equalToSuperview().inset(16)
        }
        
        textView.snp.makeConstraints { make in
            make.bottom.equalToSuperview().offset(-50)
            make.horizontalEdges.equalToSuperview().inset(16)
        }
        
        sendButton.snp.makeConstraints { make in
            make.centerY.equalTo(textView.snp.centerY)
            make.size.equalTo(24)
            make.trailing.equalTo(sendButton.snp.trailing).inset(12)
        }
    }
    
}
