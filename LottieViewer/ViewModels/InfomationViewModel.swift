//
//  InfomationViewModel.swift
//  LottieViewer
//
//  Created by Bonsung Koo on 2021/05/07.
//

import Foundation
import RxSwift
import RxCocoa

final class InfomationViewModel: ViewModelType {
    struct Input {
        var infomation: PublishRelay<InfomationModel?>
    }
    
    struct Output {
        var infomation: Driver<InfomationModel?>
    }
    
    var disposeBag = DisposeBag()
    let input: Input
    let output: Output
    
    private let _inputInfomation = PublishRelay<InfomationModel?>()
    private var _outputInfomation = BehaviorRelay<InfomationModel?>(value: nil)
    
    init() {
        input = Input(infomation: _inputInfomation)
        output = Output(infomation: _outputInfomation.asDriver())
        
        _inputInfomation.bind(to: _outputInfomation).disposed(by: disposeBag)
        
        _setLottieVersion()
    }
    
    private func _setLottieVersion() {
        
        if let lottieVersion = Bundle.allFrameworks
            .first(where: { $0.bundlePath.contains("Lottie.framework") })
            .map({ $0.infoDictionary?["CFBundleShortVersionString"] as? String ?? "unknown" })
            .map({ "Lottie Version: \($0)" }){
            
            let infomationModel = InfomationModel(lottieVersion: lottieVersion)
            
            input.infomation.accept(infomationModel)
        }
    }
}
