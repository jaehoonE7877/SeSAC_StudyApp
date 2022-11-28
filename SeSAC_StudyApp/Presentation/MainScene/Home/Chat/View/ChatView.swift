//
//  ChatView.swift
//  SeSAC_StudyApp
//
//  Created by Seo Jae Hoon on 2022/11/27.
//

import UIKit

import RxSwift
import RxCocoa
import RxGesture

final class ChatView: BaseView {
    
    private let disposeBag = DisposeBag()
    
    private var foldValue: Bool = false
    
    let viewMoreButton = UIBarButtonItem(image: UIImage(systemName: "ellipsis"), style: .plain, target: ChatViewController.self, action: nil)
    let backButton = UIBarButtonItem(image: UIImage(named: "arrow"), style: .plain, target: ChatViewController.self, action: nil)
    
    lazy var subView = SubChatView().then {
        $0.backgroundColor = .clear
    }
    
    lazy var tableView = UITableView(frame: .zero, style: .plain).then {
        $0.showsVerticalScrollIndicator = false
        $0.backgroundColor = .systemBackground
//        $0.register(ChatDateCell.self, forHeaderFooterViewReuseIdentifier: ChatDateCell.reuseIdentifier)
//        $0.register(MyChatCell.self, forHeaderFooterViewReuseIdentifier: MyChatCell.reuseIdentifier)
//        $0.register(YourChatCell.self, forHeaderFooterViewReuseIdentifier: YourChatCell.reuseIdentifier)
        $0.separatorStyle = .none
    }
        
    let textView = UITextView().then {
        $0.sizeToFit()
        $0.isScrollEnabled = false
        $0.backgroundColor = .gray1
        $0.layer.cornerRadius = 8
        $0.contentInset = .init(top: 14, left: 12, bottom: 14, right: 44)
        $0.textColor = .gray7
        $0.text = "메세지를 입력하세요"
        $0.font = .notoSans(size: 14, family: .Regular)
    }
    
    let sendButton = UIButton().then {
        $0.contentMode = .scaleAspectFill
        $0.setImage(UIImage(named: "willsend"), for: .normal)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setBinding()
    }
    
    override func configure() {
        [tableView, textView, sendButton, subView].forEach { self.addSubview($0)}
    }
    
    override func setConstraints() {
        subView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        tableView.snp.makeConstraints { make in
            make.verticalEdges.equalToSuperview()
            make.horizontalEdges.equalToSuperview().inset(16)
        }
        
        textView.snp.makeConstraints { make in
            make.bottom.equalToSuperview().offset(-50)
            make.horizontalEdges.equalToSuperview().inset(16)
            make.height.equalTo(52)
        }
        
        sendButton.snp.makeConstraints { make in
            make.centerY.equalTo(textView.snp.centerY)
            make.size.equalTo(24)
            make.trailing.equalTo(textView.snp.trailing).inset(12)
        }
    }
    
    private func setBinding() {
        
        subView.rx.tapGesture()
            .when(.recognized)
            .withUnretained(self)
            .bind { weakSelf, _ in
                weakSelf.foldValue = false
                [weakSelf.subView.cancelMatchButton, weakSelf.subView.reportButton, weakSelf.subView.reviewButton ].forEach { $0.isHidden = true}
                weakSelf.subView.subStackView.snp.remakeConstraints { make in
                    make.height.equalTo(0)
                    make.top.leading.trailing.equalToSuperview()
                }
                weakSelf.subView.backgroundView.snp.remakeConstraints { make in
                    make.top.equalToSuperview()
                    make.horizontalEdges.equalToSuperview()
                    make.height.equalTo(0)
                }
            }
            .disposed(by: disposeBag)
        
        viewMoreButton.rx.tap
            .withUnretained(self)
            .bind { weakSelf, _ in
                if weakSelf.foldValue {
                    weakSelf.foldValue.toggle()
                    weakSelf.subView.subStackView.snp.remakeConstraints { make in
                        make.height.equalTo(0)
                        make.top.leading.trailing.equalToSuperview()
                    }
                    UIView.animate(withDuration: 0.3) {
                        weakSelf.subView.layoutIfNeeded()

                        weakSelf.subView.backgroundView.snp.remakeConstraints { make in
                            make.top.equalToSuperview()
                            make.horizontalEdges.equalToSuperview()
                            make.height.equalTo(0)
                        }
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.25){
                        [weakSelf.subView.cancelMatchButton, weakSelf.subView.reportButton, weakSelf.subView.reviewButton ].forEach { $0.isHidden = true}
                    }
                } else {
                    weakSelf.foldValue.toggle()
                    weakSelf.subView.subStackView.snp.remakeConstraints { make in
                        make.height.equalTo(72)
                        make.top.equalToSuperview()
                        make.horizontalEdges.equalToSuperview()
                    }
                    UIView.animate(withDuration: 0.3) {
                        weakSelf.subView.layoutIfNeeded()
                        
                        weakSelf.subView.backgroundView.snp.remakeConstraints { make in
                            make.top.equalTo(weakSelf.safeAreaLayoutGuide)
                            make.horizontalEdges.equalToSuperview()
                            make.bottom.equalToSuperview()
                        }
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.25){
                        [weakSelf.subView.cancelMatchButton, weakSelf.subView.reportButton, weakSelf.subView.reviewButton ].forEach { $0.isHidden = false}
                    }
                }
            }
            .disposed(by: disposeBag)
        
        
    }
}
