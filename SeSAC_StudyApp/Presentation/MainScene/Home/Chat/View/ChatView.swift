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
    
    let viewModel = ChatViewModel()
    
    let viewMoreButton = UIBarButtonItem(image: UIImage(systemName: "ellipsis"), style: .plain, target: ChatViewController.self, action: nil)
    let backButton = UIBarButtonItem(image: UIImage(named: "arrow"), style: .plain, target: ChatViewController.self, action: nil)
    
    lazy var subView = SubChatView().then {
        $0.backgroundColor = .clear
    }
    
    lazy var tableView = UITableView(frame: .zero, style: .plain).then {
        $0.rowHeight = UITableView.automaticDimension
        $0.register(ChatDateCell.self, forCellReuseIdentifier: ChatDateCell.reuseIdentifier)
        $0.register(MyChatCell.self, forCellReuseIdentifier: MyChatCell.reuseIdentifier)
        $0.register(YourChatCell.self, forCellReuseIdentifier: YourChatCell.reuseIdentifier)
        $0.showsVerticalScrollIndicator = false
        $0.backgroundColor = .systemBackground
        $0.separatorStyle = .none
    }
        
    let textBackgroundView = UIView().then {
        $0.backgroundColor = .gray1
        $0.layer.cornerRadius = 8
    }
    
    let textView = UITextView().then {
        $0.isScrollEnabled = false
        $0.backgroundColor = .clear
        $0.textColor = .gray7
        $0.text = "메세지를 입력하세요"
        $0.font = .notoSans(size: 14, family: .Regular)
    }
    
    let sendButton = UIButton().then {
        $0.isEnabled = false
        $0.contentMode = .scaleAspectFill
        $0.setImage(UIImage(named: "willsend"), for: .normal)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setBinding()
        
    }
    
    override func configure() {
        [tableView, subView, textBackgroundView].forEach { self.addSubview($0)}
        [textView, sendButton].forEach{ textBackgroundView.addSubview($0)}
    }
    
    override func setConstraints() {
        subView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.horizontalEdges.equalToSuperview()
            make.height.equalTo(0)
        }
        
        tableView.snp.makeConstraints { make in
            make.verticalEdges.equalToSuperview()
            make.horizontalEdges.equalToSuperview().inset(16)
        }
        
        textBackgroundView.snp.makeConstraints { make in
            make.bottom.equalToSuperview().offset(-50)
            make.horizontalEdges.equalToSuperview().inset(16)
            make.height.greaterThanOrEqualTo(52)
        }
        
        sendButton.snp.makeConstraints { make in
            make.centerY.equalTo(textBackgroundView.snp.centerY)
            make.size.equalTo(24)
            make.trailing.equalTo(textBackgroundView.snp.trailing).inset(12)
        }

        textView.snp.makeConstraints { make in
            make.verticalEdges.equalToSuperview().inset(14)
            make.height.lessThanOrEqualTo(72)
            make.leading.equalToSuperview().inset(12)
            make.trailing.equalTo(sendButton.snp.leading).offset(-8)
        }
        
        
    }
    
    private func setBinding() {
        
        subView.backgroundView.rx.tapGesture()
            .when(.recognized)
            .withUnretained(self)
            .bind { weakSelf, _ in
                weakSelf.foldValue = false
                weakSelf.foldSubView()
            }
            .disposed(by: disposeBag)
        
        viewMoreButton.rx.tap
            .withUnretained(self)
            .bind { weakSelf, _ in
                if weakSelf.foldValue {
                    weakSelf.foldValue.toggle()
                    weakSelf.foldSubView()
                } else {
                    weakSelf.viewModel.getMyStatus { result in
                        switch result {
                        case .success(let matchData):
                            weakSelf.foldValue.toggle()
                            weakSelf.unfoldSubView()
                            if matchData.matched == 1 {
                                weakSelf.subView.cancelMatchButton.itemLabel.text = "스터디 취소"
                            } else if matchData.dodged == 1 || matchData.reviewed == 1 {
                                weakSelf.subView.cancelMatchButton.itemLabel.text = "스터디 종료"
                            }
                        case .failure(_):
                            break
                        }
                    }
                }
            }
            .disposed(by: disposeBag)
        
        textView.rx.didBeginEditing
            .withUnretained(self)
            .bind { weakSelf, _ in
                if weakSelf.textView.text == "메세지를 입력하세요"  {
                    weakSelf.textView.text = nil
                    weakSelf.sendButton.setImage(UIImage(named: "send"), for: .normal)
                    weakSelf.sendButton.isEnabled = true
                }
                weakSelf.textView.textColor = .textColor
            }
            .disposed(by: disposeBag)
        
        textView.rx.didEndEditing
            .withUnretained(self)
            .bind { weakSelf, _ in
                if weakSelf.textView.text.count == 0 {
                    weakSelf.textView.text = "메세지를 입력하세요"
                    weakSelf.textView.textColor = .gray7
                    weakSelf.sendButton.setImage(UIImage(named: "willsend"), for: .normal)
                    weakSelf.sendButton.isEnabled = false
                }
            }
            .disposed(by: disposeBag)
        
        textView.rx.didChange
              .subscribe(onNext: { [weak self] in
                  guard let self = self else { return }
                let size = CGSize(width: self.textView.frame.width, height: .infinity)
                let estimatedSize = self.textView.sizeThatFits(size)
                let isMaxHeight = estimatedSize.height >= 72
                
                //guard let isMaxHeight != self.textView.isScrollEnabled else { return }
                self.textView.isScrollEnabled = isMaxHeight
                //self.textView.reloadInputViews()
                self.setNeedsUpdateConstraints()
              })
              .disposed(by: disposeBag)
    }
}

extension ChatView {
    
    private func foldSubView() {
        subView.snp.remakeConstraints { make in
            make.top.equalToSuperview()
            make.horizontalEdges.equalToSuperview()
            make.height.equalTo(0)
        }
        subView.subStackView.snp.remakeConstraints { make in
            make.height.equalTo(0)
            make.top.leading.trailing.equalToSuperview()
        }
        UIView.animate(withDuration: 0.3) { [weak self] in
            guard let self else { return }
            self.subView.layoutIfNeeded()

            self.subView.backgroundView.snp.remakeConstraints { make in
                make.top.equalToSuperview()
                make.horizontalEdges.equalToSuperview()
                make.height.equalTo(0)
            }
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.25){ [weak self] in
            guard let self else { return }
            [self.subView.cancelMatchButton, self.subView.reportButton, self.subView.reviewButton ].forEach { $0.isHidden = true}
        }
    }
    
    private func unfoldSubView() {
        subView.snp.remakeConstraints { make in
            make.edges.equalToSuperview()
        }
        subView.subStackView.snp.remakeConstraints { make in
            make.height.equalTo(72)
            make.top.equalToSuperview()
            make.horizontalEdges.equalToSuperview()
        }
        UIView.animate(withDuration: 0.3) { [weak self] in
            guard let self else { return }
            self.subView.layoutIfNeeded()
            
            self.subView.backgroundView.snp.remakeConstraints { make in
                make.top.equalTo(self.safeAreaLayoutGuide)
                make.horizontalEdges.equalToSuperview()
                make.bottom.equalToSuperview()
            }
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.25){ [weak self] in
            guard let self else { return }
            [self.subView.cancelMatchButton, self.subView.reportButton, self.subView.reviewButton ].forEach { $0.isHidden = false}
        }
    }
}
