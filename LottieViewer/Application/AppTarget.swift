//
//  AppTarget.swift
//  LottieViewer
//
//  Created by Bonsung Koo on 2021/05/06.
//

import Foundation

struct Build {
    enum Config: String {
        case dev = "dev"
        case production = "production"
    }
    
    var config: Config {
        get {
            if let config = Bundle.main.object(forInfoDictionaryKey: "BuildMode") as? String {
                return Config(rawValue: config) ?? .dev
            } else {
                return .dev
            }
        }
    }
}
