//
//  PlayViewController.swift
//  LottieViewer
//
//  Created by Bonsung Koo on 2021/05/06.
//

import UIKit
import Lottie
import GoogleMobileAds
import RxSwift

final class PlayViewController: BaseViewController {
    
    @IBOutlet weak var animationView: AnimationView!
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var repeatSwitch: UISwitch!
    @IBOutlet weak var progressSlider: UISlider!
    @IBOutlet weak var adView: UIView!
    
    private let _disposeBag: DisposeBag = DisposeBag()
    var selectedAnimationViewModel: SelectedAnimationViewModel!
    
    static func instantiate(viewModel: SelectedAnimationViewModel) -> PlayViewController? {
        
        let storyBoard = UIStoryboard.init(name: StoryBoard.Main.rawValue, bundle: .main)
        
        guard let playViewController = storyBoard.instantiateViewController(identifier: PlayViewController.className) as? PlayViewController else { return nil }
        
        playViewController.selectedAnimationViewModel = viewModel
        
        return playViewController
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        _bind()
        _adReqeust()
        
    }
    
    private func _bind() {
        selectedAnimationViewModel.output.animation
            .asDriver()
            .map({ $0?.animationFilePath ?? Bundle.main.path(forResource: "LottieLogo1", ofType: "json")! })
            .drive(onNext: { [weak self] animationFilePath in
                self?.animationView.animation = Animation.filepath(animationFilePath)
                self?.progressSlider.value = 0
            }, onCompleted: nil, onDisposed: nil)
            .disposed(by: _disposeBag)
        
        var displayLink: CADisplayLink?
        
        playButton.rx.tap
            .asDriver()
            .drive(onNext: { [weak self] in
                
                guard let self = self else { return }
                
                if self.animationView.isAnimationPlaying {
                    self.animationView.pause()
                    displayLink?.invalidate()
                    self.playButton.isSelected = false
                } else {
                    
                    displayLink = CADisplayLink(target: self, selector: #selector(self._sliderUpdate))
                    displayLink?.add(to: RunLoop.current, forMode: RunLoop.Mode.common)
                    
                    self.playButton.isSelected = true
                    self.animationView.play(completion: { _ in
                        displayLink?.invalidate()
                        self.playButton.isSelected = false
                    })
                }
            }, onCompleted: nil, onDisposed: nil)
            .disposed(by: _disposeBag)
        
        repeatSwitch.rx.value
            .asDriver()
            .drive(onNext: { [weak self] isRepeat in
                self?.animationView.loopMode = isRepeat ? .loop : .playOnce
            }, onCompleted: nil, onDisposed: nil)
            .disposed(by: _disposeBag)
        
        progressSlider.rx.value
            .asDriver()
            .drive(onNext: { [weak self] progressValue in
                self?.animationView.currentProgress = CGFloat(progressValue)
            }, onCompleted: nil, onDisposed: nil)
            .disposed(by: _disposeBag)
    }
    
    @objc private func _sliderUpdate() {
        progressSlider.value = Float(animationView.realtimeAnimationProgress)
    }
    
    private func _adReqeust() {
        App.canAdsShowing
            .asDriver()
            .filter{( $0 )}
            .drive(onNext: { [weak self] _ in

                guard let self = self else { return }

                let banner = GADBannerView(frame: self.adView.bounds)

                banner.adUnitID = GAD_IDs.banner_Uint_ID
                banner.rootViewController = self
                banner.load(GADRequest())

                self.adView.addSubview(banner)
                
            }, onCompleted: nil, onDisposed: nil)
            .disposed(by: _disposeBag)
    }
}
