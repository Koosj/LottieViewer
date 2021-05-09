//
//  InfomationViewController.swift
//  LottieViewer
//
//  Created by Bonsung Koo on 2021/05/06.
//

import UIKit
import RxSwift

final class InfomationViewController: BaseViewController {
    
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var appImageView: UIImageView!
    @IBOutlet weak var lottieVersionLabel: UILabel!
    @IBOutlet weak var donateToDeveloperButton: UIButton!

    private let _disposeBag: DisposeBag = DisposeBag()
    var infomationViewModel: InfomationViewModel!
    
    static func instantiate(viewModel: InfomationViewModel) -> InfomationViewController? {
        
        let storyBoard = UIStoryboard.init(name: StoryBoard.Main.rawValue, bundle: .main)
        
        guard let infomationViewController = storyBoard.instantiateViewController(identifier: InfomationViewController.className) as? InfomationViewController else { return nil }
        
        infomationViewController.infomationViewModel = viewModel
        
        return infomationViewController
    }
    
    override func viewDidLoad() {
        _configureInfomationViewController()
        _bind()
    }
    
    private func _configureInfomationViewController() {
        appImageView.layer.cornerRadius = 15
        
        donateToDeveloperButton.layer.cornerRadius = 10
        donateToDeveloperButton.layer.borderWidth = 1.0
        donateToDeveloperButton.layer.borderColor = UIColor.AccentColor?.cgColor
    }
    
    private func _bind() {
        
        infomationViewModel.output.infomation
            .asObservable()
            .map({ $0?.lottieVersion })
            .bind(to: lottieVersionLabel.rx.text)
            .disposed(by: _disposeBag)
        
        closeButton.rx.tap
            .asDriver()
            .drive(onNext: { [weak self] in
                self?.dismiss(animated: true, completion: nil)
            }, onCompleted: nil, onDisposed: nil)
            .disposed(by: _disposeBag)
        
        donateToDeveloperButton.rx.tap
            .asDriver()
            .drive(onNext: { [weak self] in
                
                guard let supportDeveloperViewController = SupportDeveloperViewController.instantiate(viewModel: SupportDeveloperViewModel()) else { return }
                
                self?.present(supportDeveloperViewController, animated: true, completion: nil)
                
            }, onCompleted: nil, onDisposed: nil)
            .disposed(by: _disposeBag)
        
    }
}
