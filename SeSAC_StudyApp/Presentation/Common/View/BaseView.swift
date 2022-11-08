//
//  BaseView.swift
//  SeSAC_StudyApp
//
//  Created by Seo Jae Hoon on 2022/11/07.
//

import UIKit

import SnapKit
import Then

class BaseView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .systemBackground
        configure()
        setConstraints()
    }
    
    @available(*,unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure() { }
    
    func setConstraints() { }
}

