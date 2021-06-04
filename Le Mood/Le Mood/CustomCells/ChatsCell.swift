//
//  ChatsCell.swift
//  Wind Searched
//
//  Created by Hamza Shahbaz on 7/01/20.
//  Copyright © 2018 Brian Voong. All rights reserved.
//


import UIKit
import Firebase
import SDWebImage

protocol ChatsCellDelegate {
    func openProfile(uid:UserModel)
}
class ChatsCell: UITableViewCell {
    @IBOutlet weak var nameLbl:UILabel!
    @IBOutlet weak var lastMessageLbl:UILabel!
    @IBOutlet weak var profileImg:CircleImage! 
    @IBOutlet weak var timeLbl:UILabel!
    @IBOutlet weak var dotImg:UIImageView!
    
    
    var chat: Chat!
    var delegate:ChatsCellDelegate?
    var returnedUser:UserModel!
    
    func initCell(){
//        DataService.instance.getUserOfID(userID: chat.otherUser) { (success, returnedUser) in
//            if success{
//                self.returnedUser = returnedUser
//                self.nameLbl.text = returnedUser!.name
//                self.delegate?.openProfile(uid: returnedUser!)
//                self.profileImg.sd_setImage(with: URL(string: returnedUser!.image), placeholderImage: UIImage(systemName: "person.crop.circle.fill"))
//            }
//        }
//        if chat.notReadBy.contains(DataService.instance.currentUser!.id){
//            self.dotImg.isHidden = false
//        }else{
//            self.dotImg.isHidden = true
//        }
//        
        getTimeDifference()
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapFunction))
        nameLbl.addGestureRecognizer(tap)
        if chat.messageType == "text"{
            self.lastMessageLbl.text = chat.lastMessage
        }
        else if chat.messageType == "video"{
            self.lastMessageLbl.text = "video"
        }
        else if chat.messageType == "gif"{
            self.lastMessageLbl.text = "gif"
        }
        else
        {
            self.lastMessageLbl.text = "image"
        }
    }
    
    func getTimeDifference(){
        
        let start = Date()
        var time = Int(chat.lastMessageTime)
        if time >= 2147483647{
            time = time / 1000
        }
        let end = Date(timeIntervalSince1970: Double(time))
        let calendar = Calendar.current
        let unitFlags = Set<Calendar.Component>([ .second])
        let datecomponents = calendar.dateComponents(unitFlags, from: end, to: start)
        let seconds = datecomponents.second
        let min = (Int(seconds!/60))
        if min > 60{
            let hrs = min/60
            timeLbl.text = "\(hrs)h"
            if hrs > 23{
                let day = hrs/24
                timeLbl.text = "\(day)d"
            }
        }else{
            timeLbl.text = "\(min)m"
        }
        
    }
    
    @objc func tapFunction(sender:UITapGestureRecognizer) {
        self.delegate?.openProfile(uid: self.returnedUser)
    }
    
}
