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
    private let viewModel = DetailViewModel()
    
    private let disposeBag = DisposeBag()
    
    private lazy var tableView = UITableView(frame: .zero, style: .grouped).then {
        $0.contentInset = .init(top: 16, left: 0, bottom: 0, right: 0)
        $0.backgroundColor = .systemBackground
        $0.register(ProfileImageHeaderView.self, forHeaderFooterViewReuseIdentifier: ProfileImageHeaderView.reuseIdentifier)
        $0.register(InfoDetailTableViewCell.self, forCellReuseIdentifier: InfoDetailTableViewCell.reuseIdentifier)
        $0.register(SesacDetailTableViewCell.self, forCellReuseIdentifier: SesacDetailTableViewCell.reuseIdentifier)
        $0.separatorStyle = .none
    }
    
    private var updateSesac: SeSACInfo?
    
    lazy var dataSource = RxTableViewSectionedReloadDataSource<DetailInfoSectionModel>(configureCell: { [weak self]  dataSource, tableView, indexPath, item in
        guard let self = self else { return UITableViewCell()}
        if indexPath.section == 0 {
            
            guard let cell = tableView.dequeueReusableCell(withIdentifier: SesacDetailTableViewCell.reuseIdentifier, for: indexPath) as? SesacDetailTableViewCell else { return UITableViewCell() }
            cell.selectionStyle = .none
            cell.chevornImageView.image = self.foldValue ? UIImage(named: "more_arrow_down") : UIImage(named: "more_arrow_up")
            cell.sesacTitleView.isHidden = self.foldValue
            cell.sesacReviewView.isHidden = self.foldValue
            cell.setData(item: item)
            return cell
        } else {
            
            guard let cell = tableView.dequeueReusableCell(withIdentifier: InfoDetailTableViewCell.reuseIdentifier, for: indexPath) as? InfoDetailTableViewCell else { return UITableViewCell() }
            cell.setData(item: item)
            
            cell.genderView.manButton.rx.tap
                .bind { _ in
                    cell.genderView.womanButton.status = .inactive
                    cell.genderView.manButton.status = .active
                    self.updateSesac?.gender = 1
                }
                .disposed(by: self.disposeBag)
            
            cell.genderView.womanButton.rx.tap
                .bind { _ in
                    cell.genderView.manButton.status = .inactive
                    cell.genderView.womanButton.status = .active
                    self.updateSesac?.gender = 0
                }
                .disposed(by: self.disposeBag)
            
            cell.studyInputView.studyTextField.rx.text.orEmpty
                .bind { text in
                    self.updateSesac?.study = text
                }
                .disposed(by: self.disposeBag)
          
            cell.phoneSearchView.phoneButton.rx.isOn
                .bind { value in
                    self.updateSesac?.searchable = value ? 1 : 0
                }
                .disposed(by: self.disposeBag)
                
            cell.friendAgeView.slider.rx.controlEvent(.valueChanged)
                .bind { _ in
                    cell.friendAgeView.ageLabel.text = "\(Int(cell.friendAgeView.slider.value[0])) - \(Int(cell.friendAgeView.slider.value[1]))"
                    self.updateSesac?.ageMin = Int(cell.friendAgeView.slider.value[0])
                    self.updateSesac?.ageMax = Int(cell.friendAgeView.slider.value[1])
                }
                .disposed(by: self.disposeBag)
            
           
            
            cell.withdrawView.withdrawButton.rx.tap
                .bind(onNext: { _ in
                    let vc = WithdrawViewController()
                    self.transitionViewController(viewController: vc, transitionStyle: .presentOverFull)
                })
                .disposed(by: self.disposeBag)
            
            return cell
        }
    })
    
    
    private lazy var saveButton = UIBarButtonItem(title: "저장", style: .plain, target: DetailInfoViewController.self, action: nil)
    
    var foldValue: Bool = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBarController?.tabBar.isHidden = true
        setNavigationController()
        bindingViewModel()
        tableView.rx.setDelegate(self)
            .disposed(by: disposeBag)
    }
    
    override func setNavigationController() {
        title = "정보 관리"
        navigationItem.rightBarButtonItem = saveButton
    }
    
    override func configure() {
        
        view.backgroundColor = .systemBackground
        view.addSubview(tableView)
    }
    
    override func setConstraint() {
        tableView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.bottom.equalToSuperview()
            make.horizontalEdges.equalToSuperview().inset(16)
        }
    }
    
    private func bindingTableView(sesacInfo: SeSACInfo) {
        
        let section = [
            DetailInfoSectionModel(items: [SeSACInfo(background: sesacInfo.background, sesac: sesacInfo.sesac, nick: sesacInfo.nick, reputation: sesacInfo.reputation, comment: sesacInfo.comment)]),
            DetailInfoSectionModel(items: [SeSACInfo(gender: sesacInfo.gender, study: sesacInfo.study, searchable: sesacInfo.searchable, ageMin: sesacInfo.ageMin, ageMax: sesacInfo.ageMax)])
        ]
        
        Observable.just(section)
            .bind(to: tableView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
        
        tableView.rx.itemSelected
            .withUnretained(self)
            .bind { weakSelf, indexPath in
                if indexPath.section == 0 {
                    weakSelf.foldValue.toggle()
                    weakSelf.tableView.reloadRows(at: [IndexPath(row: 0, section: 0)], with: .fade)
                }
            }
            .disposed(by: disposeBag)
    }
}

extension DetailInfoViewController {
    private func bindingViewModel() {
        let input = DetailViewModel.Input(viewDidLoadEvent: Observable.just(()),
                                          saveButtonTap: saveButton.rx.tap
        )
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
        
        output.userData
            .withUnretained(self)
            .subscribe { weakSelf, sesacInfo in
                weakSelf.updateSesac = sesacInfo
                weakSelf.bindingTableView(sesacInfo: sesacInfo)
            }
            .disposed(by: disposeBag)
        
        output.saveButtonTap
            .withUnretained(self)
            .subscribe { weakSelf, _ in
                guard let updateSesac = weakSelf.updateSesac else { return }
                weakSelf.viewModel.updateInfo(updataData: updateSesac) { result in
                    switch result{
                    case .success(let result):
                        print(result)
                    case .failure(let error):
                        switch error {
                        case .success:
                            weakSelf.navigationController?.popViewController(animated: true)
                        default:
                            weakSelf.view.makeToast(error.errorDescription, duration: 1, position: .center)
                        }
                    }
                }
            }
            .disposed(by: disposeBag)
    }
}

extension DetailInfoViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return 200
        } else {
            return .leastNormalMagnitude
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 0 {
            guard let headerCell = tableView.dequeueReusableHeaderFooterView(withIdentifier: ProfileImageHeaderView.reuseIdentifier) as? ProfileImageHeaderView else { return nil }
            guard let item = dataSource.sectionModels.first.value?.items[0] else { return nil }
            headerCell.bgImageView.image = UIImage(named: "sesac_background_\(item.background)")
            headerCell.sesacImageView.image = UIImage(named: "sesac_face_\(item.sesac)")
            
            return headerCell
        } else {
            return UIView(frame: .zero)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {

        if indexPath.section == 0 {
            return foldValue ? 60 : UITableView.automaticDimension
        } else {
            return 404
        }
    }
}

