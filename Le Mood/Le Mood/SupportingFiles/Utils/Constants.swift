//
//  Constants.swift
//  Waldaa
//
//  Created by Malik Javed Iqbal on 07/12/2020.
//

import UIKit
import AVKit

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

func getTime() -> String {
    let formatter = DateFormatter()
    formatter.dateFormat = "h:mm a"
    return (formatter.string(from: Date()))
}

func getCurrentDate() -> String{
    let currentDateTime = Date()
    let formatter = DateFormatter()
    formatter.dateFormat = "dd/MM/yyyy"
    return (formatter.string(from: currentDateTime))
}
func getUniqueId(length: Int = 20) -> String {
   let base = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
   var randomString: String = ""

   for _ in 0..<length {
       let randomValue = arc4random_uniform(UInt32(base.count))
       randomString += "\(base[base.index(base.startIndex, offsetBy: Int(randomValue))])"
   }
   return randomString
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

func getCurrentDateWithTime() -> String{
    let formatter = DateFormatter()
    formatter.dateStyle = .medium
    formatter.timeStyle = .short
    return (formatter.string(from: Date()))
}
func getCurrentTime() -> Int{
    let time = Date().timeIntervalSince1970
    print(Int(time))
    return Int(time)
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

func getThumbnailImageFromVideoUrl(url: URL, completion: @escaping ((_ image: UIImage?)->Void)) {
    DispatchQueue.global().async { //1
        let asset = AVAsset(url: url) //2
        let avAssetImageGenerator = AVAssetImageGenerator(asset: asset) //3
        avAssetImageGenerator.appliesPreferredTrackTransform = true //4
        let thumnailTime = CMTimeMake(value: 2, timescale: 1) //5
        do {
            let cgThumbImage = try avAssetImageGenerator.copyCGImage(at: thumnailTime, actualTime: nil) //6
            let thumbImage = UIImage(cgImage: cgThumbImage) //7
            DispatchQueue.main.async { //8
                completion(thumbImage) //9
            }
        } catch {
            print(error.localizedDescription) //10
            DispatchQueue.main.async {
                completion(nil) //11
            }
        }
    }
}
