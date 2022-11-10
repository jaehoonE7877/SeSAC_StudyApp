//
//  GenderView.swift
//  SeSAC_StudyApp
//
//  Created by Seo Jae Hoon on 2022/11/10.
//

import UIKit

final class GenderView: LoginView {
    
    //MARK: Property
    lazy var subLabel = UILabel().then {
        $0.text = "새싹 찾기 기능을 이용하기 위해서 필요해요!"
        $0.textColor = .gray7
        $0.textAlignment = .center
        $0.font = UIFont.notoSans(size: 16, family: .Regular)
    }
    
    lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewLayout.init()).then {
        $0.backgroundColor = .clear
        $0.contentInset = .zero
        $0.showsHorizontalScrollIndicator = false
        $0.isScrollEnabled = false
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    
    lazy var verticalStackView = UIStackView(arrangedSubviews: [mainLabel, subLabel]).then {
        $0.distribution = .fillProportionally
        $0.axis = .vertical
        $0.spacing = 8
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    override func configure() {
        super.configure()
        mainButton.setTitle("다음", for: .normal)
        mainLabel.text = "성별을 선택해 주세요"
        mainButton.isEnabled = false
        [verticalStackView, collectionView].forEach { self.addSubview($0)}
    }
    
    override func setConstraints() {
        super.setConstraints()
        
        verticalStackView.snp.makeConstraints { make in
            make.centerY.equalTo(self.safeAreaLayoutGuide).multipliedBy(0.48)
            make.centerX.equalToSuperview()
        }
        
        collectionView.snp.makeConstraints { make in
            make.width.equalTo(mainButton)
            make.centerX.equalToSuperview()
            make.centerY.equalTo(self.safeAreaLayoutGuide).multipliedBy(0.8)
            make.height.equalTo(collectionView.snp.width).multipliedBy(0.35)
        }
    }
}
