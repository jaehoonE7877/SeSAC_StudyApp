//
//  StudyInputTableViewCell.swift
//  SeSAC_StudyApp
//
//  Created by Seo Jae Hoon on 2022/11/15.
//

import UIKit

final class StudyInputView: BaseView {
    
    //MARK: Porperty
    lazy var studyLabel = UILabel().then {
        $0.text = "자주 하는 스터디"
        $0.font = UIFont.notoSans(size: 14, family: .Regular)
        $0.textColor = .textColor
    }
    
    lazy var studyTextField = UITextField().then {
        $0.setPlaceholder(text: "스터디를 입력해 주세요", color: .gray7)
        $0.addLeftPadding()
    }
    
    lazy var lineView = UIView().then {
        $0.backgroundColor = .gray3
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    override func configure() {
        [studyLabel, studyTextField, lineView].forEach { self.addSubview($0) }
    }
    
    override func setConstraints() {
        studyLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.centerY.equalToSuperview()
        }
        
        studyTextField.snp.makeConstraints { make in
            make.centerY.equalTo(studyLabel.snp.centerY)
            make.trailing.equalToSuperview()
            make.height.equalTo(40)
            make.width.equalTo(164)
        }
        
        lineView.snp.makeConstraints { make in
            make.top.equalTo(studyTextField.snp.bottom)
            make.width.equalTo(studyTextField)
            make.centerX.equalTo(studyTextField.snp.centerX)
            make.height.equalTo(1)
        }
    }
}
