//
//  ViewModelType.swift
//  LottieViewer
//
//  Created by Bonsung Koo on 2021/05/06.
//

import Foundation
import RxSwift

protocol ViewModelType {
    
    associatedtype Input
    associatedtype Output
    
    var disposeBag: DisposeBag { get set }
    
    var input: Input { get }
    var output: Output { get }
    
    init()
}
