//
//  ChatsCell.swift
//  Sculpt
//
//  Created by Hamza Shahbaz on 19/01/2021.
//

import UIKit


enum bubbleType {
    case incoming
    case outgoing
}

class ChatsTextCell: UITableViewCell {

    @IBOutlet weak var bubbleView: UIView!
    @IBOutlet weak var chatStack: UIStackView!
    @IBOutlet weak var txtView: UITextView!
    @IBOutlet weak var lblTime: UILabel!
    
        
    override func awakeFromNib() {
        super.awakeFromNib()
        bubbleView.layer.cornerRadius = 10
    }
    
    func setData(message: Message){
        txtView.text = message.messageBody
        lblTime.text = message.messageDate
    }
    
    func setBubble(type: bubbleType) {
        if type == .outgoing {
            bubbleView.backgroundColor = #colorLiteral(red: 0.7098039216, green: 0.7960784314, blue: 0.8352941176, alpha: 1)
            chatStack.alignment = .trailing
        }
        else
        {
            bubbleView.backgroundColor = #colorLiteral(red: 0.8745098039, green: 0.8745098039, blue: 0.8745098039, alpha: 1)
            chatStack.alignment = .leading
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
