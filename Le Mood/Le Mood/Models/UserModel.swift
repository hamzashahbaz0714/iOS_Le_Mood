//
//  UserModel.swift
//  Megma
//
//  Created by Hamza Shahbaz on 07/01/2021.
//

import UIKit

class User {
    
    var id: String
    var name: String
    var email: String
    var image: String
    var gender: String
    var country: String
    var region: String
    
    
    init(id:String ,name: String, email: String, image: String ,gender: String ,country: String, region: String) {
        self.id = id
        self.name = name
        self.email = email
        self.image = image
        self.gender = gender
        self.country = country
        self.region = region
    }
}
