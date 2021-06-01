//
//  ContactCell.swift
//  SlideApp
//
//  Created by Bukhari Syed Saood on 3/10/21.
//

import UIKit

class ContactCell: UITableViewCell {

    //MARK:- Properties
    
    @IBOutlet weak var btnInviteChat: UIButton!
    @IBOutlet weak var MessageView: UIView!
    @IBOutlet weak var lblContactName: UILabel!
    @IBOutlet weak var lblContactNo: UILabel!
    @IBOutlet weak var userImgView: UIImageView!
    @IBOutlet weak var moodImageView: UIImageView!
    @IBOutlet weak var moodValue: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        MessageView.roundCorners(corners: [.topLeft, .bottomRight], radius: 18)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    
}
