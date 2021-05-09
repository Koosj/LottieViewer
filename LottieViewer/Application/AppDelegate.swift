//
//  AppDelegate.swift
//  LottieViewer
//
//  Created by Bonsung Koo on 2021/05/06.
//

import UIKit
import Firebase
import SwiftyBeaver
import AppTrackingTransparency

let log = SwiftyBeaver.self

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        let console = ConsoleDestination()
        
        console.format = "$DHH:mm:ss.SSS$d $C$L$c $N.$F:$l - $M"
        console.minLevel = .debug
        console.asynchronously = false
        
        log.addDestination(console)
        
        FirebaseApp.configure()
        
        if ATTrackingManager.trackingAuthorizationStatus == .authorized {
            GADMobileAds.sharedInstance().start { adSatus in
                App.canAdsShowing.accept(true)
            }
        }
        
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}

