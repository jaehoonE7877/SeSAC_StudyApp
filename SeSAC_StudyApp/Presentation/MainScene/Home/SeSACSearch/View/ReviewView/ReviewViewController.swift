//
//  ReviewViewController.swift
//  SeSAC_StudyApp
//
//  Created by Seo Jae Hoon on 2022/11/24.
//

import UIKit

import RxSwift
import RxCocoa
import RxDataSources

final class ReviewViewController: BaseViewController {
    
    lazy var backButton = UIBarButtonItem(image: UIImage(named: "arrow"), style: .plain, target: self, action: nil)
        
    private lazy var tableView = UITableView(frame: .zero, style: .plain).then {
        $0.delegate = self
        $0.dataSource = self
        $0.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        $0.showsVerticalScrollIndicator = false
    }
    
    private let disposeBag = DisposeBag()
    
    var reviews: [String]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setNavigationController()
        bindUI()
    }
    
    override func configure() {
        view.backgroundColor = .systemBackground
        view.addSubview(tableView)
        
        tableView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.bottom.equalToSuperview()
            make.horizontalEdges.equalToSuperview().inset(16)
        }
    }
    
    override func setNavigationController() {
        title = "새싹 리뷰"
        navigationItem.leftBarButtonItem = backButton
    }
    
    private func bindUI() {
        
        backButton.rx.tap
            .withUnretained(self)
            .bind { weakSelf, _ in
                weakSelf.navigationController?.popViewController(animated: true)
            }
            .disposed(by: disposeBag)
    }
}

extension ReviewViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return reviews?.count ?? 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        cell.textLabel?.numberOfLines = 0
        cell.textLabel?.textColor = .textColor
        cell.textLabel?.font = .notoSans(size: 14, family: .Regular)
        cell.textLabel?.text = reviews?[indexPath.row]
        
        return cell
    }
    
}
