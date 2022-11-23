//
//  ProfileImageView.swift
//  SeSAC_StudyApp
//
//  Created by Seo Jae Hoon on 2022/11/16.
//

import UIKit

final class ProfileImageHeaderView: UITableViewHeaderFooterView {
    
    lazy var bgImageView = UIImageView().then {
        $0.isHidden = false
        $0.layer.cornerRadius = 8
        $0.layer.masksToBounds = true
        $0.contentMode = .scaleAspectFill
    }
    
    lazy var sesacImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFill
    }
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        configure()
        setConstraints()
    }
    
    //@available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        [bgImageView, sesacImageView].forEach { self.addSubview($0)}
    }
    
    private func setConstraints() {
        bgImageView.snp.makeConstraints { make in
            make.top.equalTo(self)
            make.horizontalEdges.bottom.equalToSuperview()
        }
        
        sesacImageView.snp.makeConstraints { make in
            make.top.equalTo(bgImageView.snp.top).offset(20)
            make.centerX.equalTo(bgImageView)
            make.height.equalTo(bgImageView.snp.height).multipliedBy(0.98)
            make.width.equalTo(sesacImageView.snp.height)
        }
    }
    
    func setData(item: SeSACInfo) {
        bgImageView.image = UIImage(named: "sesac_background_\(item.background)")
        sesacImageView.image = UIImage(named: "sesac_face_\(item.sesac)")
    }
    
    func setHeaderData(item: SeSACCardModel){
        bgImageView.image = UIImage(named: "sesac_background_\(item.background)")
        sesacImageView.image = UIImage(named: "sesac_face_\(item.sesac)")
    }
}
