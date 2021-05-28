//
//  PushNotificationManager.swift
//  Wind Searched
//
//  Created by Hamza Shahbaz on 30/04/2021.
//  Copyright © 2021 Hamza Shahbaz. All rights reserved.
//

import Firebase
import FirebaseFirestore
//import FirebaseMessaging
import UIKit
import UserNotifications

//class PushNotificationManager: NSObject, MessagingDelegate, UNUserNotificationCenterDelegate {
//    let userID: String
//    init(userID: String) {
//        self.userID = userID
//        super.init()
//    }
//    
//
//    func registerForPushNotifications() {
//        if #available(iOS 10.0, *) {
//            // For iOS 10 display notification (sent via APNS)
//            UNUserNotificationCenter.current().delegate = self
//            let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
//            UNUserNotificationCenter.current().requestAuthorization(
//                options: authOptions,
//                completionHandler: {_, _ in })
//            // For iOS 10 data message (sent via FCM)
//            Messaging.messaging().delegate = self
//            
//            Messaging.messaging().token { token, error in
//              if let error = error {
//                print("Error fetching FCM registration token: \(error)")
//              } else if let token = token {
//                print("FCM registration token: \(token)")
//                let usersRef = Firestore.firestore().collection("users").document(self.userID)
//                usersRef.setData(["fcmToken": token], merge: true)
////                let sender = PushNotificationSender()
////                sender.sendPushNotification(to: "eE3XOPOQ50u-v8e6EPrVD4:APA91bF61ygDsRjUPvFdPYtXjzMX8wJjVGJQRpdE1J2StJ1dvQrRicE4sFpYYmRjqe5Lvp7aQSxWbB8Q6vM9JUMZpaopEXfm1_5fr3UyQsbTfbBUcP5gwpREdvmVdYHvcgwTgIuHJZqK", title: "New Message", body: "New Message sent")
//              }
//            }
//        } else {
//            let settings: UIUserNotificationSettings =
//                UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
//            UIApplication.shared.registerUserNotificationSettings(settings)
//        }
//
//        UIApplication.shared.registerForRemoteNotifications()
//        updateFirestorePushTokenIfNeeded()
//    }
//    
//    func updateFirestorePushTokenIfNeeded() {
//            if let token = Messaging.messaging().fcmToken {
//                let usersRef = Firestore.firestore().collection("users").document(userID)
//                usersRef.setData(["fcmToken": token], merge: true)
//            }
//        }
//
// 
//
////    didrec
////    func messaging(_ messaging: Messaging, didReceive remoteMessage: Messaging) {
////        print(remoteMessage.apnsToken)
////    }
//
//    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
//        updateFirestorePushTokenIfNeeded()
//        
//    }
//    
//    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
//        print("Coming hereeee/÷÷÷÷÷//")
//        NotificationCenter.default.post(name: TO_NOTIF_NTOFICATION_RECIEVED, object: nil, userInfo: nil)
//        print(response)
//    }
//}
