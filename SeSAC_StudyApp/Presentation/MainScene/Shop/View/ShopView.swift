//
//  ShopView.swift
//  SeSAC_StudyApp
//
//  Created by Seo Jae Hoon on 2022/12/05.
//

import UIKit

final class ShopView: BaseView {
    
    let bgImageView = UIImageView().then {
        $0.image = UIImage(named: "sesac_background_\(UserManager.sesacBackgroundImage)")
        $0.layer.cornerRadius = 8
        $0.layer.masksToBounds = true
        $0.contentMode = .scaleAspectFill
    }
    
    let sesacImageView = UIImageView().then {
        $0.image = UIImage(named: "sesac_face_\(UserManager.sesacImage)")
        $0.contentMode = .scaleAspectFill
    }
    
    let saveButton = NextButton(title: "저장하기", status: .fill)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    override func configure() {
        [bgImageView, sesacImageView, saveButton].forEach { self.addSubview($0) }
    }
    
    override func setConstraints() {
        bgImageView.snp.makeConstraints { make in
            make.top.equalTo(self.safeAreaLayoutGuide).offset(15)
            make.horizontalEdges.equalToSuperview().inset(16)
        }
        
        sesacImageView.snp.makeConstraints { make in
            make.top.equalTo(bgImageView.snp.top).offset(20)
            make.centerX.equalTo(bgImageView)
            make.height.equalTo(bgImageView.snp.height).multipliedBy(0.98)
            make.width.equalTo(sesacImageView.snp.height)
        }
        
        saveButton.snp.makeConstraints { make in
            make.width.equalTo(80)
            make.height.equalTo(40)
            make.top.trailing.equalTo(bgImageView).inset(12)
        }
    }
}
