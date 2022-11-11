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
    
    override func setBinding() {
        
        let input = BirthViewModel.Input(datePickerTap: mainView.datePicker.rx.controlEvent(.valueChanged),
                                         nextButtonTapped: mainView.mainButton.rx.tap)
        let output = viewModel.transform(input: input)
        
        output.datePickerTap
            .drive { [weak self] _ in
                guard let self = self else { return }
                self.mainView.mainButton.status = .fill
                self.mainView.yearView.dateTextField.text = "\(self.mainView.datePicker.date.year)"
                self.mainView.monthView.dateTextField.text = "\(self.mainView.datePicker.date.month)"
                self.mainView.dayView.dateTextField.text = "\(self.mainView.datePicker.date.day)"
            }
            .disposed(by: disposeBag)
        
        
        
        output.nextButtonTapped
            .withUnretained(self)
            .bind { weakSelf, _ in
                if weakSelf.viewModel.ageValidation(age: weakSelf.mainView.datePicker.date) {
                    UserManager.birth = weakSelf.mainView.datePicker.date.yyyyMMddTHHmmssSSZ
                    weakSelf.transitionViewController(viewController: EmailViewController(), transitionStyle: .push)
                } else {
                    weakSelf.mainView.makeToast(SignupMessage.ageTooYoung, duration: 1, position: .center)
                }
            }
            .disposed(by: disposeBag)
        
    }
    
}
