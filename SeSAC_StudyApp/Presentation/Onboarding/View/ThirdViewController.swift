//
//  ThirdViewController.swift
//  SeSAC_StudyApp
//
//  Created by Seo Jae Hoon on 2022/11/08.
//

import UIKit

final class ThirdViewController: BaseViewController {
    
    private let mainView = PageView()
    
    override func loadView() {
        self.view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func configure() {
        mainView.onboardingImage.image = UIImage(named: "onboarding_img3")
        mainView.onboardingLabel.text = "SeSAC Study"
    }
    
    override func setConstraint() {
        mainView.onboardingLabel.snp.updateConstraints { make in
            make.top.equalTo(90)
        }
        mainView.onboardingImage.snp.updateConstraints { make in
            make.top.equalTo(mainView.onboardingLabel.snp.bottom).offset(74)
        }
    }
    
    
}
