//
//  SecondViewController.swift
//  SeSAC_StudyApp
//
//  Created by Seo Jae Hoon on 2022/11/08.
//

import UIKit

final class SecondViewController: BaseViewController {
    
    private let mainView = PageView()
    
    override func loadView() {
        self.view = mainView
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func configure() {
        mainView.onboardingImage.image = UIImage(named: "onboarding_img2")
        mainView.onboardingLabel.text =
            """
            스터디를 원하는 친구를
            찾을 수 있어요
            """
        mainView.onboardingLabel.asColor(targetString: "스터디를 원하는 친구", color: .ssGreen)
    }
    
}
