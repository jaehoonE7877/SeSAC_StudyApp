//
//  OnboardingViewController.swift
//  SeSAC_StudyApp
//
//  Created by Seo Jae Hoon on 2022/11/07.
//

import UIKit

import RxSwift
import RxCocoa

final class OnboardingViewController: BaseViewController{
    
    private let disposeBag = DisposeBag()
    
    private let pageControl = UIPageControl().then {
        $0.pageIndicatorTintColor = .gray5
        $0.currentPageIndicatorTintColor = .textColor
    }
    
    private let nextButton = NextButton(title: "시작하기", status: .fill).then{
        $0.translatesAutoresizingMaskIntoConstraints = false
    }

    private lazy var pageViewController = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal).then {
        $0.delegate = self
        $0.dataSource = self
    }
    
    private var pageViewControllerList: [UIViewController] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        createPageViewController()
        configurePageViewController()
        
        pageControl.numberOfPages = pageViewControllerList.count
        
        nextButton.addTarget(self, action: #selector(continueButtonClicked), for: .touchUpInside)
        pageControlTapped()
    }
    
    private func pageControlTapped() {
        
        pageControl.rx.controlEvent(.valueChanged)
            .withUnretained(self)
            .bind { vc, _ in
                let currentPage = vc.pageControl.currentPage
                guard let firstView = vc.pageViewController.viewControllers?.first, let index = vc.pageViewControllerList.firstIndex(of: firstView) else { return }
                if currentPage > index {
                    vc.pageViewController.setViewControllers([self.pageViewControllerList[currentPage]], direction: .forward, animated: true)
                } else {
                    vc.pageViewController.setViewControllers([self.pageViewControllerList[currentPage]], direction: .reverse, animated: true)
                }
            }
            .disposed(by: disposeBag)
    }
    
    //배열에 뷰컨트롤러를 추가
    private func createPageViewController(){
        let vc1 = FirstViewController()
        let vc2 = SecondViewController()
        let vc3 = ThirdViewController()
        pageViewControllerList = [vc1, vc2, vc3]
    }
    
    private func configurePageViewController() {
        //display
        guard let first = pageViewControllerList.first else { return }
        pageViewController.setViewControllers([first], direction: .forward, animated: true)
    }
    
    @objc private func continueButtonClicked() {
        
        if pageControl.currentPage < pageViewControllerList.count - 1 {
            let nextPage = pageViewControllerList[pageControl.currentPage + 1]
            pageControl.currentPage += 1
            pageViewController.setViewControllers([nextPage], direction: .forward, animated: true)
        } else {
            
            UserDefaults.standard.set(true, forKey: "onboarding")
            
            transitionViewController(viewController: PhoneViewController(), transitionStyle: .presentFullNavigation)
        }
        
    }
    
    override func configure() {
        [pageViewController.view, pageControl, nextButton].forEach { view.addSubview($0) }
    }
    
    override func setConstraint() {
       
        pageViewController.view.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
            
        }
        pageControl.snp.makeConstraints { make in
            make.bottom.equalTo(nextButton.snp.top).offset(-42)
            make.centerX.equalTo(view)
        }
        
        //버튼 너비
        nextButton.snp.makeConstraints { make in
            make.bottom.equalTo(view.safeAreaLayoutGuide).offset(-16)
            make.centerX.equalToSuperview()
            make.width.equalTo(view.safeAreaLayoutGuide).multipliedBy(0.92)
            make.height.equalTo(48)
        }
    }
}

extension OnboardingViewController: UIPageViewControllerDelegate, UIPageViewControllerDataSource {
       
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        
        guard let viewControllerIndex = pageViewControllerList.firstIndex(of: viewController) else { return nil }
        
        let previousIndex = viewControllerIndex - 1
        
        return previousIndex < 0 ? nil : pageViewControllerList[previousIndex]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = pageViewControllerList.firstIndex(of: viewController) else { return nil }
        
        let nextIndex = viewControllerIndex + 1
        
        return nextIndex >= pageViewControllerList.count ? nil : pageViewControllerList[nextIndex]
    }
    
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        guard let firstView = pageViewController.viewControllers?.first, let index = pageViewControllerList.firstIndex(of: firstView) else { return }
        
        pageControl.currentPage = index
        
//        if pageControl.currentPage == 2 {
//            continueButton.setTitle("시작하기", for: .normal)
//        } else {
//            continueButton.setTitle("계속하기", for: .normal)
//        }
        
    }
}
