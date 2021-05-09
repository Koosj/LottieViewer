//
//  NSObjectProtocol+Extension.swift
//  LottieViewer
//
//  Created by Bonsung Koo on 2021/05/06.
//

import Foundation

extension NSObjectProtocol {
    static var className: String {
        return String(describing: self)
    }
}
