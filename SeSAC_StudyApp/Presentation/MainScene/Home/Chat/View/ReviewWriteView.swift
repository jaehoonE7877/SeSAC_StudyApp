//
//  ReviewWriteView.swift
//  SeSAC_StudyApp
//
//  Created by Seo Jae Hoon on 2022/12/04.
//

import UIKit

import RxCocoa
import RxSwift

final class ReviewWriteView: BaseView {
    
    private let disposeBag = DisposeBag()
    
    private let backgroundView = UIView().then {
        $0.backgroundColor = .systemBackground
        $0.layer.cornerRadius = 20
    }
    
    private let titleLabel = UILabel().then {
        $0.text = "리뷰 등록"
        $0.textColor = .textColor
        $0.font = UIFont.notoSans(size: 14, family: .Medium)
        $0.textAlignment = .center
    }
    
    let cancelButton = UIButton().then {
        $0.tintColor = .gray6
        $0.setImage(UIImage(systemName: "xmark"), for: .normal)
    }

    let subTitleLabel = UILabel().then {
        $0.textColor = .ssGreen
        $0.font = UIFont.notoSans(size: 14, family: .Regular)
        $0.textAlignment = .center
    }
    
    lazy var reviewView = SesacTitleView().then {
        $0.titleLabel.isHidden = true
        $0.horizontalStackView.snp.remakeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    let textView = UITextView().then {
        $0.textColor = .gray7
        $0.backgroundColor = .gray1
        $0.layer.masksToBounds = true
        $0.layer.cornerRadius = 8
        $0.font = .notoSans(size: 14, family: .Regular)
        $0.text = "자세한 피드백은 다른 새싹들에게 도움이 됩니다\n (500자 이내 작성)"
    }
    
    let writeButton = NextButton(title: "리뷰 등록하기", status: .disable)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor(white: 0.2, alpha: 0.5)
        setBinding()
    }
    
    override func configure() {
        self.addSubview(backgroundView)
        [titleLabel, cancelButton, subTitleLabel, reviewView, textView, writeButton].forEach{ backgroundView.addSubview($0)}
    }
    
    override func setConstraints() {
        
        backgroundView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.horizontalEdges.equalToSuperview().inset(16)
            make.height.equalTo(450)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(17)
            make.centerX.equalToSuperview()
        }
        
        cancelButton.snp.makeConstraints { make in
            make.size.equalTo(24)
            make.trailing.equalToSuperview().inset(16)
            make.centerY.equalTo(titleLabel.snp.centerY)
        }
        
        subTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(17)
            make.centerX.equalToSuperview()
        }
        
        reviewView.snp.makeConstraints { make in
            make.top.equalTo(subTitleLabel.snp.bottom).offset(24)
            make.horizontalEdges.equalToSuperview().inset(16)
            make.height.equalTo(112)
        }
        
        textView.snp.makeConstraints { make in
            make.top.equalTo(reviewView.snp.bottom).offset(24)
            make.horizontalEdges.equalToSuperview().inset(16)
            make.height.equalTo(124)
        }
        
        writeButton.snp.makeConstraints { make in
            make.top.equalTo(textView.snp.bottom).offset(24)
            make.horizontalEdges.equalToSuperview().inset(16)
            make.height.equalTo(48)
        }
    }
    
    private func setBinding() {
        
        textView.rx.didBeginEditing
            .withUnretained(self)
            .bind { weakSelf, _ in
                if weakSelf.textView.text == "자세한 피드백은 다른 새싹들에게 도움이 됩니다\n (500자 이내 작성)" {
                    weakSelf.textView.text = nil
                    weakSelf.writeButton.status = .fill
                }
                weakSelf.textView.textColor = .textColor
            }
            .disposed(by: disposeBag)
        
        textView.rx.didEndEditing
            .withUnretained(self)
            .bind { weakSelf, _ in
                if weakSelf.textView.text.count == 0 {
                    weakSelf.textView.text = "자세한 피드백은 다른 새싹들에게 도움이 됩니다\n (500자 이내 작성)"
                    weakSelf.textView.textColor = .gray7
                    weakSelf.writeButton.status = .disable
                }
            }
            .disposed(by: disposeBag)
        
        textView.rx.text.orEmpty
            .map { $0.count <= 500}
            .observe(on: MainScheduler.instance)
            .withUnretained(self)
            .bind { weakSelf, isEditable in
                if !isEditable {
                    weakSelf.textView.text = String(weakSelf.textView.text.dropLast())
                }
            }
            .disposed(by: disposeBag)
        
        backgroundView.rx.tapGesture()
            .when(.recognized)
            .withUnretained(self)
            .bind { weakSelf, _ in
                weakSelf.textView.endEditing(true)
            }
            .disposed(by: disposeBag)
    }
}
