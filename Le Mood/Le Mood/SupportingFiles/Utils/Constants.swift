//
//  Constants.swift
//  Waldaa
//
//  Created by Malik Javed Iqbal on 07/12/2020.
//

import UIKit


let placeHolderLeage = UIImage(named: "bet_icon")
let placeHolderArtistImage = UIImage(named: "2")
let menuArr = [["image": UIImage(named: "icon_user_profile")!,"name":"Profile"],["image": UIImage(named: "icon_transactions")!,"name":"Transactions"],["image": UIImage(named: "icon_settings")!,"name":"Settings"]]
let sportArray = [["name": "NBA-Basketball", "image": UIImage(named: "icon_basketball")!],["name": "MLB-Baseball", "image": UIImage(named: "icon_baseball")!],["name": "NFL-Football", "image": UIImage(named: "icon_football")!],["name": "FIFA-Soccer", "image": UIImage(named: "icon_football")!],["name": "NHL-Ice Hockey", "image": UIImage(named: "icon_hockey")!]]

typealias CompletionHandlerWithError = (_ success: Bool, _ error: Error?) -> ()
typealias CompletionHandler = (_ success: Bool) -> ()

var placeHolderImage = UIImage(named: "user_placeholder")

enum albumType: String {
    case newAlbum = "get-new-albums"
    case allAlbum = "get-all-albums"
    case weeklyCollection = "weekly-selection"

}

func getCurrentYear() -> String{
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy"
    return (formatter.string(from: Date()))
}

func getCurrentDate() -> String{
    let currentDateTime = Date()
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy-MM-dd"
    return (formatter.string(from: currentDateTime))
}
func currentdateToaddOnday() -> String{
    let currentDate = Date()
    var dateComponent = DateComponents()
    dateComponent.day = 1
    let futureDate = Calendar.current.date(byAdding: dateComponent, to: currentDate)
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy-MM-dd"
   return ((formatter.string(from: futureDate!)))
}

struct Currency {

    private static let formatter: NumberFormatter = {
        let formatter         = NumberFormatter()
        formatter.numberStyle = .currency
        return formatter
    }()
    
    static func stringFrom(_ decimal: Decimal, currency: String? = nil) -> String {
        return self.formatter.string(from: decimal as NSDecimalNumber)!
    }
}

func getdatefromUNixTimes(time: Double) -> String{
    let unixTimeStamp = time
    let exactDate = NSDate.init(timeIntervalSince1970: unixTimeStamp)
    let dateFormatt = DateFormatter()
    dateFormatt.dateFormat = "dd/MM/yyy hh:mm a"
    return dateFormatt.string(from: exactDate as Date)

}
