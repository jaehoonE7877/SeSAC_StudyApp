//
//  BirthViewController.swift
//  SeSAC_StudyApp
//
//  Created by Seo Jae Hoon on 2022/11/10.
//

import UIKit

import RxCocoa
import RxSwift

final class BirthViewController: BaseViewController {
    
    private let mainView = BirthView()
    
    private let disposeBag = DisposeBag()
    private let viewModel = BirthViewModel()
    
    override func loadView() {
        self.view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func setNavigationController() {
        let backButton = UIBarButtonItem(image: UIImage(named: "arrow"), style: .plain, target: self, action: #selector(backButtonTapped))
        backButton.tintColor = .textColor
        self.navigationItem.leftBarButtonItem = backButton
    }
    
    @objc private func backButtonTapped() {
        
    }
    
    override func setBinding() {
        
        let input = BirthViewModel.Input(datePickerTap: mainView.datePicker.rx.controlEvent(.valueChanged),
                                         nextButtonTapped: mainView.mainButton.rx.tap)
        let output = viewModel.transform(input: input)
        
        output.datePickerTap
            .drive { [weak self] _ in
                guard let self = self else { return }
                self.mainView.mainButton.status = .fill
                self.mainView.yearView.dateTextField.text = self.dateToString(date: self.mainView.datePicker.date, format: "yyyy")
                self.mainView.monthView.dateTextField.text = self.dateToString(date: self.mainView.datePicker.date, format: "MM")
                self.mainView.dayView.dateTextField.text = self.dateToString(date: self.mainView.datePicker.date, format: "dd")
            }
            .disposed(by: disposeBag)
        
        
        
        output.nextButtonTapped
            .withUnretained(self)
            .bind { weakSelf, _ in
                if weakSelf.viewModel.ageValidation(age: self.mainView.datePicker.date) {
                    print("다음화면")
                } else {
                    weakSelf.mainView.makeToast(SignupMessage.ageTooYoung, duration: 1, position: .center)
                }
            }
            .disposed(by: disposeBag)
        
    }
    
    
    func dateToString(date: Date, format: String) -> String {
        
        let formatter = DateFormatter()
        formatter.dateFormat = format
        formatter.locale = Locale(identifier: "ko_KR")
        
        return formatter.string(from: date)
    }
    
}
