//
//  SupportDeveloperViewController.swift
//  LottieViewer
//
//  Created by Bonsung Koo on 2021/05/07.
//

import UIKit
import RxSwift
import RxCocoa
import StoreKit
import AppTrackingTransparency
import GoogleMobileAds

final class SupportDeveloperViewController: BaseViewController, SKPaymentTransactionObserver, SKProductsRequestDelegate {
    
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var supportDeveloperTableView: UITableView!
    
    private let _disposeBag: DisposeBag = DisposeBag()
    var supportDeveloperViewModel: SupportDeveloperViewModel!
    
    static func instantiate(viewModel: SupportDeveloperViewModel) -> SupportDeveloperViewController? {
        
        let storyBoard = UIStoryboard.init(name: StoryBoard.Main.rawValue, bundle: .main)
        
        guard let supportDeveloperViewController = storyBoard.instantiateViewController(identifier: SupportDeveloperViewController.className) as? SupportDeveloperViewController else { return nil }
        
        supportDeveloperViewController.supportDeveloperViewModel = viewModel
        
        return supportDeveloperViewController
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        _configureSupportDeveloperTableView()
        _bind()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        _getIAP()
        SKPaymentQueue.default().add(self)
    }
    
    private func _configureSupportDeveloperTableView() {
        supportDeveloperTableView.register(UINib(nibName: SupportDeveloperTableViewCell.className, bundle: .main), forCellReuseIdentifier: SupportDeveloperTableViewCell.className)
    }
    
    private func _bind() {
        
        closeButton.rx.tap
            .asDriver()
            .drive(onNext: { [weak self] in
                self?.dismiss(animated: true, completion: nil)
            }, onCompleted: nil, onDisposed: nil)
            .disposed(by: _disposeBag)
        
        supportDeveloperViewModel.output.supportDeveloper
            .asDriver()
            .drive(supportDeveloperTableView.rx.items(cellIdentifier: SupportDeveloperTableViewCell.className)) { row, product, cell in
                guard let cell = cell as? SupportDeveloperTableViewCell else { return }
                cell.configureCell(with: product)
            }
            .disposed(by: _disposeBag)
        
        supportDeveloperTableView.rx.modelSelected(SupportDeveloperModel.self)
            .subscribe { supportDeveloperModel in
                
                if let product = supportDeveloperModel.element?.product {
                    let payment = SKPayment(product: product)
                    SKPaymentQueue.default().add(payment)
                    
                } else {
                    if ATTrackingManager.trackingAuthorizationStatus != .authorized {
                        if let settingURL = URL(string: UIApplication.openSettingsURLString) {
                            UIApplication.shared.open(settingURL, options: [:], completionHandler: nil)
                        }
                    }
                }
            }
            .disposed(by: _disposeBag)
    }
    
    private func _getIAP() {
        if SKPaymentQueue.canMakePayments() {
            let request = SKProductsRequest(productIdentifiers: Set(SupportDeveloperProduct.IDs))
            request.delegate = self
            request.start()
        } else {
            log.error("Please enable In APP Purchase in settings")
        }
    }
    
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        for transaction in transactions {

            switch transaction.transactionState {

            case .purchased:
                SKPaymentQueue.default().finishTransaction(transaction)

            case .restored:
                SKPaymentQueue.default().finishTransaction(transaction)

            case .failed:
                SKPaymentQueue.default().finishTransaction(transaction)
                
            default:
                break
            }
        }
    }
    
    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        let products = response.products
            .map({ SupportDeveloperModel(product: $0) })
        
        supportDeveloperViewModel.input.supportDeveloper.accept(products)
    
        let productList = response.invalidProductIdentifiers
        for productItem in productList {
            log.error("Product not found: \(productItem)")
        }
    }
}
