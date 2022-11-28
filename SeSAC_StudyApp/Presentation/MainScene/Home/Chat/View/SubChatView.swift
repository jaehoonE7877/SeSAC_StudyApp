//
//  SubChatView.swift
//  SeSAC_StudyApp
//
//  Created by Seo Jae Hoon on 2022/11/28.
//

import UIKit

final class SubChatView: BaseView {
    
    let backgroundView = UIView().then {
        $0.backgroundColor = .textColor
    }
    
    let reportButton = ChatItemButton(item: .report)
    
    let cancelMatchButton = ChatItemButton(item: .cancelMatch)
    
    let reviewButton = ChatItemButton(item: .review)
    
    lazy var subStackView = UIStackView(arrangedSubviews: [reportButton, cancelMatchButton, reviewButton]).then {
        $0.alignment = .fill
        $0.distribution = .fillEqually
        $0.axis = .horizontal
        $0.backgroundColor = .white
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    override func configure() {
        self.addSubview(backgroundView)
        backgroundView.addSubview(subStackView)
    }
    
    override func setConstraints() {
        backgroundView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        subStackView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.horizontalEdges.equalToSuperview()
            make.height.equalTo(72)
        }
    }
}
