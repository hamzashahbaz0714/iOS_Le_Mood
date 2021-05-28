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
    func sendPushNotification(to token: String, title: String, body: String,unread:Int) {
        let urlString = "https://fcm.googleapis.com/fcm/send"
        let url = NSURL(string: urlString)!
        let paramString: [String : Any] = ["to" : token,
                                           "notification" : ["title" : title, "body" : body, "badge" : unread, "sound":1],
                                           "data" : ["user" : Auth.auth().currentUser!.uid]
        ]
        let request = NSMutableURLRequest(url: url as URL)
        request.httpMethod = "POST"
        request.httpBody = try? JSONSerialization.data(withJSONObject:paramString, options: [.prettyPrinted])
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("key=AAAAl4LXQvU:APA91bG_Nj-2Jin-QVFlFPtMdpWCYX_gbnW6mKgTUESNdZstq7dZBNdQs0u01NTL12YqhcSEwi38tel_vNy7es6q-HZU5LEqDntODwgUmoqzIJGQOz3PKuO_92dRauc8fktp1CWa_i58", forHTTPHeaderField: "Authorization")
        let task =  URLSession.shared.dataTask(with: request as URLRequest)  { (data, response, error) in
            do {
                if let jsonData = data {
                    if let jsonDataDict  = try JSONSerialization.jsonObject(with: jsonData, options: JSONSerialization.ReadingOptions.allowFragments) as? [String: AnyObject] {
                        NSLog("Received data:\n\(jsonDataDict))")
                    }
                }
            } catch let err as NSError {
                print(err.debugDescription)
            }
        }
        task.resume()
    }
}
