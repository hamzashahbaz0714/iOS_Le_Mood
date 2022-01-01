//
//  PushNotificationManager.swift
//  Wind Searched
//
//  Created by Hamza Shahbaz on 30/04/2021.
//  Copyright © 2021 Hamza Shahbaz. All rights reserved.
//

import Firebase
import FirebaseFirestore
import FirebaseMessaging
import UIKit
import UserNotifications
import LocalAuthentication

class PushNotificationManager: NSObject, MessagingDelegate, UNUserNotificationCenterDelegate {
    
    var defaults = UserDefaults.standard
    let center = UNUserNotificationCenter.current()
    
    let userID: String
    init(userID: String) {
        self.userID = userID
        super.init()
    }
    
    
    func registerForPushNotifications() {
        UNUserNotificationCenter.current().delegate = self
        if #available(iOS 10.0, *) {
            // For iOS 10 display notification (sent via APNS)
            let replyAction = UNTextInputNotificationAction(identifier: "click_action", title: "message", options: [], textInputButtonTitle: "Send", textInputPlaceholder: "type something …")
            
            let pushNotificationButtons = UNNotificationCategory(
                identifier: "mood_click_action_chat",
                actions: [replyAction],
                intentIdentifiers: [],
                options: [])
            
            
            
            UNUserNotificationCenter.current().setNotificationCategories([pushNotificationButtons])
            let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
            UNUserNotificationCenter.current().requestAuthorization(
                options: authOptions,
                completionHandler: {_, _ in })
            // For iOS 10 data message (sent via FCM)
            Messaging.messaging().delegate = self
            Messaging.messaging().token { token, error in
                if let error = error {
                    print("Error fetching FCM registration token: \(error)")
                } else if let token = token {
                    print("FCM registration token: \(token)")
                    let usersRef = Firestore.firestore().collection("users").document(self.userID)
                    usersRef.setData(["fcmToken": token], merge: true)
                    if self.defaults.bool(forKey: "WatchWalkThrough") == true {
                        // setupNotification()
                    }
                }
            }
        } else {
            let settings: UIUserNotificationSettings =
            UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
            UIApplication.shared.registerUserNotificationSettings(settings)
        }
        
        UIApplication.shared.registerForRemoteNotifications()
        updateFirestorePushTokenIfNeeded()
        if defaults.bool(forKey: "LocalNotification") != true {
            defaults.set(true, forKey: "LocalNotification")
            setupNotification()
        }
    }
    
    func updateFirestorePushTokenIfNeeded() {
        
        if let token = Messaging.messaging().fcmToken {
            let usersRef = Firestore.firestore().collection("users").document(userID)
            usersRef.setData(["fcmToken": token], merge: true)
        }
    }
    
    
    
    //    didrec
    //    func messaging(_ messaging: Messaging, didReceive remoteMessage: Messaging) {
    //        print(remoteMessage.apnsToken)
    //    }
    
    func setupNotification(){
        let content = UNMutableNotificationContent()
        content.title = "Mood Submission"
        content.body = "Have you submitted your mood?"
        content.sound = UNNotificationSound.default
        var dateComponents = DateComponents()
        dateComponents.hour = 09
        dateComponents.minute = 30
        let ri = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: ri)
            center.add(request)
    }
    
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        updateFirestorePushTokenIfNeeded()
        
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        print(notification)
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        print("Coming hereeee/÷÷÷÷÷//")
//        if UIApplication.shared.applicationState == .inactive {
//            UIApplication.shared.applicationState = .background
//        }
        if let userInfo = response.notification.request.content.userInfo as? [String:Any]{
            let senderID = userInfo["sender"] as? String ?? ""
            let receiverID = userInfo["receiver"] as? String ?? ""
            let chatId = userInfo["combineId"] as? String ?? ""
            let isComefromRandomORMyCHat = userInfo["isComefromRandomORMyCHat"] as? Bool ?? false
            let token = userInfo["fcmToken"] as? String ?? ""
            let deviceType = userInfo["deviceType"] as? String ?? ""
            print(senderID,receiverID,chatId,isComefromRandomORMyCHat,token,deviceType)
            print(userInfo)
            if let textResponse =  response as? UNTextInputNotificationResponse {
                let sendText =  textResponse.userText
                print("Received text message: \(sendText)")
                let sender = PushNotificationSender()
                sender.sendPushNotification(deviceType: deviceType, senderToken: DataService.instance.currentUser.fcmToken, chatId:chatId,isComefromRandomORMyCHat: isComefromRandomORMyCHat, receiver: senderID, to:  token, title: "\(DataService.instance.currentUser!.name)", body: sendText,unread: 1)
                let message = Message(messageId: getUniqueId(), reciverId: senderID, senderId: receiverID, messageBody:sendText, messageType: "text", messageTime: getCurrentTime(), messageDate: getCurrentDateWithTime(), isIncoming: false)
                DataService.instance.addChatMessage(isComefromRandomORMyCHat: isComefromRandomORMyCHat, chatID: chatId, message: message,notReadBy: [receiverID],senderName: DataService.instance.currentUser.name,senderImage: DataService.instance.currentUser.image)
               
            }
        }
        
        
        NotificationCenter.default.post(name: TO_NOTIF_NTOFICATION_RECIEVED, object: nil, userInfo: nil)
        print(response)
    }
    
}
