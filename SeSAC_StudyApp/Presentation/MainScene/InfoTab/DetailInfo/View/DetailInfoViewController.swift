//
//  DetailInfoViewController.swift
//  SeSAC_StudyApp
//
//  Created by Seo Jae Hoon on 2022/11/14.
//

import UIKit

import RxSwift
import RxCocoa
import RxDataSources
import Toast

final class DetailInfoViewController: BaseViewController {
    
    //MARK: Property
    private let tableView = UITableView(frame: .zero, style: .plain).then {
        $0.register(InfoDetailTableViewCell.self, forCellReuseIdentifier: InfoDetailTableViewCell.reuseIdentifier)
        $0.register(SesacDetailTableViewCell.self, forCellReuseIdentifier: SesacDetailTableViewCell.reuseIdentifier)
        $0.register(SesacImageTableViewCell.self, forCellReuseIdentifier: SesacImageTableViewCell.reuseIdentifier)
        $0.separatorStyle = .none
    }
    
    private var foldValue: Bool = true
    
    private let viewModel = DetailViewModel()

    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setNavigationController()
        bindingViewModel()
        
    }
    
    override func configure() {
        title = "정보 관리"
        view.backgroundColor = .systemBackground
        view.addSubview(tableView)
    }
    
    override func setConstraint() {
        tableView.snp.makeConstraints { make in
            make.verticalEdges.equalToSuperview()
            make.horizontalEdges.equalToSuperview().inset(16)
        }
    }
    
    private func bindingTableView(sesacInfo: SeSACInfo) {

        let dataSource = RxTableViewSectionedReloadDataSource<DetailInfoSectionModel>(configureCell: { [weak self]  dataSource, tableView, indexPath, item in
            guard let self = self else { return UITableViewCell()}
            if indexPath.section == 0 {
                guard let cell = tableView.dequeueReusableCell(withIdentifier: SesacImageTableViewCell.reuseIdentifier, for: indexPath) as? SesacImageTableViewCell else { return UITableViewCell() }
                cell.selectionStyle = .none
                cell.bgImageView.image = UIImage(named: "sesac_background_\(item.background)")
                cell.sesacImageView.image = UIImage(named: "sesac_face_\(item.sesac)")
                return cell
            } else if indexPath.section == 1 {
                guard let cell = tableView.dequeueReusableCell(withIdentifier: SesacDetailTableViewCell.reuseIdentifier, for: indexPath) as? SesacDetailTableViewCell else { return UITableViewCell() }
                cell.layer.borderWidth = 1
                cell.layer.masksToBounds = true
                cell.layer.cornerRadius = 8
                cell.layer.borderColor = UIColor.gray2.cgColor
                cell.selectionStyle = .none
                cell.chevornImageView.image = self.foldValue ? UIImage(named: "more_arrow_down") : UIImage(named: "more_arrow_up")
                cell.sesacTitleView.isHidden = self.foldValue
                cell.sesacReviewView.isHidden = self.foldValue
                cell.nameLabel.text = item.nick
                [cell.sesacTitleView.mannerButton, cell.sesacTitleView.exactTimeButton,
                 cell.sesacTitleView.fastResponseButton, cell.sesacTitleView.kindButton,
                 cell.sesacTitleView.skillfullButton, cell.sesacTitleView.beneficialButton].forEach { self.configReputation(reputation: item.reputation, sender: $0)}
                cell.sesacReviewView.reviewLabel.text = item.comment.first
                return cell
            } else {
                guard let cell = tableView.dequeueReusableCell(withIdentifier: InfoDetailTableViewCell.reuseIdentifier, for: indexPath) as? InfoDetailTableViewCell else { return UITableViewCell() }
                cell.setData(item: item)
                return cell
            }
        })
        
        
        let section = [
            DetailInfoSectionModel(items: [SeSACInfo(background: sesacInfo.background, sesac: sesacInfo.sesac)]),
            DetailInfoSectionModel(items: [SeSACInfo(nick: sesacInfo.nick, reputation: sesacInfo.reputation, comment: sesacInfo.comment)]),
            DetailInfoSectionModel(items: [SeSACInfo(gender: sesacInfo.gender, study: sesacInfo.study, searchable: sesacInfo.searchable, ageMin: sesacInfo.ageMin, ageMax: sesacInfo.ageMax)])
        ]
        
        Observable.just(section)
          .bind(to: tableView.rx.items(dataSource: dataSource))
          .disposed(by: disposeBag)
        
        tableView.rx.itemSelected
            .withUnretained(self)
            .bind { weakSelf, indexPath in
                if indexPath.section == 1 {
                    weakSelf.foldValue.toggle()
                    weakSelf.tableView.reloadRows(at: [IndexPath(row: 0, section: 1)], with: .fade)
                }
            }
            .disposed(by: disposeBag)
        
        //input -> genderButtonTap, study TextField, phoneSearch switch, slider(age label에 보여주기), 회원탈퇴 버튼 tap
        
        tableView.rx.setDelegate(self)
            .disposed(by: disposeBag)
    }
}

extension DetailInfoViewController {
    private func bindingViewModel() {
        let input = DetailViewModel.Input(viewDidLoadEvent: Observable.just(()))
        let output = viewModel.transform(input: input)
        
        output.isFailed
            .asDriver(onErrorJustReturn: true)
            .drive { [weak self] isFailed in
                guard let self = self else { return }
                if isFailed {
                    self.view.makeToast("데이터 통신에 실패했습니다", duration: 1, position: .center)
                }
            }
            .disposed(by: disposeBag)
        //image2개 ,
        output.userData
            .withUnretained(self)
            .subscribe { weakSelf, sesacInfo in
                weakSelf.bindingTableView(sesacInfo: sesacInfo)
            }
            .disposed(by: disposeBag)
    }
    
    private func configReputation(reputation: [Int], sender: InfoButton)  {
        if reputation[sender.tag] > 0 {
            sender.status = .active
        } else {
            sender.status = .inactive
        }
    }
    
}

extension DetailInfoViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {

        if indexPath.section == 0 {
            return 194
        } else if indexPath.section == 1 {
            return foldValue ? 60 : UITableView.automaticDimension
        } else {
            return 404
        }
    }
}

