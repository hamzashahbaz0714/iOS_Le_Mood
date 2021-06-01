//
//  MoodModel.swift
//  Le Mood
//
//  Created by Hamza Shahbaz on 25/05/2021.
//

import UIKit

class MoodModel{
    var moodId: String
    var moodType: String
    var moodValue: Int
    var time: String
    var date: String
    var country: String
    var state: String
    
    init(moodId: String, moodType: String, moodValue: Int, time: String, date: String, country: String, state: String) {
        self.moodId = moodId
        self.moodType = moodType
        self.moodValue = moodValue
        self.time = time
        self.date = date
        self.country = country
        self.state = state
        
    }
}
