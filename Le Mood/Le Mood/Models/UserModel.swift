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
    var fcmToken = ""
    
    init(id:String ,name: String, email: String, phoneNumber: String ,image: String ,gender: String ,country: String, region: String) {
        self.id = id
        self.name = name
        self.email = email
        self.phoneNumber = phoneNumber
        self.image = image
        self.gender = gender
        self.country = country
        self.region = region
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
