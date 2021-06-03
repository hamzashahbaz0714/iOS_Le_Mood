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
    var email: String
    var phoneNumber: String
    var image: String
    var gender: String
    var country: String
    var region: String
    var moodId: String
    var moodType: String
    var moodValue: Int
    var lastMoodDate: String
    var fcmToken : String
    var language: String
    init(id:String ,name: String, email: String, phoneNumber: String ,image: String ,gender: String ,country: String, region: String, moodId: String,moodType: String, moodValue: Int,lastMoodDate: String,fcmToken: String,language: String) {
        self.id = id
        self.name = name
        self.email = email
        self.phoneNumber = phoneNumber
        self.image = image
        self.gender = gender
        self.country = country
        self.region = region
        self.moodId = moodId
        self.moodType = moodType
        self.moodValue = moodValue
        self.lastMoodDate = lastMoodDate
        self.fcmToken = fcmToken
        self.language = language
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
