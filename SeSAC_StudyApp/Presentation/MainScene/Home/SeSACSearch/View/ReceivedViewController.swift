//
//  ReceivedViewController.swift
//  SeSAC_StudyApp
//
//  Created by Seo Jae Hoon on 2022/11/23.
//
import UIKit

import RxSwift
import RxCocoa
import RxDataSources

final class ReceivedViewController: BaseViewController {
    
    private let mainView = SeSACSearchView()
    private let disposeBag = DisposeBag()
    let viewModel = SeSACSearchViewModel()
    
    private var sesacFriend: [SeSACCardModel]?
    
    var foldValues = [Bool]()
    
    override func loadView() {
        self.view = mainView
    }
    
    lazy var dataSource = RxTableViewSectionedReloadDataSource<SeSACCardSectionModel>(configureCell: { [weak self] dataSource, tableView, indexPath, item in
        guard let self = self else { return UITableViewCell()}
        
        guard let cell = self.mainView.tableView.dequeueReusableCell(withIdentifier: SesacDetailTableViewCell.reuseIdentifier, for: indexPath) as? SesacDetailTableViewCell else { return UITableViewCell()}
        cell.selectionStyle = .none
        
        cell.chevornImageView.image = self.foldValues[indexPath.section] ? UIImage(named: "more_arrow_down") : UIImage(named: "more_arrow_up")
        cell.sesacTitleView.isHidden = self.foldValues[indexPath.section]
        cell.sesacReviewView.isHidden = self.foldValues[indexPath.section]
        
        cell.setDatas(item: item)
                
        return cell
    })
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindingViewModel()
        mainView.tableView.rx.setDelegate(self)
            .disposed(by: disposeBag)
    }
    
    private func bindingViewModel() {
        
    }
    
    private func bindingTableView(sesacFriends: [SeSACCardModel]) {
        
        var sections: [SeSACCardSectionModel] = []
        
        for friend in sesacFriends{
            sections.append(SeSACCardSectionModel(items: [SeSACCardModel(background: friend.background, sesac: friend.sesac, nick: friend.nick, reputation: friend.reputation, reviews: friend.reviews, studylist: friend.studylist)]))
        }
        
        Observable.just(sections)
            .bind(to: mainView.tableView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
        
        mainView.tableView.rx.itemSelected
            .withUnretained(self)
            .bind { weakSelf, indexPath in
                weakSelf.foldValues[indexPath.section].toggle()
                weakSelf.mainView.tableView.reloadSections(IndexSet(integer: indexPath.section), with: .fade)
            }
            .disposed(by: disposeBag)
    }
}

extension ReceivedViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 200
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let headerCell = tableView.dequeueReusableHeaderFooterView(withIdentifier: ProfileImageHeaderView.reuseIdentifier) as? ProfileImageHeaderView else { return nil}
        
        headerCell.requireButton.isHidden = false
        
        guard let items = sesacFriend else { return nil }
        headerCell.bgImageView.image = UIImage(named: "sesac_background_\(items[section].background)")
        headerCell.sesacImageView.image = UIImage(named: "sesac_face_\(items[section].sesac)")
        
        headerCell.requireButton.rx.tap
            .withUnretained(self)
            .bind { weakSelf, _ in
                let vc = RequireViewController()
                vc.viewModel.uid = items[section].uid
                vc.modalPresentationStyle = .overFullScreen
                weakSelf.present(vc, animated: false)
            }
            .disposed(by: disposeBag)
        
        return headerCell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return foldValues[indexPath.section] ? 60 : UITableView.automaticDimension
    }
}
