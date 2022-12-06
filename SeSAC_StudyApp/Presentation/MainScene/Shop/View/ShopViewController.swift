//
//  ShopViewController.swift
//  SeSAC_StudyApp
//
//  Created by Seo Jae Hoon on 2022/11/12.
//

import UIKit
import StoreKit

import RxCocoa
import RxSwift

final class ShopViewController: BaseViewController {
    
    //이미지 + 저장하기 버튼 + 컨테이너뷰 -> 탭 맨 뷰컨 -> 뷰컨 2개(왼쪽 컬렉션 뷰 오른쪽 테이블 뷰)
    private let mainView = ShopView()
    
    private let tabmanVC = ShopTabManViewController()
    
    private let disposeBag = DisposeBag()
    
    private let viewModel = ShopViewModel()
    
    //1. 인앱 상품 ID 정의
    var productIdentifiers: Set<String> = ["com.memolease.sesac1.sprout1", "com.memolease.sesac1.sprout2", "com.memolease.sesac1.sprout3", "com.memolease.sesac1.sprout4",
                                           "com.memolease.sesac1.background1", "com.memolease.sesac1.background2", "com.memolease.sesac1.background3", "com.memolease.sesac1.background4",
                                           "com.memolease.sesac1.background5", "com.memolease.sesac1.background6", "com.memolease.sesac1.background7"]
    //1-2. 인앱 상품 정보
    var productArray = Array<SKProduct>()
    var product: SKProduct? //3이 끝나면 구매할 상품이 들어와있음
    
    override func loadView() {
        self.view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setNavigationController()
        
        self.addChild(tabmanVC)
        self.view.addSubview(tabmanVC.view)
        tabmanVC.view.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview()
            make.top.equalTo(mainView.sesacImageView.snp.bottom)
            make.bottom.equalTo(mainView.safeAreaLayoutGuide)
        }
        tabmanVC.didMove(toParent: self)
        
        requestProductData()
    }
    override func setNavigationController() {
        title = "새싹샵"
        navigationController?.navigationBar.tintColor = .textColor
    }
        
    private func viewModelBinding() {
        
        let input = ShopViewModel.Input(viewWillAppearEvent: self.rx.viewWillAppear)
        let output = viewModel.transform(input: input)
        
        output.fetchFailed
            .asDriver(onErrorJustReturn: "")
            .drive { [weak self] error in
                guard let self = self else { return }
                self.view.makeToast(error, duration: 1, position: .center)
            }
            .disposed(by: disposeBag)
        
        output.myInfoData
            .withUnretained(self)
            .subscribe { weakSelf, data in
                weakSelf.mainView.sesacImageView.image = UIImage(named: "sesac_face_\(data.sesac)")
                weakSelf.mainView.bgImageView.image = UIImage(named: "sesac_background_\(data.background)")
                weakSelf.tabmanVC.firstVC.sesacArray = data.sesacCollection
                weakSelf.tabmanVC.secondVC.backgroundArray = data.backgroundCollection
            }
            .disposed(by: disposeBag)
            
        
    }
}

extension ShopViewController: SKProductsRequestDelegate {
    
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
                
                for i in products {
                    productArray.append(i)
                    product = i //옵션. 테이블뷰 셀에서 구매하기 버튼 클릭 시, 버튼 클릭시 어떤 상품이 포함될지
                    //테이블 뷰 갱신, 뷰의 레이블에 보여주 기 등의 기능구현
                    print(i.localizedTitle, i.price, i.priceLocale, i.localizedDescription)
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
           
            print(receiptString)
            //거래 내역(transaction)을 큐에서 제거
            SKPaymentQueue.default().finishTransaction(transaction)
            
        }
}

extension ShopViewController: SKPaymentTransactionObserver {
    
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
