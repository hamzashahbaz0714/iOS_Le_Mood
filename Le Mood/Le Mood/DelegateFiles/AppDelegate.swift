//
//  AppDelegate.swift
//  Le Mood
//
//  Created by Hamza Shahbaz on 03/05/2021.
//

import UIKit
import FirebaseCore
import IQKeyboardManager
import FirebaseAuth
import FirebaseMessaging
import UserNotificationsUI
import ProgressHUD


@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var selectLanguage = [String]()
    let gcmMessageIDKey = "gcm.Message_ID"
    var isMoodFetched : Bool?
    var mood: MoodModel?
    var countries: CountriesStatesModel?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        Messaging.messaging().delegate = self
        ProgressHUD.colorAnimation = #colorLiteral(red: 0.05882352963, green: 0.180392161, blue: 0.2470588237, alpha: 1)
        ProgressHUD.animationType = .lineScaling
        FirebaseApp.configure()
        DataService.instance.loadCountriesAndStates { (sccess, country) in
            if sccess {
                self.countries = country
            }
            else
            {
                print("Not fetched")
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

extension AppDelegate:MessagingDelegate{
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        print("Firebase registration token: \(String(describing: fcmToken))")
        
        let dataDict:[String: String] = ["token": fcmToken ?? ""]
        NotificationCenter.default.post(name: Notification.Name("FCMToken"), object: nil, userInfo: dataDict)
        // TODO: If necessary send token to application server.
        // Note: This callback is fired at each app startup and whenever a new token is generated.
    }
}
