//
//  SelectedAnimationViewModel.swift
//  LottieViewer
//
//  Created by Bonsung Koo on 2021/05/06.
//

import Foundation
import RxSwift
import RxCocoa

final class SelectedAnimationViewModel: ViewModelType {
    
    struct Input {
        var animation: PublishRelay<AnimationModel?>
    }
    
    struct Output {
        var animation: Driver<AnimationModel?>
    }
    
    var disposeBag = DisposeBag()
    let input: Input
    let output: Output
    
    private let _inputAnimation = PublishRelay<AnimationModel?>()
    private var _outputAnimation = BehaviorRelay<AnimationModel?>(value: nil)
    
    init() {
        input = Input(animation: _inputAnimation)
        output = Output(animation: _outputAnimation.asDriver())
        
        _inputAnimation.bind(to: _outputAnimation).disposed(by: disposeBag)
        
        _setLottieBasicAnimationRandomly()
    }
    
    private func _setLottieBasicAnimationRandomly() {
        
        let randomInt = Int.random(in: 1 ... 2)
        
        guard let filePath = Bundle.main.path(forResource: "LottieLogo\(randomInt)", ofType: "json") else { return }
        
        let selectedAnimation = AnimationModel(animationName: "Lottie Player", animationFilePath: filePath)
        
        input.animation.accept(selectedAnimation)
        
    }
}
