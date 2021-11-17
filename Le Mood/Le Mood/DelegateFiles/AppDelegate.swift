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
    var defaults = UserDefaults.standard
    let center = UNUserNotificationCenter.current()
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
//        let replyAction = UNNotificationAction(
//            identifier: "reply.action",
//            title: "Reply to this message",
//            options: [])
        let replyAction = UNTextInputNotificationAction(identifier: "reply.action", title: "message", options: [], textInputButtonTitle: "Send", textInputPlaceholder: "type something …")
        
        let pushNotificationButtons = UNNotificationCategory(
            identifier: "new_podcast_available",
            actions: [replyAction],
            intentIdentifiers: [],
            options: [])
        
        UNUserNotificationCenter.current().setNotificationCategories([pushNotificationButtons])
        
        
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
        
        if defaults.bool(forKey: "WatchWalkThrough") == true {
            setupNotification()
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
    
    func setupNotification(){
        let content = UNMutableNotificationContent()
        let calendar = Calendar.current
        content.title = "Confirm that"
        content.body = "Have you submitted your mood today?"
        content.sound = UNNotificationSound.default
        var dateComponents = DateComponents()
        let date = calendar.date(from: dateComponents)
        let comp2 = calendar.dateComponents([.year,.month,.day,.hour,.minute], from: date!)
        dateComponents.hour = 14
        dateComponents.minute = 52
        let ri = UNCalendarNotificationTrigger(dateMatching: comp2, repeats: true)
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: ri)
        center.add(request)
    }
    
}


@available(iOS 10, *)
extension AppDelegate : UNUserNotificationCenterDelegate {
    
    
    
    // Receive displayed notifications for iOS 10 devices.
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        let userInfo = notification.request.content.userInfo
        
        // With swizzling disabled you must let Messaging know about the message, for Analytics
        // Messaging.messaging().appDidReceiveMessage(userInfo)
        
        // ...
        
        print("askbfsklbvsbdfolsvbod")
        // Print full message.
        print(userInfo)
        
        // Change this to your preferred presentation option
        completionHandler([.sound,.badge,.list,.banner])
        completionHandler([[.banner, .sound]])
    }
    
 
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        if let textResponse =  response as? UNTextInputNotificationResponse {
            let sendText =  textResponse.userText
            print("Received text message: \(sendText)")
        }
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any],
                     fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        if let messageID = userInfo[gcmMessageIDKey] {
            print("Message ID: \(messageID)")
        }
        
        // Print full message.
        print(userInfo)
        
        switch UIApplication.shared.applicationState {
        case .active:
            print("coming here...")
            //app is currently active, can update badges count here
            break
        case .inactive:
            print("coming here...22")
            //app is transitioning from background to foreground (user taps notification), do what you need when user taps here
            break
        case .background:
            print("coming here...333")
            //app is in background, if content-available key of your notification is set to 1, poll to your backend to retrieve data and update your interface here
            break
        default:
            break
        }
        completionHandler(UIBackgroundFetchResult.newData)
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
