//
//  App.swift
//  LottieViewer
//
//  Created by Bonsung Koo on 2021/05/06.
//

import Foundation
import RxSwift
import RxCocoa

final class App {
    static let build: Build = Build()
    static let canAdsShowing = BehaviorRelay<Bool>(value: false)
}
