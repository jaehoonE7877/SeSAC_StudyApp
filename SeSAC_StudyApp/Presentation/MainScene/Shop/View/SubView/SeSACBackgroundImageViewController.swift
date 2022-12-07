//
//  SeSACBackgroundImageViewController.swift
//  SeSAC_StudyApp
//
//  Created by Seo Jae Hoon on 2022/12/05.
//

import UIKit
import StoreKit
import RxSwift
import RxCocoa
import RxGesture

final class SeSACBackgroundImageViewController: BaseViewController {
    
    //1. 인앱 상품 ID 정의
    private var productIdentifiers: Set<String> = ["com.memolease.sesac1.background1", "com.memolease.sesac1.background2","com.memolease.sesac1.background3", "com.memolease.sesac1.background4",
                                           "com.memolease.sesac1.background5", "com.memolease.sesac1.background6", "com.memolease.sesac1.background7"]
    //1-2. 인앱 상품 정보
    private var productArray = Array<SKProduct>()
    private var product: SKProduct? //3이 끝나면 구매할 상품이 들어와있음
    
    var backgroundArray: [Int]?
    private var sesacImage = [SeSACImageModel(title: "하늘 공원", description: "새싹들을 많이 마주치는 매력적인 하늘 공원입니다", price: "보유")]
    
    private let viewModel = ShopViewModel()
    
    lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: self.configureCellLayout()).then {
        $0.dataSource = self
        $0.delegate = self
        $0.showsVerticalScrollIndicator = false
        $0.backgroundColor = .systemBackground
        $0.register(SeSACBackgroundImageCollectionViewCell.self, forCellWithReuseIdentifier: SeSACBackgroundImageCollectionViewCell.reuseIdentifier)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func configure() {
        view.addSubview(collectionView)
        
        collectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        collectionView.collectionViewLayout = self.configureCellLayout()
        requestProductData()
    }

}

extension SeSACBackgroundImageViewController {
    
    private func configureCellLayout() -> UICollectionViewLayout {
        
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(0.6))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(0.52))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        group.contentInsets = NSDirectionalEdgeInsets(top: 16, leading: 16, bottom: 0, trailing: 16)
        let section = NSCollectionLayoutSection(group: group)
        
        let layout = UICollectionViewCompositionalLayout(section: section)
        
        return layout
    }
    
}

extension SeSACBackgroundImageViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return sesacImage.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SeSACBackgroundImageCollectionViewCell.reuseIdentifier, for: indexPath) as? SeSACBackgroundImageCollectionViewCell else { return UICollectionViewCell()}
        
        guard let sesacCollection = backgroundArray else { return UICollectionViewCell() }

        cell.setData(collection: sesacCollection, indexPath: indexPath, sesacImage: sesacImage)
        
        cell.buyButton.rx.tapGesture()
            .when(.recognized)
            .throttle(.milliseconds(800), scheduler: MainScheduler.instance)
            .withUnretained(self)
            .subscribe { weakSelf, _ in
                if indexPath.item > 0 {
                    weakSelf.viewModel.checkShopMyInfo { result in
                        switch result {
                        case .success(let data):
                            if !data.backgroundCollection.contains(indexPath.item) {
                                let payment = SKPayment(product: weakSelf.productArray[indexPath.item - 1])
                                SKPaymentQueue.default().add(payment)
                                SKPaymentQueue.default().add(self)
                            } else {
                                weakSelf.view.makeToast("이미 보유중인 아이템입니다.", duration: 1, position: .center)
                            }
                        case .failure(let error):
                            weakSelf.view.makeToast(error.localizedDescription, duration: 1, position: .center)
                        }
                    }
                    
                }
            }
            .disposed(by: cell.cellDisposeBag)
        
        
        return cell
    }
    
}

extension SeSACBackgroundImageViewController: SKProductsRequestDelegate {

    private func decimalFormat(price: NSDecimalNumber) -> String {
           let numberFormatter = NumberFormatter()
           numberFormatter.numberStyle = .decimal
           return numberFormatter.string(for: price)!
       }

    private func requestProductData() {

        if SKPaymentQueue.canMakePayments() {
            print("인앱 결제 가능")
            let request = SKProductsRequest(productIdentifiers: productIdentifiers)
            request.delegate = self
            request.start()
        } else {
            print("In App Purchase Not Enabled")
        }
    }

    //3. 인앱 상품 정보 조회 응답 메서드[start()에서 호출됨]
    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {

            let products = response.products

            if products.count > 0 {

                for item in products {
                    productArray.append(item)
                    product = item //옵션. 테이블뷰 셀에서 구매하기 버튼 클릭 시, 버튼 클릭시 어떤 상품이 포함될지
                    //테이블 뷰 갱신, 뷰의 레이블에 보여주 기 등의 기능구현
                    sesacImage.append(SeSACImageModel(title: item.localizedTitle, description: item.localizedDescription, price: decimalFormat(price: item.price)))
                    DispatchQueue.main.async {
                        self.collectionView.reloadData()
                    }
                }

            } else {
                print("No Product Found")//계약 업데이트. 유료 계약 X. Capablities X
            }
        }

    func receiptValidation(transaction: SKPaymentTransaction, productIdentifier: String) {

            //구매 영수증 정보
            let receiptFileURL = Bundle.main.appStoreReceiptURL
            let receiptData = try? Data(contentsOf: receiptFileURL!)
            let receiptString = receiptData?.base64EncodedString(options: NSData.Base64EncodingOptions(rawValue: 0))
            //print(receiptString)
            guard let receipt = receiptString else { return }
            viewModel.checkReceipt(product: productIdentifier, receipt: receipt) { [weak self] statusCode in
                guard let self = self else { return }
                switch SeSACPurchaseError(rawValue: statusCode){
                case .success:
                    self.viewModel.checkShopMyInfo { result in
                        switch result {
                        case .success(let data):
                            self.backgroundArray = data.backgroundCollection
                            DispatchQueue.main.async {
                                self.collectionView.reloadData()
                            }
                        case .failure(let error):
                            self.view.makeToast(error.localizedDescription, duration: 1, position: .center)
                        }
                    }
                default:
                    self.view.makeToast(SeSACPurchaseError(rawValue: statusCode)?.localizedDescription, duration: 1, position: .center)
                }
            }
            
            //거래 내역(transaction)을 큐에서 제거
            SKPaymentQueue.default().finishTransaction(transaction)

        }
}

extension SeSACBackgroundImageViewController: SKPaymentTransactionObserver {

    // 구매가 시작되고 완료되는 단위: transaction, 구매가 성공적으로 될 수도있고 실패할 수도있다.
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {

            for transaction in transactions {

                switch transaction.transactionState {

                case .purchased: //구매 승인 이후에 영수증 검증

                    print("Transaction Approved. \(transaction.payment.productIdentifier)")
                    receiptValidation(transaction: transaction, productIdentifier: transaction.payment.productIdentifier)

                case .failed: //실패 토스트, transaction

                    print("Transaction Failed")
                    SKPaymentQueue.default().finishTransaction(transaction)

                default:
                    break
                }
            }
        }

    func paymentQueue(_ queue: SKPaymentQueue, removedTransactions transactions: [SKPaymentTransaction]) {
            print("removedTransactions")
        }
}
