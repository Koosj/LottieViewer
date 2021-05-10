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
            .subscribe { [weak self] supportDeveloperModel in
                
                if let product = supportDeveloperModel.element?.product {
                    let payment = SKPayment(product: product)
                    SKPaymentQueue.default().add(payment)
                    
                } else {
                    
                    switch ATTrackingManager.trackingAuthorizationStatus {

                    case .notDetermined:
                        ATTrackingManager.requestTrackingAuthorization { status in
                            if status == .authorized {
                                GADMobileAds.sharedInstance().start { adSatus in
                                    App.canAdsShowing.accept(true)
                                    self?.supportDeveloperTableView.reloadData()
                                }
                            }
                        }
                    case .denied:
                        
                        let alertController = UIAlertController(title: "Your privacy is precious💎", message: "BUT\nIf you want some help developer\nFollow this instruction.\nSettings⚙️ -> Privacy✋ -> Track👀\nCheck 'Allow Apps to Request to Track' option is On.\nIf it is tap Go to Setting.\nIf not? Tap to Close\nAnd turn on that option🙏\n And then back to here.", preferredStyle: .alert)
                        
                        let gotoSettingAction = UIAlertAction(title: "Go to Setting", style: .default) { _ in
                            if let settingURL = URL(string: UIApplication.openSettingsURLString) {
                                UIApplication.shared.open(settingURL, options: [:], completionHandler: nil)
                            }
                        }
                        
                        let closeAction = UIAlertAction(title: "Close", style: .cancel, handler: nil)
                        
                        alertController.addAction(closeAction)
                        alertController.addAction(gotoSettingAction)
                        
                        self?.present(alertController, animated: true, completion: nil)
                        
                    case .authorized:
                        break
                    case .restricted:
                        break
                    @unknown default:
                        break
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
