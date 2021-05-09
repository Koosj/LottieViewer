//
//  SupportDeveloperViewModel.swift
//  LottieViewer
//
//  Created by Bonsung Koo on 2021/05/07.
//

import Foundation
import RxSwift
import RxCocoa

final class SupportDeveloperViewModel: ViewModelType {
   
    struct Input {
        var supportDeveloper: PublishRelay<[SupportDeveloperModel]>
    }
    
    struct Output {
        var supportDeveloper: Driver<[SupportDeveloperModel]>
    }
    
    var disposeBag = DisposeBag()
    let input: Input
    let output: Output
    
    private let _inputSupportDeveloper = PublishRelay<[SupportDeveloperModel]>()
    private var _outputSupportDeveloper = BehaviorRelay<[SupportDeveloperModel]>(value: [])
    
    init() {
        input = Input(supportDeveloper: _inputSupportDeveloper)
        output = Output(supportDeveloper: _outputSupportDeveloper.asDriver())

        _inputSupportDeveloper
            .map({ supportDeveloperModel in
                
                var newSupportDeveloperModel = supportDeveloperModel
                
                newSupportDeveloperModel.sort { model1, model2 in
                    guard let title1 = model1.product?.productIdentifier, let title2 = model2.product?.productIdentifier else { return true }
                    if title1.contains("candy") {
                        return true
                    } else if title2.contains("candy") {
                        return false
                    } else if title1.contains("coffee"), title2.contains("beer") {
                        return true
                    } else {
                        return false
                    }
                }
                
                let allowAdTracker = SupportDeveloperModel(product: nil)
                newSupportDeveloperModel.append(allowAdTracker)
                
                return newSupportDeveloperModel
            })
            .bind(to: _outputSupportDeveloper)
            .disposed(by: disposeBag)
    }
}
