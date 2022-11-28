//
//  PopView.swift
//  SeSAC_StudyApp
//
//  Created by Seo Jae Hoon on 2022/11/28.
//

import UIKit

final class PopView: BaseView {
    
    private let backgroundView = UIView().then {
        $0.backgroundColor = .systemBackground
        $0.layer.cornerRadius = 16
    }
    
    private let titleLabel = UILabel().then {
        $0.textColor = .textColor
        $0.font = UIFont.notoSans(size: 16, family: .Medium)
        $0.textAlignment = .center
    }
    
    private let subTitleLabel = UILabel().then {
        $0.numberOfLines = 0
        $0.textColor = .gray7
        $0.font = UIFont.notoSans(size: 14, family: .Regular)
        $0.textAlignment = .center
    }
    
    let cancelButton = NextButton(title: "취소", status: .cancel)
    
    let matchButton = NextButton(title: "확인", status: .fill)
    
    lazy var labelStackView = UIStackView(arrangedSubviews: [titleLabel, subTitleLabel]).then {
        $0.alignment = .fill
        $0.distribution = .fillProportionally
        $0.axis = .vertical
        $0.spacing = 8
    }
    
    lazy var buttonStackView = UIStackView(arrangedSubviews: [cancelButton, matchButton]).then {
        $0.alignment = .fill
        $0.distribution = .fillEqually
        $0.axis = .horizontal
        $0.spacing = 8
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor(white: 0.2, alpha: 0.5)
    }
    
    convenience init(title: String, subtitle: String) {
        self.init()
        titleLabel.text = title
        subTitleLabel.text = subtitle
    }
    
    override func configure() {
        self.addSubview(backgroundView)
        [labelStackView, buttonStackView].forEach{ backgroundView.addSubview($0)}
    }
    
    override func setConstraints() {
        backgroundView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.horizontalEdges.equalToSuperview().inset(16)
            make.height.equalTo(156)
        }
        
        labelStackView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(backgroundView.snp.top).offset(16)
        }
        
        buttonStackView.snp.makeConstraints { make in
            make.top.equalTo(labelStackView.snp.bottom).offset(16)
            make.centerX.equalToSuperview()
            make.horizontalEdges.equalToSuperview().inset(16)
            make.height.equalTo(48)
        }
    }
    
}
