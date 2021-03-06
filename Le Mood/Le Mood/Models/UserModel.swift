//
//  UserModel.swift
//  Megma
//
//  Created by Hamza Shahbaz on 07/01/2021.
//

import UIKit

class UserModel {

    var id: String
    var name: String
    var nikName: String
    var email: String
    var phoneNumber: String
    var image: String
    var gender: String
    var deviceType: String
    var country: String
    var region: String
    var moodId: String
    var moodType: String
    var moodValue: Int
    var lastMoodDate: String
    var fcmToken : String
    var language: String
    var isMoodVisible: Bool
    
    init(id: String, name: String, nikName: String, email: String, phoneNumber: String, image: String, gender: String, deviceType: String, country: String, region: String, moodId: String, moodType: String, moodValue: Int, lastMoodDate: String, fcmToken: String, language: String, isMoodVisible: Bool) {
       self.id = id
       self.name = name
       self.nikName = nikName
       self.email = email
       self.phoneNumber = phoneNumber
       self.image = image
       self.gender = gender
       self.deviceType = deviceType
       self.country = country
       self.region = region
       self.moodId = moodId
       self.moodType = moodType
       self.moodValue = moodValue
       self.lastMoodDate = lastMoodDate
       self.fcmToken = fcmToken
       self.language = language
       self.isMoodVisible = isMoodVisible
   }
}


class ContactsModel {
    var name : String
    var phoneNumber: String
    
    init(name: String, phoneNumber: String) {
        self.phoneNumber = phoneNumber
        self.name = name
    }
}
