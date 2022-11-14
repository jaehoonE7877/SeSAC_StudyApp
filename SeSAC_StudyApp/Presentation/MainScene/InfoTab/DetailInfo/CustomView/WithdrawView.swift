//
//  WithdrawTableViewCell.swift
//  SeSAC_StudyApp
//
//  Created by Seo Jae Hoon on 2022/11/15.
//

import UIKit

final class WithdrawView: BaseView {
    
    //MARK: Porperty
    lazy var withdrawButton = UIButton().then {
        $0.titleLabel?.font = UIFont.notoSans(size: 14, family: .Regular)
        $0.setTitleColor(.textColor, for: .normal)
        $0.setTitle("회원 탈퇴", for: .normal)
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    override func configure() {
        self.addSubview(withdrawButton)
    }
    
    override func setConstraints() {
        withdrawButton.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.centerY.equalToSuperview()
            make.width.equalTo(60)
            make.height.equalTo(44)
        }
    }
}
