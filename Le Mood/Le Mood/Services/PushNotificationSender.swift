//
//  PushNotificationSender.swift
//  Wind Searched
//
//  Created by Hamza Shahbaz on 30/04/2021.
//  Copyright © 2021 Hamza Shahbaz. All rights reserved.
//

import Foundation
import UIKit
import FirebaseAuth
class PushNotificationSender {
    func sendPushNotification(deviceType: String,senderToken:String,chatId:String,isComefromRandomORMyCHat:Bool,receiver: String,to token: String, title: String, body: String,unread:Int) {
        
        var param = [String:Any]()
        let urlString = "https://fcm.googleapis.com/fcm/send"
        let url = NSURL(string: urlString)!
        if deviceType == "ios" {
            let paramString: [String : Any] = ["to" : token,
                                               "notification":
                                                ["title" : title,
                                                 "body" : body,
                                                 "badge" : unread,
                                                 "sound":1,
                                                 "click_action":"mood_click_action_chat",
                                                 "priority" : "high",
                                                 "content_available" : true
                                                ],
                                               "data" : ["sender" : Auth.auth().currentUser!.uid,
                                                         "receiver":receiver,
                                                         "isComefromRandomORMyCHat":isComefromRandomORMyCHat,
                                                         "combineId":chatId,
                                                         "fcmToken":senderToken,
                                                         "click_action":"mood_click_action_chat",
                                                         "notiType": "text",
                                                         "deviceType":"ios"
                                                        ]
            ]
            param = paramString
        }
        else{
            let paramString: [String : Any] = ["to" : token,
                                               "data" : ["sender" : Auth.auth().currentUser!.uid,
                                                         "receiver":receiver,
                                                         "isComefromRandomORMyCHat":isComefromRandomORMyCHat,
                                                         "combineId":chatId,
                                                         "fcmToken":senderToken,
                                                         "click_action":"mood_click_action_chat",
                                                         "notiType": "text",
                                                         "title" : title,
                                                         "body" : body,
                                                         "badge" : unread,
                                                         "sound":1,
                                                         "priority" : "high",
                                                         "content_available" : true,
                                                         "deviceType":"ios"
                                                        ]
            ]
            param = paramString
            print(paramString)
        }
        let request = NSMutableURLRequest(url: url as URL)
        request.httpMethod = "POST"
        request.httpBody = try? JSONSerialization.data(withJSONObject:param, options: [.prettyPrinted])
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("key=AAAAc1XHMcQ:APA91bEule6sotrkvT9-ISNTHKwM-QAkvbSQ3F52FgZX6F0yscoUkYFp2nWVmYGAoHxfWOwtf_7Sl7gguaObEeBNmztetgcTvY56sNVEgTTA-dgddcZ94KhN2jETVGoegACFmnEtw3Xz", forHTTPHeaderField: "Authorization")
        let task =  URLSession.shared.dataTask(with: request as URLRequest)  { (data, response, error) in
            if error == nil {
                do {
                    if let jsonData = data {
                        if let jsonDataDict  = try JSONSerialization.jsonObject(with: jsonData, options: JSONSerialization.ReadingOptions.allowFragments) as? [String: AnyObject] {
                           NSLog("Received data:\n\(jsonDataDict))")
                            param.removeAll()
                            print(jsonDataDict)
                        }
                    }
                    else{
                        print(error?.localizedDescription ?? "")
                    }
                } catch let err as NSError {
                    print(err.debugDescription)
                }
            }
            else{
                print(error?.localizedDescription ?? "")
            }
        }
        task.resume()
    }
}




